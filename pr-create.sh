#!/bin/bash
# gh ssh-key add ~/.ssh/id_ed25519.pub --title "Krishna MAC"
# Usage: build/pr-create.sh [feature-branch] [feature-commit-message] [pr-title] [pr-body] [head]
# Defaults: base=develop, pr-title="PR/ch21-30", pr-body="PR for ch:21-30 and Appendix: A-L", head=current branch
cd ~/Documents/GitHub/apache-opendal/
pwd

BASE_BRANCH="main"
# FEATURE_BRANCH="feat/$(date '+%Y-%m-%d-%H-%M-%S')"  # "feat/name-of-feature"
FEATURE_BRANCH="fix-issue-2198"
PR_TITLE="Fixing the vercel_artifacts backend"
PR_DESCRIPTION="### Which issue does this PR close?
Closes #2198.

### Rationale for this change
The \`vercel_artifacts\` cache backend (used for Vercel's Remote Cache) had multiple failing behavior tests because it did not implement standard operations like \`stat\`, and attempted to run unsupported operations like \`delete\` and \`create_dir\`. Vercel's Remote Cache API is a simple flat key-value cache that does not support folder hierarchies or deleting individual cache entries. This PR fixes the failures by implementing a proper \`stat\` checker (using a \`HEAD\` request to verify artifact existence) and configuring capabilities to skip the unsupported \`delete\` and \`create_dir\` operations.

### What changes are included in this PR?
1. Implemented the \`stat\` operation in \`core/services/vercel-artifacts/src/backend.rs\` by sending a \`HEAD\` request to \`/v8/artifacts/{hash}\` to fetch metadata and verify existence.
2. Added a fast-path check in \`stat\` to return directory metadata (\`EntryMode::DIR\`) directly when a path is \`/\` or ends with a slash, preventing invalid API calls for directory structures.
3. Kept the \`delete\` and \`create_dir\` capabilities disabled so the behavior test runner correctly skips these unsupported operations.

### Are there any user-facing changes?
No user-facing breaking changes. This only fixes internal service compatibility and behavior tests for Vercel Remote Cache.

### AI Usage Statement
I used Gemini (Antigravity AI coding assistant) to assist in reproducing the issue, identifying the REST API constraints, implementing the \`stat\` directory check logic, and structuring the PR description."

## Validate input parameters
if [ -z "$PR_TITLE" ]; then
  echo "Error: PR title is required." >&2
  printf "Usage: ./build/pr-create.sh \"%s\" <pr-title>\n" "$FEATURE_BRANCH" >&2
  cd ~/Documents/GitHub/su26-ai301-contribution/
  pwd

  exit 1
fi

# (PR details will be printed after generating the description)

# 1. Make sure you're up to date
git checkout "$BASE_BRANCH"
git pull origin "$BASE_BRANCH"

# 2. Create a feature branch for your work
git checkout "$FEATURE_BRANCH" || git checkout -b "$FEATURE_BRANCH"

# 3. Make your commit
git add . -v

# If PR description not provided, generate from staged changes
if [ -z "$PR_DESCRIPTION" ]; then
  staged=$(git diff --name-only --cached || true)
  if [ -z "$staged" ]; then
    PR_DESCRIPTION="No files staged for commit."
  else
    desc="Auto-generated change list:\n"
    while IFS= read -r f; do
      desc+="- $f <br>\n"
    done <<EOF
$staged
EOF
    PR_DESCRIPTION="$desc"
  fi
fi

# Commit with title and body
git commit -m "$PR_TITLE" -m "$PR_DESCRIPTION" -v || true

# 4. Push the branch
git push -u origin "$FEATURE_BRANCH" -v

# 5. Create the PR
# Print final details (include generated description)
printf "\n ---------------------------------------------\n"
printf "Creating PR with the following details:\n"
printf "Base Branch: %s\n" "$BASE_BRANCH"
printf "Feature Branch: %s\n" "$FEATURE_BRANCH"
printf "PR Title: %s\n" "$PR_TITLE"
printf "PR Description:\n%s\n" "$PR_DESCRIPTION"
echo "Creating PR from '$FEATURE_BRANCH' into '$BASE_BRANCH'"
# gh pr create --base develop --head your-feature-branch --title "Your PR Title" --body "Description of changes"
gh pr create --base "$BASE_BRANCH" --head "$FEATURE_BRANCH" --title "$PR_TITLE" --body "$PR_DESCRIPTION"

printf "\n ---------------------------------------------\n"

# list PRs
echo "Listing open PRs for base branch '$BASE_BRANCH':"
gh pr list --state open --base "$BASE_BRANCH"

printf "\n --------------------------- DONE -------------------\n"
# git checkout -b "$DEFAULT_BRANCH"

cd ~/Documents/GitHub/su26-ai301-contribution/
pwd
