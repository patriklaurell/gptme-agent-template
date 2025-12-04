# Agent Dotfiles

Configuration files for agent development environment, version controlled for portability and sharing.

## Installation

```bash
cd <agent-brain-repo>/dotfiles
./install.sh
```

The install script will:
- Auto-detect your agent name from the parent directory
- Create symlinks to configuration directories
- Configure git to use the global hooks
- Set up pre-commit template directory

## Structure

.config/
├── git/
│   └── hooks/               # Global git hooks
│       ├── pre-commit       # Validates branch base and forbidden repos
│       ├── pre-push         # Validates worktree tracking
│       ├── post-checkout    # Warns on branch creation from wrong base
│       ├── validate-branch-base.sh      # Warns if not branching from origin/master
│       └── validate-worktree-tracking.sh # Validates upstream tracking before push
└── pre-commit/
    └── config.yaml          # Global pre-commit hooks (run on all repos)

## Git Hooks

### pre-commit
Validates branch base and optionally prevents commits to master/main in external repos.
Forbidden repos are defined in the FORBIDDEN_PATTERNS array in the hook script.

### validate-branch-base.sh (Pre-commit)
Warns if creating commits on a branch not based on latest `origin/master`. Prevents the issue of accidentally branching from unmerged local commits.

### pre-push
Validates worktree tracking before push operations.

### validate-worktree-tracking.sh (Pre-push)
Validates that the current branch has proper upstream tracking configured. Prevents pushing to wrong branches or missing remote tracking.

### post-checkout
Runs on branch checkout to warn early if branching from the wrong base. Provides actionable feedback before any commits are made.

## Global Pre-commit Config

The `~/.config/pre-commit/config.yaml` runs these hooks on ALL repositories:
- validate-branch-base (on commit)
- validate-worktree-tracking (on push)

These run before any repo-local pre-commit hooks.

## Symlink Structure

After installation:
- `~/.config/git/hooks/` → `<agent-repo>/dotfiles/.config/git/hooks/`
- `~/.config/pre-commit/` → `<agent-repo>/dotfiles/.config/pre-commit/`
- Git `core.hooksPath` set to `~/.config/git/hooks`
- Git `init.templateDir` set to `~/.git-templates` (for pre-commit)

## Configuration

### Forbidden Repos

To customize which repos forbid master/main commits, edit the FORBIDDEN_PATTERNS array in `.config/git/hooks/pre-commit`:

```bash
FORBIDDEN_PATTERNS=(
    "gptme/gptme"
    "gptme/gptme-contrib"
    "ActivityWatch/"
)
```

Add patterns matching repository URLs where you don't have push access to master/main.

## Adding New Hooks

1. Add hook script to `.config/git/hooks/`
2. Make it executable: `chmod +x .config/git/hooks/your-hook.sh`
3. Run `./install.sh` to update symlinks (usually not needed if directory already linked)

## Testing

To verify installation:

```bash
cd <agent-repo>
git commit --allow-empty -m "test hooks"
```

You should see the branch validation hooks run.

## Upstreaming

These dotfiles are designed to be generic and upstreamable to the agent template repository. The configuration is agent-agnostic, with agent-specific patterns handled through optional configuration files.
