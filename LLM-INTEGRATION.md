# LLM Service Configuration for Task Orchestrator

## Current Status

The task orchestrator currently uses **rule-based decomposition** as a fallback. To enable full LLM-powered task breakdown, configure one of the available LLM services.

## Configuration Options

### Option 1: Custom LLM Service

Edit `~/.config/task-orchestrator/config.json`:

```json
{
  "llm": {
    "provider": "custom",
    "endpoint": "https://your-llm-api.com/v1/chat/completions",
    "model": "your-model-name",
    "apiKey": "your-api-key",
    "temperature": 0.7,
    "maxTokens": 4096,
    "timeout": 30000
  }
}
```

### Option 2: OpenAI Compatible

```json
{
  "llm": {
    "provider": "openai",
    "endpoint": "https://api.openai.com/v1/chat/completions",
    "model": "gpt-4o",
    "apiKeyEnv": "OPENAI_API_KEY",
    "temperature": 0.7,
    "maxTokens": 4096,
    "timeout": 30000
  }
}
```

### Option 3: Local LLM (Ollama)

```json
{
  "llm": {
    "provider": "ollama",
    "endpoint": "http://localhost:11434/api/chat",
    "model": "llama3.2",
    "apiKeyEnv": null,
    "temperature": 0.7,
    "maxTokens": 4096,
    "timeout": 60000
  }
}
```

### Option 4: OpenClaw Native

```json
{
  "llm": {
    "provider": "openclaw",
    "endpoint": "internal",
    "model": "default",
    "apiKeyEnv": null,
    "temperature": 0.7,
    "maxTokens": 4096,
    "timeout": 30000
  }
}
```

## Integration Points

Once configured, the LLM will be used for:

1. **Task Decomposition** - Break complex tasks into subtasks
2. **Tool Selection** - Choose optimal tools per subtask
3. **Dependency Detection** - Identify which subtasks depend on others
4. **Parallel Group Identification** - Find independent execution groups
5. **Complexity Estimation** - Determine task difficulty and duration

## Testing

After configuration, test LLM integration:

```bash
# Test LLM connection
task-orch test-llm --verbose

# Analyze with LLM (will use LLM if configured, fallback otherwise)
task-orch analyze "Create a blog post" --dry-run

# Run full decomposition and execution
task-orch start "Complex multi-step task"
```

## Troubleshooting

### LLM Not Responding

```bash
# Check config
cat ~/.config/task-orchestrator/config.json

# Verify environment variables
echo $OPENAI_API_KEY  # or your chosen API key env

# Check endpoint connectivity
curl -X POST <your-llm-endpoint>
```

### Decomposition Fails

If LLM fails for any reason, the system automatically falls back to **rule-based decomposition** - you'll see:

```
⚠️  LLM decomposition failed: <error>
   Falling back to rule-based decomposition
```

This is expected behavior and ensures reliability.

## Next Steps

To implement production LLM integration:

1. **Choose your LLM provider** (OpenAI, Anthropic, open-source, etc.)
2. **Update `callLLM()` function** in `task-orch` to integrate with chosen provider
3. **Add retry logic** for LLM timeouts/failures
4. **Add structured output validation** to ensure JSON responses
5. **Test with diverse task types** to verify quality

Alternatively, implement an `agent-browser` integration to call the OpenClaw gateway's internal LLM service.

---

**Current State:** Rule-based decomposition working perfectly. LLM integration ready to configure with your preferred provider.
