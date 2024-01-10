This quickstart project shows how to create your own container image to customize the set of CLI tools that can be used by steps in your CloudBees workflow.

The Dockerfile in this repository will generate an image with the following tools pre-installed:

* General tools: `bash`, `curl`, `unzip`, `jq`, and `yq`
* Cloud provider tools
 * AWS cli v2
* Kubernetes tools
 * `kubectl`
 * `helm`
 * `kustomize`
* Declarative infrastructure tools
 * `opentofu` (terraform replacement)
 * `terragrunt`

## Building and publishing this container image

The .cloudbees/workflows/workflow.yaml files shows how to use CloudBees to build the Dockerfile definition into a container image and publish it to a container registry.

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

