#!/bin/bash
set -euo pipefail

# Verify all ProVerif proofs, checking EVERY query result.
#
# The old CI only checked that at least one query per file
# returned "is true", silently ignoring individual failures.
# This script counts every RESULT line and fails on any
# unexpected false/unproved query.
#
# Allowlist: some queries are *expected* to be false (they
# demonstrate a threat model property). Update the case
# statement below when adding new expected-false queries.

# Returns the number of expected-false results for a proof.
#
# pkd_composed_threats: 1
#   Query 1 (Yvonne DB bypass) is intentionally false.
#   It demonstrates that a privileged database attacker
#   can bypass Fireproof protection, which the spec
#   documents as a known risk.
expected_false_for() {
  case "$1" in
    pkd_composed_threats) echo 1 ;;
    *) echo 0 ;;
  esac
}

PROOF_DIR="${1:-proofs}"
cd "$PROOF_DIR"

failed=0
total_proofs=0
total_queries=0
total_passed=0

for proof_file in *.pv; do
  name="${proof_file%.pv}"
  total_proofs=$((total_proofs + 1))

  # GitHub Actions log grouping (no-op outside Actions)
  echo "::group::${name}"

  proverif "$proof_file" > "${name}_result.txt" 2>&1

  count=$(grep -c "^RESULT " "${name}_result.txt" || true)
  passed=$(grep -c "^RESULT.*is true\." \
    "${name}_result.txt" || true)
  failures=$(grep -cE \
    "^RESULT.*(is false|cannot be proved)" \
    "${name}_result.txt" || true)
  expected=$(expected_false_for "$name")

  total_queries=$((total_queries + count))
  total_passed=$((total_passed + passed))

  if [ "$count" -eq 0 ]; then
    echo "::error file=${PROOF_DIR}/${proof_file}::"\
"No RESULT lines found"
    failed=1

  elif [ "$failures" -gt "$expected" ]; then
    unexpected=$((failures - expected))
    echo "::error file=${PROOF_DIR}/${proof_file}::"\
"${unexpected} unexpected failure(s)"\
" (${passed}/${count} passed, ${expected} expected-false)"
    grep -E "^RESULT.*(is false|cannot be proved)" \
      "${name}_result.txt"
    failed=1

  else
    echo "${name}: ${passed}/${count} queries passed"
    if [ "$expected" -gt 0 ]; then
      echo "  (${expected} expected-false per allowlist)"
    fi
  fi

  echo "::endgroup::"
done

echo ""
echo "Summary: ${total_passed}/${total_queries} queries passed across ${total_proofs} proof files"

if [ "$failed" -eq 1 ]; then
  echo "::error::One or more proofs FAILED"
  exit 1
fi

echo "All ProVerif proofs verified"
