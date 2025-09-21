# Wisecow Application

## Overview

Wisecow is a small, fun web application that displays random quotes and messages. This repository contains:

- The source code of the Wisecow application
- Dockerfile for containerization
- Kubernetes manifests for deployment
- GitHub Actions workflow for CI/CD

The project demonstrates containerization, Kubernetes deployment, and automated CI/CD pipelines.

---

## Architecture & Setup

### 1. Local Kubernetes Cluster with Kind

For development and testing, I used **[Kind](https://kind.sigs.k8s.io/)** (Kubernetes in Docker) because:

- It is **lightweight** and fast to spin up
- Perfect for local Kubernetes experimentation
- Runs entirely inside Docker, no heavy VMs needed

Since I am using **WSL (Windows Subsystem for Linux)** on my laptop, some modifications were required in the `wisecow.sh` script to ensure compatibility with WSL’s file system and environment.

---

### 2. Containerization with Docker

The application is containerized using Docker:

```bash
docker build -t vishnu5031/wisecow:latest .
docker run -p 4499:4499 vishnu5031/wisecow:latest
```

- The **Dockerfile** installs all required dependencies (`fortune`, `cowsay`, etc.)
- Sets up the working directory and exposes port `4499`

---

### 3. Kubernetes Deployment

The app is deployed to Kubernetes using manifests:

```bash
kubectl apply -f wisecow-deployment.yaml
kubectl apply -f wisecow-service.yaml
```

- **Deployment:** Creates a pod running the Wisecow container
- **Service (NodePort):** Exposes the app on port `30080` to access from the host machine

#### Verify Deployment

```bash
kubectl get pods
kubectl get services
```

---

### 4. Accessing Wisecow in Browser

Since the cluster is local, you can **expose the service** using `kubectl port-forward`:

```bash
kubectl port-forward svc/wisecow-service 4499:4499
```

- Then open your browser and go to:

```
http://localhost:4499
```

> Without port-forwarding (or NodePort), you cannot see the application output from your host machine.

---

### 5. Continuous Integration / Continuous Deployment (CI/CD)

To automate build and deployment:

- **GitHub Actions** workflow is used
- Workflow triggers **on push to `main`**
- Steps include:
  1. Checkout repository
  2. Docker login and build
  3. Push Docker image to DockerHub
  4. Deploy the latest image to **local Kind cluster**

#### Self-Hosted Runner

Since the Kind cluster is running **locally in WSL**, I used a **self-hosted GitHub Actions runner**:

- Allows the workflow to run on my local machine
- Can access the Kind cluster directly (no need for ngrok or external exposure)
- Ensures CI/CD updates the local deployment automatically

---

### 6. Screenshots

**Runner logs:**

![Runner logs](screenshots/runner_logs.png)

**Application in browser:**

![Wisecow in Browser](screenshots/wisecow_browser.png)

**Kubernetes pods and services:**

![K8s Pods](screenshots/k8s_pods.png)

> Note: Replace the screenshot placeholders with actual images from your setup.

---

## 7. How to Run Locally

1. Clone the repository:

```bash
git clone https://github.com/vishnu-03-cyber/AccuKnox_WiseCow.git
cd AccuKnox_WiseCow
```

2. Build Docker image:

```bash
docker build -t vishnu5031/wisecow:latest .
```

3. Run locally (optional):

```bash
docker run -p 4499:4499 vishnu5031/wisecow:latest
```

4. Deploy to Kind:

```bash
kubectl apply -f wisecow-deployment.yaml
kubectl apply -f wisecow-service.yaml
```

5. Expose service to access in browser:

```bash
kubectl port-forward svc/wisecow-service 4499:4499
```

6. Open browser:

```
http://localhost:4499
```

---

### 8. Notes

- Using **Kind** keeps the environment lightweight and fast for local development.
- WSL required small script modifications in `wisecow.sh` for compatibility.
- **Self-hosted runner** allows GitHub Actions to deploy directly to the local cluster without exposing it publicly.
- **Port-forwarding is required** to access the Wisecow application in your host browser.

---

### 9. References

- [Kind — Kubernetes in Docker](https://kind.sigs.k8s.io/)
- [GitHub Actions — Self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
