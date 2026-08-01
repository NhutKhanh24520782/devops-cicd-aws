# Kubernetes Manifests

This directory contains the production-ready Kubernetes manifests organized by component for the DevOps portfolio project.

## Directory Structure

```text
kubernetes/
├── namespace.yaml
├── config/
│   ├── configmap.yaml
│   └── secret.yaml
├── mongodb/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── pvc.yaml
├── backend/
│   ├── deployment.yaml
│   └── service.yaml
├── frontend/
│   ├── deployment.yaml
│   └── service.yaml
├── network/
│   └── ingress.yaml
├── autoscaling/
│   └── backend-hpa.yaml
└── README.md
```

## How to Apply Manifests

```bash
# Apply in order
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/config/
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
kubectl apply -f kubernetes/frontend/
kubectl apply -f kubernetes/network/
kubectl apply -f kubernetes/autoscaling/
```
