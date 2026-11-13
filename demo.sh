#!/usr/bin/env bash
# Safe demo: everything happens in a throwaway repo under /tmp with FAKE keys. Nothing is pushed.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"; R=$(mktemp -d /tmp/key-guard-demo.XXXX); cd "$R"
git init -q; git config user.email demo@example.com; git config user.name demo
bash "$HERE/install-hook.sh"
echo; echo '$ cat config.py'
FAKE="sk-proj-""FAKEdemo1234567890abcdefXYZ"           # fake, split so this file itself does not trip scanners
printf 'MODEL = "gpt"\nOPENAI_API_KEY = "%s"\n' "$FAKE" > config.py; cat config.py
echo; echo '$ git add config.py && git commit -m "add config"'
git add config.py; git commit -q -m "add config"; echo "exit code: $?"
echo; echo '# fix: read the key from the environment instead'
printf 'import os\nMODEL = "gpt"\nOPENAI_API_KEY = os.environ["OPENAI_API_KEY"]\n' > config.py; cat config.py
cp "$HERE/gitignore-secrets.txt" .gitignore; printf 'OPENAI_API_KEY=%s\n' "$FAKE" > .env
echo; echo '$ git status --short'; git add -A; git status --short
echo; echo '$ git commit -m "add config"'; git commit -q -m "add config" && echo "commit ok: $(git log --oneline -1)"
echo; echo "demo repo: $R"
