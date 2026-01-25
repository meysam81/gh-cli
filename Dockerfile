FROM alpine:3 AS builder

RUN apk add --no-cache \
    ca-certificates \
    curl

ENV GITHUB_CLI_VERSION=2.86.0

ARG TARGETARCH

RUN set -ex; \
    case "${TARGETARCH}" in \
        amd64) ARCH="amd64" ;; \
        arm64) ARCH="arm64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac; \
    curl -L "https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_checksums.txt" -o checksums.txt; \
    curl -OL "https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_${ARCH}.tar.gz"; \
    grep "gh_${GITHUB_CLI_VERSION}_linux_${ARCH}.tar.gz" checksums.txt > temp_checksums.txt && mv temp_checksums.txt checksums.txt; \
    sha256sum -c checksums.txt; \
    tar -xvzf "gh_${GITHUB_CLI_VERSION}_linux_${ARCH}.tar.gz"; \
    find . -type f -name "gh" -executable -exec mv {} /usr/local/bin/gh \;; \
    chmod +x /usr/local/bin/gh; \
    gh --version

FROM alpine:3

RUN apk add --no-cache ca-certificates \
    && adduser -D -u 65532 -g "gh" gh

COPY --from=builder /usr/local/bin/gh /usr/local/bin/gh

USER gh

CMD ["/usr/local/bin/gh", "--version"]
