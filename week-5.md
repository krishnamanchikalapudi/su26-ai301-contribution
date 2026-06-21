# Week-5

## 📖 What This Phase Is About
Phase IV is the finish line — and the starting line of your life as an open source contributor. You will take your working solution from Phase III, open a formal pull request on GitHub, write a professional description, and engage with feedback from maintainers and reviewers.

This is the core completion milestone of the program. Submitting a review-ready pull request — regardless of whether it gets accepted — means you have completed the contribution cycle.

A few things to internalize before you begin:

- Submission is not the same as acceptance. Your PR does not need to be merged to count. The goal is a professional, review-ready submission.
- Feedback is not failure. Maintainers requesting changes is the normal open source workflow. A request for revision means they took the time to engage with your work and have decided your growth is worth their time. Maintainer feedback is a good thing, and generally means your contribution is valuable.
- Iteration is expected. Most pull requests go through multiple rounds of review. The faster you respond to feedback, the more likely your PR will move forward.

Target duration: 3–5 days.


## 🏁 What "Done" Looks Like
To complete Phase IV, you need to do three things:

1. Submit your PR to the upstream repository on GitHub.

2. Update your Contribution README with:

- A link to your submitted pull request
- A brief summary of what you contributed
- Notes on feedback received or next steps (if still in review)
- Status: Awaiting review / Iterating / Approved / Merged

3. Submit your Contribution README and indicate "Phase IV Complete."

That's it. Once your PR is open and your README is updated, you have completed the program's core milestone. Congratulations!


## 🗺️ Step-by-Step Procedure

### Step 1: Final Pre-Submission Checks (30 minutes)
Before opening your PR, run through this checklist one last time:

- Your fix works. Reproduce the original issue — it should no longer occur.
- All tests pass. Run the full test suite (or the relevant subset). No new failures.
- No unrelated changes. Run git diff origin/main and review every changed line. Remove debug code, stray comments, and formatting-only changes.
- Commit messages are clean. Each commit should ideally have a clear, descriptive message. Maintainers are often fine with a messier commit history for community PRs though, so don't sweat it if yours isn't perfect!
- Branch is up to date. Rebase on the latest upstream to minimize merge conflicts:
```
git fetch origin
git rebase origin/main
git push origin fix-issue-XXXXX --force-with-lease
```

### Step 2: Open Your Pull Request (30 minutes)
1. Navigate to your fork on GitHub
2. Find your branch and click **"Compare & pull request"** (GitHub often shows this button after a recent push)
3. Set the **base branch** to the project's default branch (often main) on the upstream repository (the original project you forked from)
4. Fill in the PR description using the repository's template. If they don't have one, use the template below

_**Important:** Your PR should go from your branch in your fork to main on the upstream repository. Check out GitHub's pull request docs for complete instructions.

#### PR Description Template
Many GitHub projects have a PR template that auto-populates when you create a pull request. If yours doesn't, use this structure:

###### What does this PR do?

[One paragraph: What is the change and what does it accomplish?]

###### Why was this PR needed?

[Reference the issue. Explain the problem and what investigation revealed.]

###### What are the relevant issue numbers?

Closes #[ISSUE_NUMBER]

###### Screenshots / Recordings (if applicable)

[Before/after screenshots for UI changes. Console output for backend changes. 
Delete this section if not applicable.]

###### Does this PR meet the acceptance criteria?

- [ ] Tests added for new/changed behavior
- [ ] All tests passing
- [ ] Follows project style guide
- [ ] No breaking changes introduced
- [ ] Documentation updated (if applicable)

#### Writing a Strong PR Description
Your PR description is the first thing a reviewer reads. It determines whether they engage with your code or skip to the next PR. Make it count.

#### Do:

- Explain the why before the what. Reviewers need context.
- Reference the issue number with Closes #XXXXX — this auto-links and auto-closes the issue on merge in most repositories.
- Be specific about what you changed and why that approach was chosen.
- Include before/after evidence (screenshots, test output, console logs).

#### Don't:

- Write "Fixed the bug" or similarly short messages. That tells a reviewer nothing.
- Leave the description empty or use only the title.
- Delete or ignore the repository's PR template if they have one. This will likely get your PR closed immediately by a maintainer unlikely to be receptive to your submission.
- Include implementation details that are obvious from the diff — the description should provide context the code can't.

### Step 3: Request a Review (5 minutes)
After opening your PR, get it in front of a reviewer:

1. **Check if the project has a PR template** that specifies how to request reviewers — many projects have instructions in their CONTRIBUTING.md for this.

2. **Leave a comment** on the PR mentioning relevant maintainers (use @username) and briefly explaining your change:
```
Hi @maintainer — this is my first contribution to this project. I've fixed [issue #XXX] by [brief description]. Would appreciate a review when you have time!
```

3. **If you don't know who to tag:** Look at recent merged PRs in the same area of the codebase to see who reviewed them. The project's CODEOWNERS file (if it exists) also shows who owns which files. If you're guessing, it's fine to tag someone in a comment.

_**Note:** You'll need to proactively reach out to maintainers, or simply open the PR and wait — many projects actively monitor open PRs. If you've heard nothing after 5–7 business days, leave a polite follow-up comment._

### Step 4: Respond to Feedback Professionally (ongoing)
Once your PR is open, reviewers may:

- **Approve it** — congratulations, your PR will be merged.
- **Request changes** — the most common outcome. They'll leave comments on specific lines or the overall approach.
- **Ask questions** — they need clarification about your approach or reasoning.
- **Suggest alternatives** — they may recommend a different approach entirely.

#### How to Respond
When they request a code change:

1. Read the comment carefully. Make sure you understand what they're asking.
2. The reviewer will typically leave comments on specific lines or the overall approach.
3. Make the change in your branch and push a new commit.
4. Reply to the comment confirming the change: "Updated in [commit hash]. [Switched to the factory approach, or equivalent description of your change] as suggested."
5. If you disagree with the suggestion, say so respectfully and explain your reasoning. Open source is a conversation.
6. When all requested changes are complete, leave a comment on the PR tagging the reviewer (@username) and mentioning that the PR is ready for another look.

_**Expect multiple rounds.** Pull requests are typically reviewed by one or more maintainers. This process may repeat several times before merge. This is normal and means your contribution is being taken seriously._

- **When they ask a question:** Reply directly, clearly, and promptly. Provide links to the relevant code or issue comments if it helps. Reviewers who ask questions are engaged — that's good.

- **When they suggest a different approach:** Consider it seriously. Maintainers know the codebase deeply. If the alternative approach is reasonable, implement it. If you believe your approach is better, explain why with technical reasoning. You can always reach out in Slack for help from instructional staff in writing tricky comments.

- **When you don't hear back:** Maintainers are busy. Your PR may take longer to review due to workload or holidays. If you haven't received a review within 5–7 business days, it's appropriate to leave a polite follow-up comment: "Hello! Is there anything I can update to help move this forward?"

#### Tone Guidelines

You are representing yourself, CodePath, and this cohort in a public forum. Maintainers interact with thousands of contributors. Stand out by being:

- Professional: Clear, concise, and no slang in PR discussions.
- Responsive: Reply within 24 hours when possible. Speed signals seriousness.
- Grateful: Thank reviewers for their time and feedback, even when they're critical.
- Specific: "I made the change you suggested in (file)" is better than "Done."

### Step 5: Update README and Check In (15 minutes)
Add or update the following in your Contribution README:

- PR Link: Direct link to your submitted pull request
- PR Description: What you contributed (1–2 sentences; can be adapted from your PR description)
- Maintainer Feedback: Summary of feedback received and how you addressed it
- Status: Awaiting review / Iterating / Approved / Merged

Then submit your contribution readme and indicate "Phase IV Complete."

Finally, celebrate your milestone in #dts-su26-ai301-celebration in Slack:

_"🚀 Phase IV Complete — PR submitted! [link to your pull request]"_

This is the core completion milestone of the program. You earned it!

