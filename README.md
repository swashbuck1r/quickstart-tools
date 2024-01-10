quickstart-tools is an example of creating a custom container to install CLI tools that can be used by workflow steps.

The quickstart-tools container image provides:

* Basic tools like `bash`, `curl`, `unzip`, `jq`, and `yq`
* Cloud provider tools
 * AWS cli v2
* Kubernetes tools
 * kubectl
 * helm
 * kustomize
* Declarative infrastructure tools
 * opentofu (terraform replacement)
 * terragrunt


 Using quickstart-tools in a workflow:

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

