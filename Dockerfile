FROM debian:bookworm-slim AS builder

RUN set -ex; \
    apt-get update ; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git; \
    rm -rf /var/lib/apt/lists/*

ENV GITHUB_CLI_VERSION=2.61.0

RUN set -ex; \
    curl -L "https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_checksums.txt" -o checksums.txt; \
    curl -OL "https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.deb"; \
    shasum --ignore-missing -a 512 -c checksums.txt; \
    dpkg -i "gh_${GITHUB_CLI_VERSION}_linux_amd64.deb"; \
    rm -rf "gh_${GITHUB_CLI_VERSION}_linux_amd64.deb"; \
    gh --version

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /usr/bin/gh /usr/bin/gh
COPY --from=builder /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libgcc_s.so.1 /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libc.so.6 /usr/lib/x86_64-linux-gnu/

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

CMD ["/usr/bin/gh"]
