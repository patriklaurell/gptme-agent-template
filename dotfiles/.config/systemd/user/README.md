# Systemd User Services

This directory contains example systemd user services for agent autonomous operation.

## Available Examples

### agent-autonomous.service.template
Service template for running autonomous operations. Copy and customize for your agent.

### agent-autonomous.timer.template
Timer template for scheduling autonomous runs. Copy and customize the schedule.

## Setup Instructions

1. **Copy and rename the template files:**
   ```bash
   cd dotfiles/.config/systemd/user/
   cp agent-autonomous.service.template <agent-name>-autonomous.service
   cp agent-autonomous.timer.template <agent-name>-autonomous.timer
   ```

2. **Replace placeholders in the service file:**
   - `{{AGENT_NAME}}` → Your agent's name (e.g., "MyAgent")
   - `{{AGENT_HOME}}` → Home directory (e.g., "/home/myagent")
   - `{{AGENT_REPO}}` → Repository name (e.g., "myagent")

3. **Customize the timer schedule** in the .timer file as needed

4. **Install the services:**
   ```bash
   # Reload systemd to recognize new services
   systemctl --user daemon-reload

   # Enable and start the timer
   systemctl --user enable <agent-name>-autonomous.timer
   systemctl --user start <agent-name>-autonomous.timer
   ```

## Checking Status

```bash
# Check timer status
systemctl --user status <agent-name>-autonomous.timer

# Check service status (after it runs)
systemctl --user status <agent-name>-autonomous.service

# View logs
journalctl --user -u <agent-name>-autonomous.service
```

## Customizing Schedule

The timer uses systemd's `OnCalendar` format. Examples:

# Every hour
OnCalendar=hourly

# Every day at 9am
OnCalendar=*-*-* 09:00:00

# Weekdays at 9am and 5pm
OnCalendar=Mon-Fri *-*-* 09,17:00:00

# Every 30 minutes
OnCalendar=*:00/30

## Adding More Services

You can add other systemd services following the same pattern:

1. Create service file in this directory
2. Define `[Unit]`, `[Service]`, and `[Install]` sections
3. For long-running services, use `Type=simple` instead of `Type=oneshot`
4. For scheduled tasks, create a corresponding .timer file

## Example: Long-running Service

```ini
[Unit]
Description=My Agent Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/agent/repo
ExecStart=/home/agent/repo/scripts/server.sh
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
```

## Integration with install.sh

To automatically enable services during dotfile installation, add to `install.sh`:

```bash
# Enable and start systemd services
if command -v systemctl >/dev/null 2>&1; then
    systemctl --user daemon-reload
    systemctl --user enable <agent-name>-autonomous.timer
    systemctl --user start <agent-name>-autonomous.timer
fi
```

## Notes

- Systemd user services run without root privileges
- Services start automatically on user login (if enabled)
- Use `--user` flag with all systemctl commands
- Logs are stored in systemd journal (view with `journalctl --user`)
