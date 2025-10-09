# Minimal prod image for workflows / GitHub Actions
FROM debian:bullseye-slim

# Set CI env
ENV CI=true

# Install production dependencies + git for GitHub Actions
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      zip \
      git && \
    rm -rf /var/lib/apt/lists/*

# Copy scripts
COPY workflow/ /usr/local/bin/
COPY runner /usr/local/bin/

# Make everything executable
RUN chmod +x /usr/local/bin/runner /usr/local/bin/*

# Git safe directory config for GitHub Actions
RUN git config --global --add safe.directory '*'

# Optional: default workdir
WORKDIR /workspace

# Optional: entrypoint for convenience
ENTRYPOINT ["runner"]