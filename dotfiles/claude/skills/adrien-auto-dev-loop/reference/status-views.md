# Status views

By default, use agent driven view.
User may ask to use PR driven view. When they ask, remember the setting for the rest of the session.

## Agent-driven view

Once the first agent is launched, every 20 minutes or when the user asks, you print a markdown table listing the following columns for past and current agents:
- **Column 1:** the PR they are working on
    - PR number, very short but expressive name
    - example: "PR1: Add method to repo"
- **Column 2:** the model, and the tokens consumed
    - example: "Fable 5.1 (131k)"
- **Column 3:** the scope of the work:
    - "Plan", "Implementation", "Review", "Docstring", "Babysit", etc...
- **Column 4:** start time
    - time if same day: "18h34"
    - date + time if started on another day: "June 23rd, 18h43"
- **Column 5:** how long was the agent alive?
    - if < 1h express in minutes: "12min"
    - if > 1h express as: "1h 12min"
- **Column 6:** end time or ETA
    - if the agent terminated, specify time and status: "Killed 10h12" to symbolise we had to terminate, and "Stopped 11h12" to satisfy scheduled termination because task ended
    - if the agent is running, "Running, ETA 15m"

You use a cron to schedule this update, and you keep running it until either all work is completed or user asks you to stop.
User may ask you to order rows by any of the column. If they do, you remember the request for the rest of the session.

## PR-driven view

Same cron, cadence, time formats and ordering rules as the agent-driven view, but with one row per PR.
Order rows by PR number by default.

Columns:
- **Column 1:** the PR
    - PR number, very short but expressive name
    - example: "PR1: Add method to repo"
- **Column 2:** implemented at
- **Columns 3 to 5:** reviewed at, 1 column per review step: correctness, vocabulary, patterns
- **Column 6:** pushed at
- **Column 7:** CI status
    - "Passing", "Running", "Failing (2 checks)"
    - "None" if not pushed yet

For columns 2 to 6:
- if the step is done, print the time: "18h34"
- if the step is in progress: "Ongoing, ETA 15m"
- if the step has not started: "Not started"

## Swarm rows

In a swarm, the agent view shows one row per running worktree rather than
one per agent. In a surface swarm, the scope column reads "Swarm: 4 items
done, item 12 in progress". Take those numbers from `ls` on
`~/.agent-loop/<task>/queue/`, not from the workers. The PR view shows a
swarm PR only once its branch has closed.
