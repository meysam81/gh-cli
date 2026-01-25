# BusyBox-based Dockerized GitHub CLI

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Pull from GitHub Container Registry](#pull-from-github-container-registry)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [Shell Access](#shell-access)
- [Configuration](#configuration)
- [Security Considerations](#security-considerations)
- [Signature Verification](#signature-verification)
  - [Cosign Keyless Verification](#cosign-keyless-verification)
    - [Verification Process](#verification-process)
    - [Verification Details](#verification-details)
    - [Security Benefits](#security-benefits)
- [Versioning](#versioning)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Overview

This repository provides a minimal, secure Dockerized GitHub CLI built on a
BusyBox base image.

The GitHub CLI (`gh`) is packaged into a lightweight, secure container that can
be used across different environments without complex dependencies.

## Features

- Minimal BusyBox base image for smallest footprint
- Multi-architecture support (amd64, arm64)
- Latest stable version GitHub CLI (automated using GitHub Actions)
- Multi-stage build for optimization
- Non-root user execution (UID 10000)
- No package manager in final image
- Minimal shell access for debugging when needed
- Easy cross-platform deployment

## Prerequisites

- Docker 20.10+
- GitHub CLI authentication token (optional)

## Installation

### Pull from GitHub Container Registry

Latest version:

```bash
docker pull ghcr.io/meysam81/gh-cli:main
```

Stable version:

```bash
url=https://api.github.com/repos/meysam81/gh-cli/releases/latest
version=$(curl -s $url | jq -r .tag_name)
docker pull ghcr.io/meysam81/gh-cli:$version
```

## Usage

### Basic Usage

```bash
docker run --rm -it \
  -e GH_TOKEN \
  ghcr.io/meysam81/gh-cli:main repo list
```

### Shell Access

For debugging purposes, you can access the container shell:

```bash
docker run --rm -it --entrypoint /bin/sh ghcr.io/meysam81/gh-cli:main
```

## Configuration

- Mount `/home/gh/.config/gh` to persist authentication
- Use environment variables for additional configuration
- Supports all standard GitHub CLI commands

## Security Considerations

- Minimal BusyBox base image reduces attack surface
- Runs as non-root user (UID 10000)
- No package manager in final image
- Cryptographic checksum verification during build
- BusyBox shell available for restricted debugging only

## Signature Verification

### Cosign Keyless Verification

This Docker image is signed using
[Sigstore Cosign](https://github.com/sigstore/cosign) with keyless
verification.

You can verify the image's authenticity using GitHub Actions identity
verification.

#### Verification Process

```bash
cosign verify \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
  --certificate-identity-regexp "^https://github.com/meysam81/gh-cli.*$" \
  ghcr.io/meysam81/gh-cli:main
```

#### Verification Details

- **Signing Method**: Cosign keyless signing
- **Identity Verification**: GitHub Actions workflow identity
- **OIDC Issuer**: GitHub Actions token service
- **Signature Validation**: Cryptographic proof of origin and integrity

#### Security Benefits

- Cryptographically prove the image's origin
- Ensure the image was built by the authorized GitHub Actions workflow
- Prevent tampering and unauthorized image distribution

**Note:** Requires [Cosign](https://github.com/sigstore/cosign) installation to perform verification.

## Versioning

- Image tracks GitHub CLI version
- Semantic versioning used for tagging
- Check [CHANGELOG.md](CHANGELOG.md) for details

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request

## License

[Apache 2.0 License](LICENSE)

---

**Pro Tip:** Always keep your GitHub CLI and Docker image updated for the
latest features and security patches!
