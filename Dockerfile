# Minimal prod image for workflows / GitHub Actions
FROM debian:bullseye-slim

# Set CI env
ENV CI=true

# Install only production dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      zip && \
    rm -rf /var/lib/apt/lists/*

# Copy scripts
COPY workflow/ /usr/local/bin/
COPY runner /usr/local/bin/

# Make everything executable
RUN chmod +x /usr/local/bin/runner /usr/local/bin/*

# Optional: default workdir
WORKDIR /workspace

# Optional: entrypoint for convenience
ENTRYPOINT ["runner"]
