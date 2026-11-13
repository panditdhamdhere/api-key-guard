# api-key-guard (Tech with Pandit)

Free, local protection against committing API keys. Defender/teaching code only. All keys in the demos are fake.

| File | What it does |
|---|---|
| `gitignore-secrets.txt` | Lines to add to your `.gitignore` (`.env`, `*.pem`, local config) |
| `pre-commit` | Git hook. Scans only the lines you are about to commit for key-like patterns (`sk-...`, `AKIA...`, `password = "..."`) and cancels the commit, printing file and line |
| `install-hook.sh` | Copies the hook into `.git/hooks/` of the current repo and makes it executable |
| `test-hook.sh` | 7 checks: 4 things it must block, 3 clean lines it must allow |
| `demo.sh` | Throwaway repo in /tmp: fake key gets blocked, fixed version commits |
| `history-demo.sh` | Shows a key deleted in a later commit is still in history, and `gitleaks detect` finds it |

## Use it
```bash
cd your-repo
cat /path/to/gitignore-secrets.txt >> .gitignore
bash /path/to/install-hook.sh
```
Bypass once on purpose (not recommended): `git commit --no-verify`.

## Full-history scan
Install gitleaks (free, open source: https://github.com/gitleaks/gitleaks), then in your repo:
```bash
gitleaks detect --redact -v
```

## If a real key leaked
1. Revoke it in the provider's dashboard first. 2. Create a new key and keep it only in `.env`. 3. Clean history afterwards if you want; it does not replace revoking.

Tested 13 Nov 2026 with git and gitleaks 8.30.1 on Linux.
