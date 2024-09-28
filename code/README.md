## Dockerfile Description:
The Dockerfile contains instructions to build the light weight efficient Docker image for the application. Here's a breakdown of it:

- Base Image: The Dockerfile starts by pulling a ightweight Python base image with Enhanced Security as The minimal nature of Alpine means fewer packages and less code, reducing the potential attack vectors for security exploits.

- `--no-cache-dir` in the pip install command prevents caching the installed packages, reducing the image size.
- Remove `requirements.txt` after installation to minimize leftover files and reduce the final image size.
