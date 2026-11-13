#!/usr/bin/env bash
# Shows why "delete it in the next commit" is not enough: gitleaks finds the key in history. FAKE key, local only.
set -u
R=$(mktemp -d /tmp/key-history-demo.XXXX); cd "$R"
git init -q; git config user.email demo@example.com; git config user.name demo
K="AKIA""Z7QX4RTV2LM9PDKW"   # fake AWS-style key id
S="wJal""rXUtnFEMI/K7MDENG/bPxRfiCYzq9Lm2Tx4R"  # fake secret
printf 'aws_access_key_id = %s\naws_secret_access_key = %s\n' "$K" "$S" > settings.ini
git add settings.ini; git commit -q --no-verify -m "settings"
git rm -q settings.ini; git commit -q -m "remove settings"
echo '$ ls'; ls; echo '(file is gone from the latest commit)'
echo; echo '$ gitleaks detect --redact -v'
gitleaks detect --redact -v --no-banner --no-color 2>&1 | grep -v "^Date:\|^Email:"; echo "exit code: ${PIPESTATUS[0]}"
echo; echo "demo repo: $R"
