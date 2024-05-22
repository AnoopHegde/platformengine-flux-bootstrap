# Github Selfhosted Runner Setup
## Contents

<!-- TOC start -->
  - [Prerequisites](#prerequisites)
  - [Create kind kubernetes cluster for GHA selfhosted runner](#create-kind-cluster-for-GHA-selfhosted-runner)
  - [Authenticating the runner](#authenticating-the-runner)
  - [Setup the Fluxcd GitOps](#setup-fluxcd-gitops)
  - [Installing Actions Runner Controller](#installing-Actions-Runner-Controller)
  - [Configure a runner scale set](#configuring-runner-scale-set)
  - [Verify the Runner Installation](#verify-the-Runner-Installation)
  - [Reference Links](#reference-Links)

  <!-- TOC end -->

  ## Prerequisites
  
  1. Create a new free tier Organization and link that organization with trial Enterprise account.
  2. Create a new repository for building and pushing custom actions-runner-image.
  3. Create a new github apps under organizational level and install them to get the appID, appInstallationID, client_secret
     private key.

  ## Create kind kubernetes cluster for GHA selfhosted runner

  We need to setup two different kind kubernetes cluster ingress Nginx both for npd and prd environments.

  Command to setup:

  ```
  kind create cluster --name gha-selfhosted-cluster --config=gha-selfhosted.yaml
  kubectl cluster-info --context kind-gha-selfhosted-cluster

  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

  kubectl get po  -A --context kind-gha-selfhosted-cluster
  kubectl get svc -A --context kind-gha-selfhosted-cluster
  kubectl get ing -A --context kind-gha-selfhosted-cluster

  kind create cluster --name gha-selfhosted-cluster-prd --config=gha-selfhosted-prd.yaml
  kubectl cluster-info --context kind-gha-selfhosted-cluster-prd

  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

  kubectl get po  -A --context kind-gha-selfhosted-cluster-prd
  kubectl get svc -A --context kind-gha-selfhosted-cluster-prd
  kubectl get ing -A --context kind-gha-selfhosted-cluster-prd

  ```
     
  ## Authenticating the runner

  We are using GitHub App method for authenticating GitHub to Action Runner Controller.

  1. As an owner of the Organizational Repository we will be having an access to create our own github apps. Get the credentials of a new GitHub App.
  2. GitHub Apps can be installed in user,repository,organizational levels based on the end-user preferences.
  3. Generate a Kubernetes secret "pe-github-secret" within the GHA runner cluster using the App_ID, App_Installation_ID, Private_key.
   
  Screenshots:

  ![GHA Selfthosted runner status](/images/gha-selfhosted-runner-status.png "GHA Selfthosted runner status")

   

  ## Setup the Fluxcd GitOps

  ## Installing Actions Runner Controller

  ## Configure a runner scale set

  ## Verify the Runner Installation

  ## Reference Links

