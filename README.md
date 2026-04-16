# Ideal Agent - Advanced Task Orchestration & Workflow Intelligence

> 🔭 **Transform complex tasks into structured, executable workflows with intelligent decomposition, tool selection, and self-learning**

## Overview

Ideal Agent is a comprehensive OpenClaw skill for advanced task orchestration. It breaks down complex, ambiguous tasks into atomic subtasks, orchestrates their execution with proper dependency management, learns from outcomes, and automatically improves future performance.

### Why This Skill?

When facing multi-step tasks, agents typically:
- ❌ Try to handle everything holistically and get confused
- ❌ Forget dependencies between steps
- ❌ Fail entirely when one step breaks
- ❌ Repeat the same mistakes
- ❌ Lack progress tracking

Ideal Agent fixes all of this by providing:
- ✅ **Adaptive Decomposition** - Intelligent breakdown of complex tasks
- ✅ **Dependency Management** - Proper sequencing and parallelization
- ✅ **Failure Recovery** - Automatically recovers from errors
- ✅ **Learning Loop** - Captures successes/failures to improve
- ✅ **Progress Tracking** - Real-time status and checkpoint recovery
- ✅ **Tool Optimization** - Selects best tools for each subtask

## Quick Start

### Install

```bash
# Clone the repository
git clone https://github.com/AndresVillaShark/ideal-agent.git

# Navigate to the skill directory
cd ideal-agent

# Install the package globally
npm install -g ideal-agent-task-orchestrator

# Initialize
task-orch init
```

### Configure

Create `~/.config/task-orchestrator/config.json`:

```json
{
  "defaultRetryCount": 3,
  "checkpointDir": "/home/morpheus/.task-checkpoints",
  "learningEnabled": true,
  "learningDir": "/home/morpheus/.openclaw/workspace/.learnings",
  "maxParallelTasks": 3,
  "maxDuration": "2h"
}
```

### Basic Usage

```bash
# Analyze a task (no execution)
task-orch analyze "Create a blog post about OpenClaw skills with code examples" --dry-run

# Start a new task
task-orch start "Create a blog post about OpenClaw skills with code examples"

# Check status
task-orch status task-1234567890

# Resume from checkpoint
task-orch resume task-1234567890

# View recent learnings
task-orch learnings --recent=5
```

## Installation as OpenClaw Skill

### Option 1: Local Install

```bash
# Make sure you're in the repository
cd ideal-agent

# Link the skill
cd skills/task-orchestrator
cp -r SKILL.md ~/your-openclaw-workspace/skills/task-orchestrator/
```

### Option 2: ClawHub Publish

```bash
# Navigate to skill directory
cd ideal-agent/skills/task-orchestrator

# Publish to ClawHub
clawhub publish
```

## Features

### 🔄 Decomposition Engine

Automatically breaks complex tasks into manageable subtasks:

```
Task: "Build a job application campaign for 5 AI companies"

Decomposed into:
├── 1. Research positions (parallel)
├── 2. Extract requirements (parallel)
├── 3. Match skills (sequential)
├── 4. Tailor resume (parallel)
├── 5. Write cover letters (parallel)
├── 6. Fill applications (parallel)
├── 7. Track submissions (sequential)
└── 8. Setup follow-ups (final)
```

### ⚡ Parallel Execution

Identifies independent subtasks that can run concurrently:
- Multiple position searches run in parallel
- Multiple cover letters generated simultaneously
- Reduces total execution time by up to 60%

### 🛡️ Failure Recovery

Automatic recovery strategies:
- Retry with exponential backoff (max 3 attempts)
- Try fallback approaches
- Continue independent tasks even if others fail
- Checkpoint before critical actions for full recovery

### 📚 Learning Engine

Captures learnings automatically:
```json
{
  "task": "Job Application Campaign",
  "date": "2026-04-16T15:00:00.000Z",
  "duration": "45m 12s",
  "success_rate": 0.85,
  "subtasks_total": 40,
  "subtasks_succeeded": 34,
  "subtasks_failed": 6,
  "tool_performance": {
    "web_search": {"attempts": 15, "success": 14},
    "text_generation": {"attempts": 10, "success": 10}
  },
  "improvements": ["better error handling", "parallelize resume tailoring"]
}
```

### 🎯 Intelligent Tool Selection

Automatically chooses the best tool for each subtask:
- **Text Processing** → summarize-pro, text-generation
- **Web Interaction** → agent-browser, web_search  
- **File Operations** → file_edit, file_read
- **Code Generation** → agent-browser, execute
- **Calendar/Email** → gog (Google Workspace)
- **GitHub Operations** → github (gh CLI)

## Use Cases

### 1. Content Creation Pipeline

```bash
task-orch start "Create a technical blog post about AI agents with code examples and publish it to GitHub Pages"
```

**Orchestrator breakdown:**
1. Research AI agent topics (web_search)
2. Find example code (web_search, GitHub)
3. Generate outline (text_generation)
4. Write content (text_generation)
5. Create code examples (agent-browser, execute)
6. Test examples (execute)
7. Write tests (code_generation)
8. Format as Markdown (file_edit)
9. Create diagrams (image_generation)
10. Push to GitHub (github)

### 2. Job Application Campaign

```bash
task-orch start "Apply to 5 software engineering roles at AI companies"
```

**Orchestrator breakdown:**
1. Find open positions (web_search)
2. Extract job descriptions (summarize)
3. Match to skills (knowledge)
4. Generate tailored resume (file_edit)
5. Write cover letters (text_generation)
6. Fill applications (agent-browser)
7. Track in spreadsheet (file_write)
8. Setup calendar reminders (gog)

### 3. System Maintenance

```bash
task-orch start "Update all OpenClaw tools and skills, verify everything works"
```

**Orchestrator breakdown:**
1. Check current versions (exec)
2. Update packages (npm, pip)
3. Verify installations (exec)
4. Run tests (exec)
5. Generate report (file_write)
6. Cleanup temp files (exec)

### 4. Research Task

```bash
task-orch start "Research the best LLMs for AI agents in 2026 with benchmarks"
```

**Orchestrator breakdown:**
1. Search recent benchmarks (web_search)
2. Compare models (summarize)
3. Find use cases (web_search)
4. Create comparison matrix (file_write)
5. Generate summary (text_generation)

## Architecture

```
┌─────────────────────────────────────────────┐
│  Task Input                                 │
│  "Complex multi-step task"                  │
└─────────────┬───────────────────────────────┘
              │
┌─────────────▼───────────────────────────────┐
│  Task Analyzer                               │
│  - Complexity detection                      │
│  - Pattern recognition                       │
│  - Decomposition via LLM                     │
└─────────────┬───────────────────────────────┘
              │
┌─────────────▼───────────────────────────────┐
│  Task Graph                                  │
│  - Subtasks with IDs                         │
│  - Dependencies map                          │
│  - Tool recommendations                      │
│  - Parallel groups                           │
└─────────────┬───────────────────────────────┘
              │
       ┌──────┴───────┐
       ▼              ▼
┌──────────┐   ┌────────────┐
│ Sequential│   │  Parallel  │
│ Pipeline │   │  Groups    │
└─────┬────┘   └─────┬──────┘
      │              │
      └──────┬───────┘
             │
┌────────────▼─────────────┐
│  Executor Engine          │
│  - Run subtasks           │
│  - Check dependencies     │
│  - Retry on failure       │
│  - Update checkpoints     │
└────────────┬─────────────┘
             │
      ┌──────┴──────┐
      ▼             ▼
┌────────┐   ┌──────────┐
│ Success│   │  Failure │
└───┬────┘   └────┬─────┘
    │             │
    └──────┬──────┘
           │
┌──────────▼────────────┐
│  Learning Engine       │
│  - Analyze outcomes    │
│  - Update heuristics   │
│  - Store learnings     │
└──────────────────────┘
```

## CLI Reference

### Commands

#### `task-orch start "<task>" [options]`
Start a new orchestration

**Options:**
- `--complexity=low|medium|high` - Override auto-detection
- `--checkpoint-dir=<path>` - Where to save checkpoints
- `--learning=on|off` - Enable/disable learning capture

#### `task-orch analyze "<task>" [options]`
Analyze without executing (dry run)

**Example:**
```bash
task-orch analyze "Build a job application campaign" --dry-run
```

#### `task-orch resume <task-id>`
Resume from a checkpoint

**Example:**
```bash
task-orch resume task-1709284935000
```

#### `task-orch status <task-id>`
Check status of a task

**Example:**
```bash
task-orch status task-1709284935000
```

#### `task-orch learnings [--recent=N]`
View recent learnings

**Example:**
```bash
task-orch learnings --recent=10
```

#### `task-orch init`
Initialize directories and config

**Example:**
```bash
task-orch init
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `CHECKPOINT_DIR` | Checkpoint storage path | `~/.task-checkpoints` |
| `LEARNING_DIR` | Learning storage path | `~/.openclaw/.learnings` |
| `MAX_RETRIES` | Max retry attempts | 3 |
| `MAX_PARALLEL` | Max parallel tasks | 3 |

## Configuration

Full config at `~/.config/task-orchestrator/config.json`:

```json
{
  "defaultRetryCount": 3,
  "checkpointDir": "/home/morpheus/.task-checkpoints",
  "learningEnabled": true,
  "learningDir": "/home/morpheus/.openclaw/workspace/.learnings",
  "maxParallelTasks": 3,
  "toolPreferences": {
    "textProcessing": ["summarize-pro", "text-generation"],
    "webInteraction": ["agent-browser", "web_search"],
    "fileOps": ["self-improving-agent"],
    "webSearch": ["web_search", "agent-browser"],
    "execution": ["exec", "agent-browser"]
  },
  "failureThresholds": {
    "maxFailuresBeforeAbort": 3,
    "maxDuration": "2h"
  },
  "notifications": {
    "email": "zendraillustratus@gmail.com",
    "onFailure": true,
    "onCompletion": true
  }
}
```

## Development

### Running from Source

```bash
# Clone the repository
git clone https://github.com/AndresVillaShark/ideal-agent.git
cd ideal-agent

# Install dependencies
npm install

# Link for local development
npm link

# Test
node skills/task-orchestrator/task-orch start "Test task"
```

### Building

```bash
# Install as global package
npm install -g

# Or link for development
npm link
```

### Publishing to ClawHub

```bash
# Navigate to skill directory
cd skills/task-orchestrator

# Validate first
clawhub validate

# Publish
clawhub publish

# Verify
clawhub search task-orchestrator
```

## Troubleshooting

### Skill Not Loading

```bash
# Check if loaded
openclaw skills list --verbose

# Check prerequisites
task-orch --version

# Verify file permissions
ls -la ~/.openclaw/workspace/skills/task-orchestrator/
chmod +x ~/.openclaw/workspace/skills/task-orchestrator/task-orch
```

### Checkpoints Missing

```bash
# Find checkpoints
ls -la ~/.task-checkpoints/

# Recover from last checkpoint
task-orch resume <task-id>
```

### Learning Not Working

```bash
# Verify learning directory
ls -la ~/.openclaw/workspace/.learnings/

# Check write permissions
writables=$(find ~/.openclaw/workspace/.learnings/ -type d -exec test -w {} \; -print)
echo $writables
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Security

### Safety Features

- ✅ Never execute without explicit decomposition
- ✅ Checkpoint before irreversible actions
- ✅ Ask on ambiguity
- ✅ Max retry limits (prevents infinite loops)
- ✅ Timeout enforcement (prevents hung tasks)
- ✅ No external data leakage
- ✅ Local execution by default
- ✅ Credential isolation via environment variables

### Best Practices

- Keep checkpoints secure (may contain task data)
- Review learnings to prevent sensitive info storage
- Use environment variables for credentials
- Never commit config files with secrets
- Regular cleanup of old checkpoints

## License

**MIT-0** - No attribution required. Free to use, modify, and distribute.

```
MIT-0 License
Copyright (c) 2026 Mario Villalpando

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, and/or sell copies of the Software.
```

## About

**Created:** 2026-04-16  
**Author:** Mario Villalpando  
**Project:** Ideal Agent  
**Repository:** https://github.com/AndresVillaShark/ideal-agent  
**Skill:** task-orchestrator  
**License:** MIT-0

---

**Transform complex tasks into structured workflows. Learn from every execution. Execute better every time.**
