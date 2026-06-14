# Start from the official nginx image hosted on Docker Hub.
# This image already contains nginx installed and configured to serve static web content.
# The version is pinned to 1.27-alpine instead of using "latest", which is important for GitOps because it makes builds more predictable and repeatable.
# The "alpine" variant is smaller and lighter than a full Linux base image, which reduces image size and attack surface.
FROM docker.io/library/nginx:1.27-alpine

# Add Open Container Initiative metadata to the image.
# This label records the source repository where the image definition and application files live.
# In a GitOps workflow, this helps connect the running container image back to the Git repository that defines the desired state.
# Tools, registries, scanners, and humans can use this metadata to trace the image back to its source code.
LABEL org.opencontainers.image.source=https://github.com/SolEngOli/gitops-hl

# Copy the local application HTML file into nginx's default web root.
# "app/index.html" is read from the local build context, meaning the folder you build from using the final "." in the podman build command.
# "/usr/share/nginx/html/index.html" is the default file nginx serves when someone visits the site.
# In GitOps terms, this means the web page content is version-controlled in Git and baked into the image during the build.
COPY app/index.html /usr/share/nginx/html/index.html

# Document that the containerized nginx service listens on port 80.
# This does not publish the port by itself; it only records the intended network port inside the image.
# When running locally, you still need to map a host port to container port 80.
# In Kubernetes, a Service or Ingress would be used to expose this port according to the desired state stored in Git.
EXPOSE 80