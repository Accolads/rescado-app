#!/bin/sh

RESCADO_ANALYSIS_FAILED=false
RESCADO_FORMATTING_FAILED=false

# Check formatting and analysis
if ! flutter format ./lib --set-exit-if-changed --line-length 500; then
  RESCADO_FORMATTING_FAILED=true
fi
if ! flutter analyze; then
  RESCADO_ANALYSIS_FAILED=true
fi

# Exit with error code if relevant
if $RESCADO_FORMATTING_FAILED || $RESCADO_ANALYSIS_FAILED; then
  # Add comments if not on GitHub Actions
  if [ -z "$CI" ]; then
    echo "Commit aborted"
    $RESCADO_FORMATTING_FAILED && \
      echo "Verify your working directory before committing again."
  fi
  exit 1
fi
