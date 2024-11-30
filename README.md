# Distroless Dockerized GitHub CLI 🐳🚀

## 📋 Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Distroless Dockerized GitHub CLI 🐳🚀](#distroless-dockerized-github-cli-)
  - [📋 Table of Contents](#-table-of-contents)
  - [🌟 Overview](#-overview)
  - [✨ Features](#-features)
  - [🛠 Prerequisites](#-prerequisites)
  - [💿 Installation](#-installation)
    - [Pull from GitHub Container Registry](#pull-from-github-container-registry)
  - [🚢 Usage](#-usage)
    - [Basic Usage](#basic-usage)
  - [🔧 Configuration](#-configuration)
  - [🔐 Security Considerations](#-security-considerations)
  - [🔏 Signature Verification](#-signature-verification)
    - [Cosign Keyless Verification](#cosign-keyless-verification)
      - [Verification Process](#verification-process)
      - [Verification Details](#verification-details)
      - [Security Benefits](#security-benefits)
  - [🔢 Versioning](#-versioning)
  - [🤝 Contributing](#-contributing)
  - [📄 License](#-license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 🌟 Overview

This repository provides a minimal, secure Dockerized GitHub CLI built on a
distroless base image.

The GitHub CLI (`gh`) is packaged into a lightweight, secure container that can
be used across different environments without complex dependencies.

## ✨ Features

- 🔒 Distroless base image for minimal attack surface
- 📦 Latest stable version GitHub CLI (automated using GitHub Actions)
- 🚀 Multi-stage build for optimization
- 🛡️ Minimal runtime dependencies
- 🌍 Easy cross-platform deployment

## 🛠 Prerequisites

- Docker 20.10+
- GitHub CLI authentication token (optional)

## 💿 Installation

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

## 🚢 Usage

### Basic Usage

```bash
docker run --rm -it \
  -e GH_TOKEN \
  ghcr.io/meysam81/gh-cli:main gh repo list
```

## 🔧 Configuration

- Mount `/root/.config/gh` to persist authentication
- Use environment variables for additional configuration
- Supports all standard GitHub CLI commands

## 🔐 Security Considerations

- Distroless image reduces attack surface
- No shell or package manager in final image
- Minimal runtime libraries
- Cryptographic checksum verification during build

## 🔏 Signature Verification

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

## 🔢 Versioning

- Image tracks GitHub CLI version
- Semantic versioning used for tagging
- Check [CHANGELOG.md](CHANGELOG.md) for details

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

[Apache 2.0 License](LICENSE)

---

**💡 Pro Tip:** Always keep your GitHub CLI and Docker image updated for the
latest features and security patches!
