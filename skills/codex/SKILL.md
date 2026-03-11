---
description: Manually run a task through OpenAI Codex CLI for an alternative AI perspective
---

# Codex Bridge

Run the task through Codex CLI directly:

```bash
codex exec --full-auto -C "$(pwd)" "$ARGUMENTS"
```

Add `--skip-git-repo-check` if not in a git repo.

Return the full output from Codex to the user.

If the command fails or times out, report the error clearly.
