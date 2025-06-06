# It is recommended to replace apache/nifi:latest with a specific version tag for stable builds.
FROM apache/nifi:latest

USER root

# Combine RUN instructions to reduce layer count
# Install curl, create driver directory, and download MSSQL JDBC driver.
# The driver version is specified in the filename.
# The fwlink should ideally point to this version or a direct link should be used.
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    mkdir -p /opt/nifi/drivers && \
    curl -L "https://go.microsoft.com/fwlink/?linkid=2166848" -o /opt/nifi/drivers/mssql-jdbc-9.4.0.jre8.jar && \
    apt-get purge -y --auto-remove curl && \
    rm -rf /var/lib/apt/lists/*

# Define NIFI_WEB_HTTP_PORT for clarity in HEALTHCHECK, default is 8080
# This should match the actual port NiFi is configured to listen on.
# The base image already exposes 8080.
ENV NIFI_WEB_HTTP_PORT 8080

# Healthcheck for NiFi
# This checks if the NiFi UI (controller/status) is accessible.
# NiFi can take some time to start, so interval and retries are set accordingly.
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f "http://localhost:${NIFI_WEB_HTTP_PORT}/nifi-api/controller/status" || exit 1

# Start Apache NiFi
CMD ["nifi.sh", "run"]