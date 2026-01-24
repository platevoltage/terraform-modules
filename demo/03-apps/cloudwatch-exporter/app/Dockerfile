# syntax=docker/dockerfile:1
FROM prom/cloudwatch-exporter:v0.16.0

USER root
RUN mkdir -p /config && chown 65534:65534 /config
COPY --chown=65534:65534 config.yml /config/config.yml

USER 65534
EXPOSE 9106

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1:9106/metrics || exit 1

# Pass ONLY the config file; port defaults to 9106 in the image entrypoint
CMD ["/config/config.yml"]
