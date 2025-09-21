# Dockerfile for wisecow (shell-based)
FROM alpine:3.18

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

# Run the script
CMD ["/app/wisecow.sh"]
