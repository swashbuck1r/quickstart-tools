This quickstart project shows how to create your own container image to customize the set of CLI tools that can be used by steps in your [CloudBees platform](https://www.cloudbees.com/products/saas-platform) workflow.


## Building custom container images to use with CloudBees workflows

When automating the delivery of your software components, it is often necessary to interact with custom tools that are used or provided by your own organization.  Rather than using a generic image and then installing the required tools each time your automation runs, CloudBees platform makes it easy to build your own custom container images and use those in your workflow steps.   This allows your organization to maintain custom containers with the right set of preconfigured tools so that they can be easily use by your dev teams.

Using a custom container images:

* Create a repository with the Dockerfile definition for your custom image (this repo is an example of that).
* Define a CloudBees workflow to build and publish your container image to your container registry.
* Register the repository as a component in your CloudBees platform organization.
* Each time you update the Dockerfile in your source repository, CloudBees will automatically build and publish the new container image for your dev teams to use in their workflows.
* Your CloudBees workflows can reference the custom container from workflow steps and your custom tools will be available to any commands that the steps run.


As an example of some custom tools, the Dockerfile in this repository will generate an image with the following tools pre-installed:

* General tools: `bash`, `curl`, `unzip`, `jq`, and `yq`
* Cloud provider tools
  * `aws` cli v2
* Kubernetes tools
  * `kubectl`
  * `helm`
  * `kustomize`
* Declarative infrastructure tools
  * `opentofu` (terraform replacement)
  * `terragrunt`

## Building and publishing this container image

The [.cloudbees/workflows/workflow.yaml](.cloudbees/workflows/workflow.yaml) workflow definition shows how to use CloudBees to build the [Dockerfile](./Dockerfile) definition into a container image and publish it to a container registry using the [Kaniko](https://docs.cloudbees.com/docs/cloudbees-saas-platform/latest/deploy-tools/kaniko) action.

```
apiVersion: automation.cloudbees.io/v1alpha1
kind: workflow
name: Workflow

on:
  push:
    branches:
      - '**'

jobs:
  build-and-publsh:
    steps:
      - name: checkout code
        uses: cloudbees-io/checkout@v1

      - name: Setup Dockerhub container registry
        uses: cloudbees-io/configure-oci-credentials@v1
        with:
          registry: index.docker.io # or docker.io
          username: ${{ vars.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_PASSWORD }}

      - name: Build and push container image to registry
        uses: cloudbees-io/kaniko@v1
        with:
          destination: ${{ vars.DOCKERHUB_USERNAME }}/quickstart-tools:${{ cloudbees.version }}
  
```

## Using the custom tools in a workflow

After the custom container image is published to a (publicly accessible) container registry, your workflow steps can reference this container image to use it when executing command steps.

The example below references the version of this repository that was built and published as a container image at `swashbuck1r/quickstart-go-app:0.0.4` in DockerHub.

```
apiVersion: automation.cloudbees.io/v1alpha1
kind: workflow
name: Example workflow

on:
  push:
    branches:
      - '**'

jobs:
  build-and-publsh:
    steps:
      - name: Print CLI versions
        uses: docker://swashbuck1r/quickstart-go-app:0.0.4
        shell: bash
        run: |
          kubectl version
          helm version
          kustomize version
          tofu version
          terragrunt --version
          aws --version
```

