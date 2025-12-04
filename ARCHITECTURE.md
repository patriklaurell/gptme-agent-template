# Architecture

This document describes the architecture and workflows of the workspace.

## Overview

This workspace implements a forkable agent architecture, designed to be used as a foundation for creating new agents. For details about:

- Forking process: See [`knowledge/agent-forking.md`](./knowledge/agent-forking.md)
- Workspace structure: See [`knowledge/forking-workspace.md`](./knowledge/forking-workspace.md)

## Tools

For a information about tools used in this workspace, see [`TOOLS.md`](./TOOLS.md).

## Dotfiles

The [`dotfiles/`](./dotfiles/) directory contains version-controlled configuration files for the agent's user environment. These are symlinked to the agent's home directory during installation.

### Purpose

Agents run as their own users (on servers or locally), and need their own configuration. The dotfiles directory:
- Version controls all agent-specific configurations
- Makes agent setup reproducible
- Allows sharing configurations across agent instances
- Provides a clean separation between workspace code and environment config

### Included Configurations

**Git Workflow** (`.config/git/`):
- Hooks for branch validation and upstream tracking
- Pre-commit integration for all repositories
- Protection against direct commits to master/main in external repos

**Systemd Services** (`.config/systemd/user/`):
- Example services for autonomous operation
- Timers for scheduled tasks
- Can be customized per agent

**Other Configs**:
- Shell environment settings
- Editor configurations
- Any other dotfiles the agent needs

### Installation

```sh
cd dotfiles
./install.sh
```

The install script:
- Auto-detects agent name from parent directory
- Creates symlinks to `~/.config/` and other locations
- Configures git globally
- Sets up systemd services (if present)

### Customization

Agents should customize their dotfiles as needed:
1. Add new configuration files to appropriate `.config/` subdirectories
2. Update `install.sh` if new symlinks are needed
3. Make files executable if required (`chmod +x`)
4. Document customizations in `dotfiles/README.md`

See [`dotfiles/README.md`](./dotfiles/README.md) for detailed documentation.

## Task System

The task system helps to track and manage work effectively across sessions. It consists of:

- Task files in [`tasks/`](./tasks/) as single source of truth
- Task management CLI in `scripts/tasks.py` (optional, from gptme-contrib when available)
- Daily progress logs in [`journal/`](./journal/)

See [`TASKS.md`](./TASKS.md) for more details on the task system.

## Journal System

The journal system provides a daily log of activities, thoughts, and progress.

### Structure

- One file per day: `YYYY-MM-DD.md`
- Located in [`journal/`](./journal) directory
- Entries are to be appended, not overwritten
- Historical entries are not to be modified
- Contains:
  - Task progress updates
  - Decisions and rationale
  - Reflections and insights
  - Plans for next steps

## Knowledge Base

The knowledge base stores long-term information and documentation.

### Structure

- Located in [`knowledge/`](./knowledge)
- Organized by topic/domain
- Includes:
  - Technical documentation
  - Best practices
  - Project insights
  - Reference materials

## People Directory

The people directory stores information about individuals the agent interacts with.

### Structure

- Located in [`people/`](./people)
- Contains:
  - Individual profiles in Markdown format
  - Templates for consistent profile creation
- Each profile includes:
  - Basic information
  - Contact details
  - Interests and skills
  - Project collaborations
  - Notes and history
  - Preferences
  - TODOs and action items

### Best Practices

1. **Privacy**

   - Respect privacy preferences
   - Only include publicly available information
   - Maintain appropriate level of detail

2. **Updates**

   - Keep interaction history current
   - Update project collaborations
   - Maintain active TODO lists

3. **Organization**
   - Use consistent formatting via templates
   - Cross-reference with projects and tasks
   - Link to relevant knowledge base entries
