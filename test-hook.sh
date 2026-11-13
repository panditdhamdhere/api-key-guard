#!/usr/bin/env bash
# Checks the hook blocks what it should and lets clean code through. Fake values only.
HERE="$(cd "$(dirname "$0")" && pwd)"; pass=0; fail=0
try(){ # expect(block|ok) content
  R=$(mktemp -d); (cd "$R"; git init -q; git config user.email t@t; git config user.name t; cp "$HERE/pre-commit" .git/hooks/; printf '%s\n' "$2" > f.txt; git add f.txt
   if git commit -q -m t >/dev/null 2>&1; then got=ok; else got=block; fi
   [ "$got" = "$1" ] && echo "PASS  $1  $2" || { echo "FAIL  expected $1 got $got: $2"; exit 1; }) && pass=$((pass+1)) || fail=$((fail+1)); rm -rf "$R"; }
try block 'key = "sk-''abcdefghijklmnopqrstuvwx"'
try block 'id=AKIA''ABCDEFGHIJKLMNOP'
try block 'DB_PASSWORD = "hunter2hunter2"'
try block 'secret: "abc123xyz789"'
try ok    'OPENAI_API_KEY = os.environ["OPENAI_API_KEY"]'
try ok    'password = input("Password: ")'
try ok    'print("hello world")'
echo "$pass passed, $fail failed"; [ $fail -eq 0 ]
