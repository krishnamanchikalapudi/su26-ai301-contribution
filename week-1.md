# Week-1

## 📖 What This Phase Is About
Phase I is where your contribution journey begins. This week, you'll get accounts set up, choose an issue, and fork the project you chose to work on.

This might sound like a lot, but each piece is straightforward. Setup should take about 30 minutes. The README takes 15 minutes to set up. The real work of Phase I is choosing your issue thoughtfully.

Your issue selection is the decision that shapes everything that follows. A well-chosen issue leads to a clear plan, productive build time, and a strong pull request. A poorly chosen issue leads to weeks of frustration, scope creep, and starting over.

**Target duration:** 1–3 days. All four tasks should be complete by the end of your first week.

## 🏁 What "Done" Looks Like
To complete Phase I, you need to do seven things:

1. **Log into your GitHub and Slack accounts** so you have access to the tools and systems you'll use for the rest of the program.

2. **Create your Contribution README** — the living document that will track your entire journey through the program. You'll create a new public GitHub repository and copy in the  [provided template](https://courses.codepath.org/course_files/ai301/contribution_readme.md).

3. **Find one live GitHub issue from our list** that you will work on for the next several weeks.

4. **Update your README** to demonstrate that you understand what your issue is actually asking for with:
    - A link to your chosen GitHub issue in the Issue field
    - A 2–4 sentence problem summary explaining what the issue is, why it matters, and why you chose it in **Why I Chose This Issue**

5. **Leave a comment on your chosen issue** expressing interest and any initial questions you have. Leave a comment on our course's Google Sheet on your issue's row, too, so we don't recommend your issue to your classmates.

6. **Fork your chosen project** so you have your own copy of the repository to work in.

7. **Submit your check-in form and indicate "Phase I Complete."**

No code. No local environment setup. No fork cloning. That all happens in Phase II. Phase I is about getting set up, setting up your README, and choosing well.

## 🗺️ Step-by-Step Procedure

### Step 1: Log Into Your GitHub and Slack Accounts to Set Up as a Contributor (30 minutes)
Before you can do anything else, you'll need your GitHub and Slack accounts. This is a one-time setup.

**Create your [CodePath Student Slack account](CodePath Student Slack account)**. This isn't the same Slack organization you used for prework, but it is where you'll be able to get help throughout your journey and report on progress to your peers.

**Log into your [GitHub account](https://github.com/)**. This should be the same one you used to register and use to attend class. Choose a professional username — this account will represent you publicly.

**Practice Contributing!** If you haven't yet, complete the First Contributions tutorial to get your first contribution under your belt in a totally stress-free environment. This way after you select an issue in Steps 3–6 below, you'll be able to get started right away!

**Join the CodePath community _#dts-su26-ai301-contribute_ channel in Slack**. This is where program staff, instructors, and your peers answer contributor questions throughout the program — equivalent to a community support forum.

_How to know you're done: You have access to your GitHub account and you're in the CodePath Slack. You'll fork your chosen project in Step 7, after you've selected your issue._

### Step 2: Create Your Contribution README (15 minutes)
Your **Contribution README** is the single most important artifact of this program. It is a living document hosted on your own GitHub repository that tracks your entire journey — from issue selection through pull request submission. Mentors and staff will read your README to understand where you are, what you're working on, and how to help you. You will update it every week.

#### How to set it up:

1. Create a new public GitHub repository to host your README:
    - Go to [github.com/new](https://github.com/new)
    - Name it something clear like _su26-ai301-contribution_ or _github-contribution-log_
    - Set visibility to **Public** (mentors and staff need to be able to view it)
    - Check **"Initialize repository with a README"**
    - Click **Create repository**

2. **Copy the [Contribution README template](https://courses.codepath.org/course_files/ai301/contribution_readme.md)** into your new repository. You have two options:

##### Option A: GitHub web editor (no local setup needed)

    - Download the README template above and use it as your starting content.
    - In your new repository, click your README.md file, then click the pencil icon to edit directly in the browser.
    - Replace the default README content with the template you copied.
    - Click **Commit changes** and practice writing a clear, concise commit message!

##### Option B: Local clone
<code>
git clone https://github.com/<your-username>/su26-ai301-contribution.git
cd su26-ai301-contribution
</code>

    - Download the README template above and copy the contents into your _README.md_
    - Commit and push:
    <code>
git add README.md
git commit -m "Add contribution README template"
git push origin main
</code>

3. **Confirm it's working:** Navigate to your repository on GitHub. You should see the README template rendered with all the section headers for each phase. **Save the URL to your repository** — you'll include this link as your submission each week so mentors and staff can find your README throughout the program. You can bookmark it, star your repo, or just remember how to navigate to it from your GitHub profile.

4. Familiarize yourself with the template sections. You'll fill them in progressively as you move through each phase:

    - Phase I: Issue link + problem summary + why you chose this issue
    - Phase II: understanding the issue + reproduction process + solution approach
    - Phase III: testing strategy + implementation notes
    - Phase IV: PR link + summary + maintainer feedback log

_Think of your Contribution README as a professional engineering journal. It's not busywork — it's the document that lets staff give you targeted feedback, lets us know if you're stuck, and serves as a portfolio piece showing your contribution process. Strong READMEs lead to better support. Weak READMEs make it harder for anyone to help you._

### Step 3: Browse the Issue Lists (30 minutes max)
Now it's time to find your issue. We've curated a list of issues for you to choose from in this class. These have been pre-vetted for feasibility and active maintainer engagement. Skim titles and descriptions. **Don't read every issue deeply yet.** Star or bookmark 3–5 that catch your eye based on: the title sounds like something you could explain to a friend, it involves a technology or area you're curious about, and it seems specific (not a massive overhaul).

### Step 4: Read Your Top 3 Candidates Carefully (30 minutes)
For each of your 3 best options, open the full issue page and read:

    - The original issue description
    - All comments from maintainers or team members
    - Any linked pull requests (are there failed attempts you can learn from?)
    - The labels (look for labels like _good first issue_ or _help wanted_ which are standard GitHub labels for new contributors) or the context feels achievable for you.
    - You might also skim the _CONTRIBUTING.md_ at this time in case there are dependencies on tools you'd like to avoid.

### Step 5: Run the Issue Selection Checklist (15 minutes)
For each of your 3 candidates, go through all 6 checks below. Write down your answers — even rough notes count. Discard any issue that doesn't pass at least 4 of these checks.

#### ✅ Check 1: I understand the problem.
Can you explain what is broken or missing in one sentence? Do you know what "fixed" looks like? If you can't articulate the problem in plain language, you don't understand the issue yet — and that's a sign to keep reading or keep looking.

#### ✅ Check 2: The scope fits 3–4 weeks of work.
The issue should be **specific and bounded**. Good examples: "Add validation to X form," "Fix incorrect tooltip rendering on Y page," "Update Z API endpoint to handle edge case." Bad examples: "Refactor authentication system," "Improve performance," "Redesign settings page." If the issue description is more than a few paragraphs of requirements, it is probably too large.

#### ✅ Check 3: It matches my skills (or things I can learn quickly with AI).
The issue involves languages, frameworks, or patterns that you already know — or that you could realistically learn with Claude Code in a few days. If the issue requires deep expertise in a system you've never touched and can't quickly ramp on, it's not the right fit for this cycle.

#### ✅ Check 4: The issue is active and claimable.
Look for these signals:

    - Maintainer or team member activity in the last 6 months
    - **Not** assigned and nobody has claimed it in the comments
    - **Not** labeled "proposal," "needs discussion," "blocked," "wontfix" or any other labels that signal a deadend
    - No open pull request already solving it (check for linked pull requests on the issue page)

#### ✅ Check 5: There is helpful context.
Are there comments from maintainers with analysis, hints, or related issues? Are there links to the relevant code files? The more context an issue has, the faster you'll move in Phase II.

#### ✅ Check 6: The project has clear setup documentation.
Find the project's _README.md_ and _CONTRIBUTING.md_. Can you follow the setup instructions? Are they recent and specific to your OS? This is one of the most important criteria. If the docs are sparse and there's no community help available, you'll likely want to pick a different project.

##### Decision Rule
| Result | Action |
| :--- | :--- |
| All 6 checked | **Claim it.** Move to the next step. |
| 4–5 checked | **Ask for help.** Post in #dts-su26-ai301-issue-selection or ask classmates during standup. |
| Fewer than 4 | **Skip it.** Keep looking. |

### Step 6: Pick One and Commit (5 minutes)
Choose the issue that scored highest on the checklist. If two are tied, pick the one with more maintainer context — it will make Phase II significantly easier.

If you're still feeling like two are equally interesting, check these criteria:

#### ✅ Green flags:

     - **Comment count ≤ 5** (ideally ≤ 3) — less discussion often means less complexity
     - **No assignees** — available for you to work on
     - **No subtasks** — self-contained work
     - **Clear acceptance criteria** — you know what "done" looks like
     - **No existing open PR** — check the linked pull requests on the issue page
     - **Clear setup docs** — the project has a working quickstart, a devcontainer.json, or an active community answering setup questions

#### ⚠️ Red flags:

     - **Comment count > 10 — likely complex or controversial
     - **Already assigned — someone is working on it
     - **Has blocking issues — dependencies may delay your work
     - **Multiple subtasks — might be more complex than it appears
     - **Missing or outdated setup docs — if you can't get the project running locally, you can't contribute

### Step 7: Fork Your Chosen Project (10 minutes)
Now that you've selected your issue, create a fork of the project you'll contribute to. A [fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks) is your personal copy of the repository where you'll do all your work before submitting a pull request.

1. Navigate to the project repository on GitHub
2. Click the **Fork** button in the top-right corner
3. Choose your GitHub account as the destination
4. Click **Create fork**

How to know you're done: You have a repository at https://github.com/<your-username>/<project-name>. You don't need to clone it locally yet — that happens in Phase II.

### Step 8: Comment on Your Issue (2 minutes)
This is your first interaction with the project's contributor community. Leave a comment on your chosen issue page on GitHub introducing yourself and expressing your intent to work on it:

_Hi! I'm a student in the CodePath AI301 program and I'd like to work on this issue. I'll start by reproducing the problem locally this week. Any pointers on where to start in the codebase would be appreciated!_

Some GitHub projects may have a **Discussions** tab where maintainers and contributors communicate more broadly. Check there for any existing conversation about the issue area.

**Don't skip this step.** Early engagement saves you from discovering in Week 3 that your issue was already resolved, is blocked on other work, or has hidden complexity. You do not need to be officially assigned to the issue to start working.

### Step 9: Update Your README and Check-In Form (15 minutes)
Open the Contribution README in the project you created in Step 2 and fill in the **Issue** and **Why I Chose This Issue sections.**

Then update the **Status** field to "Phase I Complete" and submit the link in the [course portal](https://courses.codepath.org/courses/ai301/pages/getting_started).

### Step 10: Announce in Slack (2 minutes)
Post in _#dts-su26-ai301-celebration_ on our [program Slack](https://codepath.slack.com/):

_"🎯 Phase I Complete — Selected [issue title]: [one-line summary]. Link: [url]" or anything you want us to hype you up for!_

This celebrates your milestone with the cohort and lets mentors and peers see what you're working on. Use _#dts-su26-ai301-celebration_ for announcements and milestones. Use _#dts-su26-ai301-issue-selection_ for technical questions, troubleshooting, or when you need help choosing.

