---
name: adrien-record-preference
description: >
  Record the user's taste as it shows up in a conversation: a corrected word
  goes to the glossary, a liked or disliked piece of code goes to the
  patterns file with the snippet and the reason. Use when the user corrects
  a term or a name, or says they like or dislike a piece of code, a pattern,
  or a way of writing it.
---

# Record a preference

The user's taste lives in two files. Reviewers and every agent that writes
code read them, so a preference recorded once applies everywhere after.

- words: `~/.dotfiles/dotfiles/docs/glossary.md`
- code: `~/.dotfiles/dotfiles/docs/patterns.md`

## When the user corrects a word

The user replaces a word or a name with another: "call it a claim, not a
bill". Add or update the glossary entry for the word they want, and put
the word they rejected under "don't use", so a reviewer can flag it later.

## When the user likes or dislikes code

Copy the snippet the user reacted to as is, trimmed to the lines that show
the pattern, 20 lines at most. Record it under "Liked" or "Disliked", with
a title that names the pattern, not the feature it comes from.

## Always record why

A preference without its reason can't be applied to new code: the next
agent only sees the snippet, and copies it or avoids it blindly.

When the user said why, write it in their words. When they didn't, and the
reason is not obvious from the conversation, ask them one question before
recording. Never invent a reason.

## Before writing

Read the file first. When an entry already covers the preference, update
it instead of adding a second one. When the new preference contradicts an
existing entry, show both to the user and ask which one stands.

Then show the user the entry you wrote, in one block.
