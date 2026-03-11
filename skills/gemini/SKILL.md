---
description: Manually run a task through Google Gemini CLI for an alternative AI perspective
---

# Gemini Bridge

Run the task through Gemini CLI directly:

```bash
cd "$(pwd)" && gemini -p "$ARGUMENTS" --approval-mode yolo --output-format text
```

Return the full output from Gemini to the user.

If the command fails or times out, report the error clearly.
