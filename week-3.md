# Week-3
## 📖 What This Phase Is About
Phase III is where you write code. You have an issue, you've reproduced it, and you have a plan. Now you execute that plan — implementing your solution, writing tests, and pushing working commits to your fork.

This is the longest phase of the program (~2 weeks) and the one where momentum matters most. The biggest risk isn't writing bad code — it's writing no code. Students who push regularly, test incrementally, and ask for feedback early almost always reach Phase IV. Students who go silent for a week often don't.

Target duration: ~2 weeks.

## 🏁 What "Done" Looks Like
To complete Phase III, you need to do two things:

1. Update your Contribution README with:

- A brief summary of the implementation work completed in Implementation Notes  
- Links to your active development branch, meaningful commits, or a draft PR (optional but strongly encouraged) in Code Changes
- Notes on testing approaches or validation steps taken in Testing Strategy

2. Submit your Contribution README and indicate "Phase III Complete."

Phase III is complete when you have a working solution that you're ready to submit as a pull request. It does not need to be perfect — Phase IV is where you polish and iterate.

## 🗺️ Step-by-Step Procedure
### Step 1: Review Contribution Guidelines (30 minutes)
Before writing any code, look for a CONTRIBUTING.md file in the project root. Open source GitHub projects often have one that details exactly how contributions should be structured. This tells you what reviewers will expect. Focus on:

- **Code style**: Most projects enforce style guides, often through linters, for their primary language. Find the one relevant to your change.
- **Testing requirements**: Every code change needs tests. Understand what kind of tests the project expects (unit, integration, feature).
- **Commit message format**: Projects often have conventions for commit messages. Follow them from your first commit — it's much harder to rewrite history later. If the project doesn't specify a format, Conventional Commits is a widely adopted standard worth following.
- **PR description template**: Familiarize yourself with what a pull request description needs. You'll write this in Phase IV, but knowing the format now helps you track the right information as you build.

If there's no CONTRIBUTING.md don't panic — smaller projects may skip it. Instead:

- **Look at merged PRs** in the repo. Filter by merged, sorted by recently updated. Read 2–3 PRs in the same area as your issue — the description format, commit style, and test patterns you see there are the de facto standard.
- **Check for a .github/ directory**. Projects sometimes store PR templates at .github/PULL_REQUEST_TEMPLATE.md and issue templates at .github/ISSUE_TEMPLATE/ even without a full CONTRIBUTING.md.
- **Read the README**. It sometimes contains a "Contributing" section.
- **When in doubt, ask**. Leave a comment on your issue: "I didn't find a CONTRIBUTING.md — is there a style guide or PR format I should follow?" Maintainers typically appreciate the question.

### Step 2: Implement Your Plan in Small, Testable Increments (1–2 weeks)
This is the core of Phase III. Work through your solution plan step by step.

#### The Daily Rhythm
** Participate in Standups ** (Wednesday during Class Time; Async on Slack Mondays and Fridays)

During Phase III, you'll have the option of joining a twice-weekly Slack scrum (Mondays and Fridays) in addition to your synchronous weekly standup. A bot or facilitator will post a prompt — reply in the thread by the end of the day with:

- What I did since last scrum
- What I'm working on next
- Am I blocked? If so, on what?

This takes 2 minutes and serves two purposes: it keeps you accountable, and it surfaces blockers early so the team can help. It's also great practice for a very real development team habit you're likely to encounter in future workplaces.

- **Start each session** by pulling the latest from upstream to avoid merge conflicts:
```
git fetch origin
git rebase origin/main
```

- **Work on one small piece** of your plan at a time. If your plan says "modify validation method, add tests, update docs" — do the validation method first, commit it, then move to tests.

- **Commit frequently**. Every meaningful change gets its own commit. Aim for at least one commit per working day. Generally, if you're working for an hour without a commit, you should probably be committing more often.
```
git add -A
git commit -m "Fix email validation typo in user.rb"
git push origin fix-issue-XXXXX
```

- **Run tests after every change**. Don't wait until the end to discover your changes broke something.

- **Document as you go**. Update your Contributor README with what you built, challenges you faced, and decisions you made. This is your weekly progress log.

#### Using AI Effectively During Build
AI tools are your pair programming partner in this phase. Use them for:

- Understanding unfamiliar code: "What does this method do? What calls it?"
Language translation: "I know how to do this in Python — how do I do it in Ruby?"
- Writing test scaffolding: "Generate RSpec tests for a method that validates email format"
- Debugging failures: "My test is failing with this error. What's wrong?"
Style compliance: "Does this code follow this project's Ruby style guide?"
- Critical rule: Always review and understand AI-generated code before committing it. You are responsible for every line in your pull request. If a reviewer asks "why did you do X?", "the AI suggested it" is not an acceptable answer.

### Step 3: Write Tests (throughout, not at the end)
Most projects require automated tests. Write them alongside your code, not after.

####What to Test
- The fix itself: Does the bug no longer occur? Write a test that would have caught the bug before your fix.
- Edge cases: What happens with empty input? Extremely long input? Unexpected types?
- Regressions: Do all existing tests still pass? Run the full test suite (or the relevant subset) regularly.

#### Finding Test Examples
The best way to learn how to write tests for a project is to look at existing tests in the same area:

- Find the spec or tests file that corresponds to the file you modified (e.g., app/models/user.rb → spec/models/user_spec.rb, src/commands/create/create.py → tests/commands/create/test_call.py)
- Read 2–3 existing tests to understand the patterns, helpers, and factories used
- Model your new tests on those patterns

_AI tip: Paste an existing test file into Claude Code and ask: "How do I add a test case here that checks [your scenario]?"_

### Step 4: Self-Review Before Moving On (1 hour)
Before marking Phase III complete, run this pre-submission checklist:

- Code change works. The bug is fixed or the feature works as intended in your local environment.
- Tests pass. All new tests pass. All existing tests still pass (or you can explain why a failure is unrelated).
- Style compliance. Your code follows the project's style guide. Run any available linters.
- No unnecessary changes. Your diff should only include changes relevant to the issue. Remove debug statements, commented-out code you had added, and unrelated formatting changes.
- Commit history is clean. Each commit has a descriptive message. Squash or reword if needed.
- README is updated. Implementation summary, branch link, testing notes.

### Step 5: Update README and Check In (15 minutes)
Add or update the following sections in your Contribution README:

- Implementation Progress in Implementation Notes: What you built, files modified, key commits
- Challenges Faced: What was hard, how you solved it, what tools helped
- Testing Strategy: What tests you added, what validation you performed
- Branch Link: Direct link to your working branch on your fork
Then submit your contribution readme and indicate "Phase III Complete."