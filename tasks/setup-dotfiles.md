---
state: new
created: 2025-12-04
priority: high
tags: [setup, configuration]
---

# Setup Dotfiles

Configure the dotfiles system for this agent instance by customizing the template files and installing the symlinks.

## Overview

The dotfiles directory contains version-controlled configuration files that need to be customized for this agent and installed to the agent's home directory.

## Important: Customize Before Installing

**You must instantiate and customize configuration files BEFORE running install.sh.**

The install.sh script creates symlinks to files in this directory. If you install first and customize later, the symlinks will point to template files with placeholders, which won't work.

## Steps

### 1. Instantiate Systemd Services (Optional but Recommended)

For autonomous operation with systemd, you must:

1. **Copy the example files** (removing .example extension)
2. **Replace ALL placeholders** in the copied files
3. **Only then** run install.sh

```bash
cd dotfiles/.config/systemd/user/

# Copy and rename (this creates the actual service files)
cp agent-autonomous.service.example {{AGENT_NAME}}-autonomous.service
cp agent-autonomous.timer.example {{AGENT_NAME}}-autonomous.timer

# IMPORTANT: Edit both files and replace ALL placeholders:
# - {{AGENT_NAME}} → Your actual agent name (e.g., "james")
# - {{AGENT_HOME}} → Full path to home directory (e.g., "/home/james")
# - {{AGENT_REPO}} → Repository name (e.g., "james")

# Example:
# If your agent is "james" at /home/james/james:
# {{AGENT_NAME}} → james
# {{AGENT_HOME}} → /home/james
# {{AGENT_REPO}} → james

# Customize the timer schedule in the .timer file as needed
```

### 2. Customize Forbidden Repos (Optional)

Edit the forbidden patterns for repos where master/main commits should be blocked:

```bash
# Edit dotfiles/.config/git/hooks/pre-commit
# Update the FORBIDDEN_PATTERNS array with repos where you don't have push access
```

### 3. Install Dotfiles (After Customization)

**Only after completing steps 1-2**, run the install script to create symlinks:

```bash
cd dotfiles
./install.sh
```

This will:
- Create symlinks from `~/.config/` to files in this dotfiles directory
- Configure git globally to use these hooks
- Set up pre-commit template directory

**Note**: The symlinks point to files in this repo, so:
- Any future edits to dotfiles/ automatically apply (via symlinks)
- If you didn't customize first, the symlinks will point to template files with placeholders

### 4. Enable Systemd Services (If Configured)

If you set up systemd services, you MUST reload systemd and verify they're running:

```bash
# 1. Reload systemd to recognize new service files (REQUIRED)
systemctl --user daemon-reload

# 2. Enable the timer (starts automatically on boot)
systemctl --user enable {{AGENT_NAME}}-autonomous.timer

# 3. Start the timer now
systemctl --user start {{AGENT_NAME}}-autonomous.timer

# 4. Verify the timer is active and running
systemctl --user status {{AGENT_NAME}}-autonomous.timer

# 5. List all timers to confirm it's scheduled
systemctl --user list-timers

# 6. Check for any errors in logs
journalctl --user -u {{AGENT_NAME}}-autonomous.timer --since today
```

**Expected output:**
- Status should show "active (waiting)"
- Timer should appear in list-timers
- No errors in journal logs

### 5. Test Installation

Verify the git hooks are working:

```bash
cd ..  # Back to repo root
git commit --allow-empty -m "test: verify dotfiles hooks"
```

You should see the branch validation hooks run.

## Success Criteria

- [ ] Systemd services customized (if using)
- [ ] Forbidden repo patterns customized (if needed)
- [ ] install.sh executed successfully
- [ ] Git hooks active and working
- [ ] Systemd services enabled and running (if using)
  - [ ] systemctl --user daemon-reload executed
  - [ ] Timer shows as "active (waiting)" in status
  - [ ] Timer appears in list-timers output
  - [ ] No errors in journal logs

## Notes

- The dotfiles use symlinks, so updates to the repo automatically apply
- Git hooks prevent common workflow mistakes (wrong branch base, missing upstream)
- Systemd services are optional - only needed for autonomous operation

## Related

- [`dotfiles/README.md`](../dotfiles/README.md) - Complete dotfiles documentation
- [`dotfiles/.config/systemd/user/README.md`](../dotfiles/.config/systemd/user/README.md) - Systemd service documentation
