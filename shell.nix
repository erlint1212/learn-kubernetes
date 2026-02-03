{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

pkgs.mkShell {
  name = "k8s-env";

  # The packages you need for Kubernetes management
  buildInputs = with pkgs; [
    # --- Core Kubernetes Tools ---
    kubectl       # The command line interface for running commands against Kubernetes clusters
    kubernetes-helm # Package manager for Kubernetes (Helm charts)
    
    # --- Local Development ---
    minikube      # Run Kubernetes locally (optional, swap with 'kind' if preferred)
    kind          # Kubernetes IN Docker (alternative to minikube)

    # --- Utilities & Enhancements ---
    k9s           # Terminal UI for Kubernetes (Essential for productivity)
    kubectx       # Includes 'kubectx' and 'kubens' for switching context/namespaces quickly
    stern         # Multi-pod and container log tailing
    kustomize     # Template-free customization of Kubernetes YAML
    
    # --- Infrastructure as Code ---
    terraform     # (Optional) If you manage cloud infra alongside k8s
    # opentofu    # Open source fork of Terraform (Alternative)

    # --- Scripting & Helpers ---
    jq            # JSON processor (vital for parsing kubectl output)
    yq-go         # Portable command-line YAML processor
    fzf           # Fuzzy finder (great for history searching)
  ];

  # Setup shell aliases and autocompletion
  shellHook = ''
    echo "⎈ Welcome to the Kubernetes Shell (NixOS 25.05) ⎈"
    
    # Alias shortcuts (optional but recommended)
    alias k="kubectl"
    alias kgp="kubectl get pods"
    alias kgn="kubectl get nodes"
    alias kctx="kubectx"
    alias kns="kubens"
    alias ka="kubectl apply -f"

    # Set Kubeconfig environment variable if you have a specific config file
    # export KUBECONFIG=$PWD/kubeconfig.yaml
    
    # Enable command completion for bash/zsh
    source <(kubectl completion bash)
    source <(helm completion bash)
    complete -F __start_kubectl k
  '';
}
