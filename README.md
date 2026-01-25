# Formal Methods and the Public Key Directory

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

## Duvet Requirements Traceability

All proofs include duvet annotations linking to specification requirements. 
Run `duvet report` from the repository root to generate a traceability report.

```shell
duvet report
```
