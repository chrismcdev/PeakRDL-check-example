# PeakRDL-check example

A minimal SystemRDL project that demonstrates and continuously tests the
[PeakRDL-check](https://github.com/chrismcdev/PeakRDL-check) GitHub Action on a
hosted runner.

[![Action smoke test](https://github.com/chrismcdev/PeakRDL-check-example/actions/workflows/action-smoke-test.yml/badge.svg)](https://github.com/chrismcdev/PeakRDL-check-example/actions/workflows/action-smoke-test.yml)

## What this repository tests

- The released composite action can be consumed from another repository.
- A known register-address change is classified as breaking.
- The action exposes its breaking-change count and uploads its JSON and
  Markdown reports.
- Pull requests that change SystemRDL files receive the normal review gate.

The smoke test uses the immutable `v0.2.0` release so a passing run proves
that exact published version works for consumers.

## Use the action

```yaml
- uses: actions/checkout@v7
  with:
    fetch-depth: 0

- uses: chrismcdev/PeakRDL-check/action@v0.2.0
  with:
    base-ref: ${{ github.event.pull_request.base.sha }}
    head-ref: ${{ github.event.pull_request.head.sha }}
    fail-on: breaking
```

See [registers/design.rdl](registers/design.rdl) for the project entry point,
[registers/uart.rdl](registers/uart.rdl) for the UART block, and
[the pull-request workflow](.github/workflows/register-review.yml) for the
complete configuration.

## Try a breaking change

1. Create a branch.
2. Change `ctrl @ 0x0` to `ctrl @ 0x40` in
   [registers/uart.rdl](registers/uart.rdl).
3. Open a pull request.

PeakRDL-check will annotate the address change, add a job summary, upload the
review reports and fail the gate.

## Interactive pull-request preview

This repository can also deploy a temporary viewer for each pull request using
[Railway PR environments](https://docs.railway.com/guides/preview-deployments-with-pr-environments).
The preview contains the complete 800,000-register example map and its semantic
changes. The GitHub Action above remains the CI gate.

To enable previews:

1. Create a Railway project from this GitHub repository.
2. Generate a Railway domain for the service.
3. In **Project Settings → Environments**, enable **PR Environments**.

Railway detects the included [Dockerfile](Dockerfile), posts the preview URL
on each pull request, updates it after new commits, and removes it when the
pull request closes.
