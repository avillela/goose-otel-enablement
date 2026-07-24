# Goose Initial Setup & Configuration

These instructions are for setting up Goose with Claude Code. The Goose configuration file can be found at: `~/.config/goose/config.yaml`.

1- Login to Claude Code

Open up a Claude Code session by typing `claude`, and following the login instructions.

2- Install Goose

```bash
GOOSE_RELEASE="v1.43.0"
curl -fsSL https://github.com/aaif-goose/goose/releases/download/${GOOSE_RELEASE}/download_cli.sh | bash
```

3- Configure your provider

> **NOTE:** If you need to configure your provider again, run `goose configure`

![select goose provider](/images/goose-provider.png)

* **How would you like to set up your provider?**: `Manual Configuration`


![select model provider](/images/goose-model-provider.png)

* **Which model provider should we use?**: `Claude Code CLI`

![set Claude Code CLI command](/images/goose-claude-code-cli-command.png)

* **Provider Claude Code CLI requires CLAUDE_CODE_COMMAND, please enter a value**: `claude`

![select Claude model](/images/goose-claude-model.png)

* **Select model**: `claude-sonnet-4-6`

![select thinking effort](/images/goose-thinking-effort.png)

* **Select thinking effort**: `Low - Better latency, lighter reasoning`

![Goose config success](/images/goose-config-success.png)

Success!!

Unfortunately, Claude CLI is deprecated, but we don't have the option to select `Claude ACP`, but I did find a workaround by asking Goose to switch to that configuration. I'll save you the trouble of having to do that, and all you need to do instead is open up your [`Goose config.yaml`](~/.config/goose/config.yaml) file, and locate the code snipped below:

```yaml
CLAUDE_CODE_COMMAND: claude
active_provider: claude-code
providers:
  claude-code:
    enabled: true
    model: sonnet
    configured: true
GOOSE_THINKING_EFFORT: low
```

Replace with:

```yaml
CLAUDE_CODE_COMMAND: claude
active_provider: claude-acp
providers:
  claude-acp:
    enabled: true
    model: sonnet
    configured: true
GOOSE_THINKING_EFFORT: low
```

Note that all we did was replace `claude-code` with `claude-acp`.

Globally install the Claude ACP package:

```bash
npm install -g @agentclientprotocol/claude-agent-acp
```

For more info, check out out the Goose ACP docs [here](https://goose-docs.ai/docs/guides/acp-providers/#claude-acp-configuration).

> **NOTE:** Feel free to change the `GOOSE_THINKING_EFFORT` and `model` to something that suits you better (e.g. `GOOSE_THINKING_EFFORT: medium` and `model: haiku`).

4- Login to Claude

Claude authentication is required before you can use Claude ACP with Goose. Open a new terminal window and login to Claude, and follow the login instructions.

```bash
claude
```

5- Start goose

Once Claude is authenticated, open a new terminal window and start Goose:

```bash
goose session
```

![goose session startup](/images/goose-session.png)

---

## NEXT STEPS: OpenTelemetry Enablement for Goose

Enable and configure OpenTelemetry for Goose [here](/src/docs/goose-otel-enablement.md).
