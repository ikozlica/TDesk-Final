# TDesk2 Releases

This public repository is the binary update channel for the private TDesk2 application.

It intentionally contains no TDesk2 source code, credentials, database configuration, fiscalization data, certificates, or user data.

Installed TDesk2 clients read `update-manifest.json` from this repository and download signed/versioned Windows installers from GitHub Releases.

Release assets follow this naming convention:

`TDesk2-<version>-Setup.exe`

The manifest is published automatically by `scripts/release.ps1` in the private `ikozlica/TDesk2` repository after a successful installer build.
