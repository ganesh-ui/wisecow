# ----------------------
# Stage 1: Builder
# ----------------------
FROM ubuntu:22.04 AS builder

# Install required packages
RUN apt-get update && apt-get install -y \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY wisecow.sh /app/wisecow.sh

# Fix line endings and make executable
RUN dos2unix /app/wisecow.sh && chmod +x /app/wisecow.sh

# ----------------------
# Stage 2: Runtime
# ----------------------
FROM ubuntu:22.04

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    bash curl socat cowsay fortune-mod netcat \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
# Copy the fixed script from builder stage
COPY --from=builder /app/wisecow.sh /app/wisecow.sh

# Expose the port
EXPOSE 4499

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD curl -f http://localhost:4499/ || exit 1  

# Run the script using bash explicitly
CMD ["bash", "/app/wisecow.sh"]
