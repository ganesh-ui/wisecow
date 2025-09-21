# Use Debian as base image
FROM debian:stable-slim

# Install required packages (including dos2unix)
RUN apt-get update && apt-get install -y \
    bash curl socat cowsay fortunes netcat-traditional dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Create app dir and add script
WORKDIR /app
COPY wisecow.sh /app/wisecow.sh

# Convert to Unix line endings
RUN dos2unix /app/wisecow.sh && chmod +x /app/wisecow.sh

# Expose port
EXPOSE 4499

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD curl -f http://localhost:4499/ || exit 1  

# Run the app
CMD ["/app/wisecow.sh"]
