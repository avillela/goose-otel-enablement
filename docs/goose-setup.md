# Goose Initial Setup & Configuration

These instructions are for setting up Goose with with the [Claude ACP](https://goose-docs.ai/docs/guides/acp-providers#claude-acp) provider.

The Goose configuration file can be found at: `~/.config/goose/config.yaml`.

## 1. Install Goose

```bash
GOOSE_RELEASE="v1.43.0"
curl -fsSL https://github.com/aaif-goose/goose/releases/download/${GOOSE_RELEASE}/download_cli.sh | bash
```

## 2. Configure your provider

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

Unfortunately, as you were making your selection, you may have noticed that the Claude CLI is deprecated. On top of that, we don't have the option to select `Claude ACP`. ARRGH!! Fortunately, I found a workaround.

First, open your [`Goose config.yaml`](~/.config/goose/config.yaml) file, and locate the code snipped below:

```yaml
active_provider: claude-code
providers:
  claude-code:
    enabled: true
    model: sonnet
    configured: true
```

Replace `claude-code` with `claude-acp`. Your modified block should look like this:

```yaml
active_provider: claude-acp
providers:
  claude-acp:
    enabled: true
    model: sonnet
    configured: true
```

You also need to globally install the Claude ACP npm package:

```bash
npm install -g @agentclientprotocol/claude-agent-acp
```

For more info, check out out the [Goose ACP docs](https://goose-docs.ai/docs/guides/acp-providers/#claude-acp-configuration).

### 3. Login to Claude

Open a new terminal window, then start a Claude Code session by typing `claude`, and following the login instructions.

### 4. Start goose

Once Claude is authenticated, open a new terminal window and start Goose:

```bash
goose session
```

![goose session startup](/images/goose-session.png)

---

## NEXT STEPS: OpenTelemetry Enablement for Goose

Enable and configure OpenTelemetry for Goose [here](/src/docs/goose-otel-enablement.md).
