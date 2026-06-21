# Week-2
## 📖 What This Phase Is About
Phase II is where you prove — to yourself and to your mentors — that you actually understand the issue you selected. You do this by reproducing it locally on your own machine and writing a concrete plan for how you intend to fix it.

This is the most technically demanding setup phase of the program. You will set up a local development environment, trigger the bug or behavior described in your issue, and then write a plan that shows you understand the root cause and have a realistic path to solving it.

If Phase I was about choosing wisely, Phase II is about proving you can work with what you chose.

**Target duration: 3–7 days.**
_Prerequisites: Before starting Phase II, you should have completed Phase I (issue selected, README updated) and have your GitHub account set up and project forked. If either is incomplete, go back and finish them first._


## 🏁 What "Done" Looks Like
To complete Phase II, you need to do three things:
1. Update your Contribution README with content under these template headers:
- Clear numbered reproduction steps (someone else should be able to follow them without extra research) in Reproduction Process under Steps to Reproduce
- Add a link to your branch in your fork in Reproduction Evidence
- Write a short solution plan (bullet list or paragraph describing your intended approach) under Implementation Plan
2. Submit your check-in form and indicate "Phase II Complete."
3. (Recommended) Announce your Phase II completion in #dts-su26-ai301-celebration with a brief summary of your reproduction and plan.

No pull request. No finished code. Just proof that you can reproduce the problem and a plan that makes sense.

## 🗺️ Step-by-Step Procedure
### Step 1: Set Up Your Local Development Environment (1–4 hours)
This is the step where most students hit friction. The setup experience will vary significantly depending on which project you chose — and this variability is intentional to teach you what real-world open source contribution looks like.

GitHub projects each define their own setup process. Here's what you'll encounter:

#### Best Case: The Project Has a Dev Container
Some well-maintained projects include a devcontainer.json file — VS Code's all-in-one dev environment. If your project has this:

1. Install VS Code and the Dev Containers extension

2. Clone your fork:
<code>
git clone https://github.com/<your-username>/<project-name>.git
cd <project-name>
</code>

3. VS Code will prompt you to "Reopen in Container" — do it

4. The container spins up with all dependencies pre-configured

### Typical Case: README Setup Instructions
Most projects have a README.md or CONTRIBUTING.md with setup instructions. Quality varies widely — some are excellent, others are outdated.

1. Clone your fork and read the README thoroughly before running anything
2. Follow the setup steps for your OS
3. When you hit a dependency error (and you likely will), search for the exact error message online or paste it into Claude Code for help
4. Document every error and fix in your Contribution README — this is genuinely valuable for future contributors

### Worst Case: Sparse or Outdated Documentation
If the setup docs are missing or outdated, you're largely on your own — just like a new hire on a team often is. Strategies:

1. Check the project's GitHub Issues for setup-related questions from other contributors
2. Check the Discussions tab if the project has one
3. Look at CI/CD config files (.github/workflows/) — they often reveal the correct build and test commands
4. Ask in the issue comments or project Discussions tab

_This step is the most important qualifier from Phase I. When you selected your issue, one of the key criteria was whether the project has clear setup documentation. If you're spending more than 4 hours on setup with no progress, the project may not be suitable for this program cycle. Post in #dts-su26-ai301-solution-planning in Slack with your error details, and consider whether to pivot to a better-documented project. Pivoting now is likely better than trying to push through if you might get stuck later after more time investment, especially if this is your first issue._

### Common Setup Issues and Fixes
| Problem | Fix |
| :--- | :--- |
| Node/npm version mismatch | Check .nvmrc or .node-version and install that version via nvm |
| Python version mismatch | Check .python-version and use pyenv to install the correct version |
| Missing environment variables | Look for .env.example — copy it to .env and fill in any required values |
| Package install failures | Read the error carefully — usually a missing system dependency. The error message usually names it |
| Port already in use | Another process is using the dev server port. Find and kill it, or configure a different port |
| Tests won't run | Look for a Makefile or scripts in package.json — run make test or npm test respectively | 

_If setup fails after 4 hours of effort: Stop. Ask for help. Post your error logs in #dts-su26-ai301-solution-planning in Slack. Include your OS, the project name, and the last 20 lines of error output. If class will meet within 24 hours, you can also ask for help during coworking time. Don't wait longer than that, though!_

### Step 2: Create Your Working Branch (10 minutes)
_Note: If the project uses a branch other than main as its default (some use develop or trunk), check the repository's default branch on GitHub and use that for these commands instead of main._

Once your environment is running, create a branch in your fork:
1. If you haven't already cloned your fork, go back to step 1 at the top of this procedure.

2. Make sure you're up to date:
<code>
git checkout main
git pull origin main
</code>

3. Create a working branch named after your issue:
<code>
git checkout -b fix-issue-XXXXX
</code>

4. Push (VS Code's UI says Publish) the branch so it exists on the remote:
<code>
git push origin fix-issue-XXXXX
</code>

### Step 3: Reproduce the Issue (1–2 hours)
Reproducing the issue means you can trigger the exact behavior described in the issue — consistently, not just once. This is critical because:
- It proves the issue still exists (it may have been fixed upstream)
- It gives you a baseline to test your fix against
- Your reproduction steps become documentation for your README

#### How to Reproduce

1. **Read the issue description again.** Look for reproduction steps if they're provided. If they aren't, look in the comments — maintainers or reporters often clarify steps there. Check if any maintainers commented on the issue with hints or pointers.

2. **Follow the steps exactly in your local environment.** Navigate to the right page, enter the specified input, trigger the action.

3. **Document what you observe.** Write down:
    - What you expected to happen (the correct behavior)
    - What actually happened (the bug)
    - Any error messages, console output, or screenshots

4. **Reproduce it at least twice** to confirm it's consistent, not a fluke.

5. **If you can't reproduce it:** The issue may have been partially fixed, or your environment may differ from the reporter's. Check the issue comments for version information. Ask in #dts-su26-ai301-solution-planning or comment on the issue itself asking for clarification.

#### Using AI to Help Reproduce
Paste the issue URL or description into Claude Code or other AI tools and ask:

- "Based on this issue, what files are likely involved?"
- "What steps would reproduce this bug in your local environment?"
- "Where in the codebase should I look for the relevant code?"

AI won't replace your own investigation, but it can point you to the right files and save hours of manual code-searching.

### Step 4: Write Your Solution Plan (1–2 hours)
Now that you can reproduce the issue, think through how to fix it before writing any code. A plan prevents wasted effort and gives mentors something concrete to review.

Your plan should answer four questions:

1. **What's the root cause?** Why is this happening? Trace the behavior to the specific code (file, function, line if possible) that's responsible. Use AI tools to help navigate the codebase.

2. **What's your proposed fix?** Describe the change at a high level. "I will modify the validation method in user.rb to check email format before saving" is good. "I will fix the bug" is not.

3. **What files will you touch?** List the specific files you expect to modify. This helps mentors validate your approach.

4. **How will you verify it works?** What tests will you write or run? How will you confirm the bug is fixed and nothing else is broken?

#### The UMPIRE Framework (Adapted)
Use this structure to organize your plan in your README:

- **Understand:** Restate the problem in your own words. What's broken? What should happen instead?
- **Match:** What similar patterns or solutions exist in the codebase? Find a related piece of code that does something similar to what you need.
- **Plan:** Step-by-step implementation plan. What will you modify, add, or remove?
- **Implement:** (You'll do this in Phase III — leave a placeholder link for your branch)
- **Review:** How will you self-review against the project's contribution guidelines (look for _CONTRIBUTING.md_ in the project root)? Review the project's commit message and pull request conventions now so you're prepared.
- **Evaluate:** What tests will confirm your fix works? Most projects require automated testing — check the project's contribution guidelines for what kind of tests are expected.

### Step 5: Update Your README and Check-In (30 minutes)
Add or update the following sections of your Contribution README:

#### Under Reproduction Process:

- **Environment Setup:** Notes on challenges you faced and how you solved them (any errors, how you resolved them)
- **Steps to Reproduce:** Numbered steps another person could follow
- **Branch Link:** Direct link to your working branch in your fork

#### Under Solution Approach:

- Implementation Plan — Your UMPIRE-based plan or equivalent
Then [submit](https://courses.codepath.org/courses/ai301/pages/getting_started) your contribution readme and indicate "Phase II Complete."