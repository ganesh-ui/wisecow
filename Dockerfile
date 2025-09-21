# Dockerfile for wisecow (shell-based)
FROM alpine:3.18

# Install required packages
RUN apk add --no-cache bash curl socat openbsd-extras fortune-mod cowsay

# Create app dir and add script
WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

# Expose port used by wisecow
EXPOSE 4499

# Run the script
CMD ["/app/wisecow.sh"]
