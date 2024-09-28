## Kubernetes Ingress and Deployment with HPA Configuration:
This provides Kubernetes configuration files for deploying a Flask-based application using an Application Load Balancer (ALB) with AWS and a deployment with HPA for scalability.

Configuration Files Overview:

**1- alb.yml:**

requires LoadBalancer controller installation first to allow the usage of ingress resources as alb

- Ingress Settings:

    - **kubernetes.io/ingress.class: "alb"**: Specifies that the ingress controller is AWS Application Load Balancer.

    - **alb.ingress.kubernetes.io/scheme: internet-facing**: Makes the load balancer public.

    - **alb.ingress.kubernetes.io/subnets**: Specifies which subnets (public and private) the ALB will use. `at least two subnets must be provided`

    - **alb.ingress.kubernetes.io/listen-ports: [{"HTTP": 80}]**: The ALB has https listener. `a certificate must be provided if HTTPS needed`

    - **alb.ingress.kubernetes.io/target-type: instance**: The ALB targets NodePort service as a backend set to reach the pods through it.
- Ingress Rules:

    - Defines the path ("/") where any incoming traffic is routed to the NodePort service named flask-nodeport on port 5000.

- NodePort Service:

    A NodePort Service (flask-nodeport) exposes the Flask application on port 5000 to be accessed externally via the ALB.

**2- deployment.yml**

- Container:
    - image: 

        GitHub Pipeline changes image value `DOCKER_IMAGE` with the one in ECR.

    - Probes:

        Readiness and liveness checks using the /users endpoint

**3- HorizontalPodAutoscaler (hpa.yml)**
- Auto-scales Flask deployment based on CPU usage.
- Scaling range: 2-10 replicas.
- Target CPU utilization: 70%, scales up/down based on load.