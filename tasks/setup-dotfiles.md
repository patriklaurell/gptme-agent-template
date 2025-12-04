---
state: new
created: 2025-12-04
priority: high
tags: [setup, configuration]
---

# Setup Dotfiles

Configure the dotfiles system for this agent instance by customizing the example files and installing the symlinks.

## Overview

The dotfiles directory contains version-controlled configuration files that need to be customized for this agent and installed to the agent's home directory.

## Steps

### 1. Customize Systemd Services (Optional)

If you want autonomous operation with systemd:

```bash
cd dotfiles/.config/systemd/user/

# Copy and rename the example files
cp agent-autonomous.service.example {{AGENT_NAME}}-autonomous.service
cp agent-autonomous.timer.example {{AGENT_NAME}}-autonomous.timer

# Edit the service file and replace placeholders:
# - {{AGENT_NAME}} → Your agent's name
# - {{AGENT_HOME}} → Agent's home directory (e.g., /home/myagent)
# - {{AGENT_REPO}} → Repository name

# Customize the timer schedule as needed
```

### 2. Customize Forbidden Repos (Optional)

Edit the forbidden patterns for repos where master/main commits should be blocked:

```bash
# Edit dotfiles/.config/git/hooks/pre-commit
# Update the FORBIDDEN_PATTERNS array with repos where you don't have push access
```

### 3. Install Dotfiles

Run the install script to create symlinks:

```bash
cd dotfiles
./install.sh
```

This will:
- Create symlinks to `~/.config/git/hooks/` and `~/.config/pre-commit/`
- Configure git globally
- Set up pre-commit template directory

### 4. Enable Systemd Services (If Configured)

If you set up systemd services:

```bash
systemctl --user daemon-reload
systemctl --user enable {{AGENT_NAME}}-autonomous.timer
systemctl --user start {{AGENT_NAME}}-autonomous.timer

# Check status
systemctl --user status {{AGENT_NAME}}-autonomous.timer
```

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

## Notes

- The dotfiles use symlinks, so updates to the repo automatically apply
- Git hooks prevent common workflow mistakes (wrong branch base, missing upstream)
- Systemd services are optional - only needed for autonomous operation

## Related

- [`dotfiles/README.md`](../dotfiles/README.md) - Complete dotfiles documentation
- [`dotfiles/.config/systemd/user/README.md`](../dotfiles/.config/systemd/user/README.md) - Systemd service documentation
