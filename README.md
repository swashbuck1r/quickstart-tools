quickstart-tools is an example of creating a custom container to install CLI tools that can be used by workflow steps.

The quickstart-tools container image provides:

* Basic tools like `bash`, `curl`, `unzip`, `jq`, and `yq`
* Cloud provider tools
 * AWS cli v2
* Kubernetes tools
 * kubectl
 * helm
 * kustomize
* Infrastructure tools
 * opentofu (terraform replacement)
 * terragrunt