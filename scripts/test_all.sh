#!/usr/bin/env bash
# Roda os testes de todos os projetos e mostra um resumo no fim.
# Uso, na raiz do repositorio:  bash scripts/test_all.sh
export PATH="$PATH:$HOME/flutter/bin"
cd "$(dirname "$0")/.." || exit 1

failed=()
run() { # run <pasta> <comando...>
  local dir=$1; shift
  echo; echo "=== $dir"
  if (cd "$dir" && "$@"); then echo "OK  $dir"; else failed+=("$dir"); fi
}

run server dart test
run packages/core dart test
run packages/design_system flutter test
run apps/catalog flutter test
run apps/mobile flutter test

echo; echo "================ RESUMO"
if [ ${#failed[@]} -eq 0 ]; then echo "Tudo passou."; else echo "Falharam: ${failed[*]}"; exit 1; fi
