# Formal Methods and the Public Key Directory

[![Verify Proofs and Traceability](https://github.com/fedi-e2ee/pkd-formal/actions/workflows/verify.yml/badge.svg)](https://github.com/fedi-e2ee/pkd-formal/actions/workflows/verify.yml)

This repository contains ProVerif models of the [Public Key Directory specification](https://github.com/fedi-e2ee/public-key-directory-specification)
and uses [Duvet](https://github.com/awslabs/duvet) to ensure the specification requiremments are satisfied by 
the known implementations. 

To understand the motivation for this repository, please refer to:
*[Software Assurance & That Warm and Fuzzy Feeling](https://soatok.blog/2026/01/15/software-assurance-that-warm-and-fuzzy-feeling/)*.

## Running Proofs

### Prerequisites

[Install ProVerif](https://bblanche.gitlabpages.inria.fr/proverif/) to verify the proofs.

[Install Duvet](https://github.com/awslabs/duvet) to trace the requirements from the implementations to the proofs.

### Run the Proofs

```shell
cd proofs
for f in *.pv; do
    echo "Verifying $f..."
    proverif "$f" || exit 1
done
```

TEMP - Just forcing a PR to trigger

## Duvet Requirements Traceability

All proofs include duvet annotations linking to specification requirements. 
Run `duvet report` from the repository root to generate a traceability report.

```shell
duvet report
```
