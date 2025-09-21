# Use Debian as base image (instead of Alpine)
FROM debian:stable-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    bash curl socat cowsay fortunes \
    && rm -rf /var/lib/apt/lists/*

# Create app dir and add script
WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

# Expose port used by wisecow
EXPOSE 4499

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD curl -f http://localhost:4499/ || exit 1  

# Run the app
CMD ["/app/wisecow.sh"]

