---
name: task-orchestrator
description: Advanced task decomposition, workflow orchestration, and intelligent execution with failure recovery and learning
version: 1.0.0
metadata: {"openclaw":{"emoji":"\ud83d\ude80","requires":{"bins":["node","jq"],"os":["linux","darwin"]},"primaryEnv":"ORCHESTRATOR_MODE","install":[{"kind":"node","package":"task-orchestrator","bins":["task-orch"]}],"skillKey":"task-orchestrator"}}
---

# Task Orchestrator - Intelligent Workflow Engine

Transform complex, ambiguous tasks into structured, executable workflows with intelligent decomposition, tool selection, and self-learning capabilities.

## What It Does

This skill breaks down complex tasks into atomic subtasks, orchestrates their execution with proper dependency management, learns from outcomes, and improves future performance automatically.

### Key Capabilities
- **Adaptive Decomposition** - Analyzes task complexity and breaks it into optimal subtasks
- **Intelligent Tool Selection** - Chooses best tools for each subtask based on context
- **Dependency Management** - Tracks task dependencies and enables parallel execution where safe
- **Failure Recovery** - Automatically recovers from failures with fallback strategies
- **Progress Tracking** - Real-time status updates and checkpoint management
- **Learning Loop** - Captures successes/failures to improve future orchestration

## When to Use

✅ **USE this skill when:**
- Task has multiple unclear steps
- You need to track progress across complex workflows
- Task requires multiple different tools
- Failure in one step should not derail entire task
- You want to learn and improve similar future tasks

❌ **DON'T use this skill when:**
- Task is simple and linear (use direct execution)
- You need immediate one-step actions
- Task is read-only with no complex dependencies
- You're in a hurry and don't need documentation

## Inputs Needed

- **Task description** - Clear statement of what you want to accomplish
- **Task complexity** (optional) - low/medium/high or auto-detect
- **Output format** (optional) - where to save results
- **Learning mode** (optional) - on/off (default: on)
- **Checkpoint directory** (optional) - where to save progress (default: workspace/.task-c checkpoints)

## Workflow

### Phase 1: Task Analysis & Decomposition

1. **Analyze task complexity**
```bash
node --input-type=module -e "import {analyzeTask} from 'task-orchestrator'; analyzeTask('your task here')"
```

2. **Generate task graph** - Outputs JSON with:
   - Subtasks with IDs
   - Dependencies between subtasks
   - Estimated complexity per subtask
   - Recommended tools per subtask
   - Parallel execution opportunities

3. **Review and approve** - Review proposed breakdown, adjust if needed

### Phase 2: Execution Planning

4. **Create execution plan**
   - Order tasks respecting dependencies
   - Identify parallel execution groups
   - Set retry policies per task
   - Define success criteria for each

5. **Initialize checkpoints**
```bash
mkdir -p ~/ideal-agent/checkpoints/<task-id>
```

6. **Save plan** - Store execution plan for recovery

### Phase 3: Orchestrated Execution

7. **Begin execution** - Run subtasks in optimal order:
   - Start parallel groups concurrently
   - Wait for dependencies
   - Track progress in checkpoints
   - Log decisions and outcomes

8. **Handle failures** - For each failure:
   - Check if retryable (max 3 attempts)
   - If retry fails, try fallback strategy
   - If still fails, mark as failed and note reason
   - Continue with non-dependent tasks

9. **Update checkpoints** - After each step:
```bash
echo '{"task":"name","status":"completed","elapsed":"2m30s","output":"..."}' | jq . >> checkpoint.json
```

### Phase 4: Completion & Learning

10. **Aggregate results** - Combine all outputs

11. **Analyze outcomes:**
    - Success rate across subtasks
    - Time spent per task
    - Failure patterns
    - Tool effectiveness

12. **Store learning** - Save to ~/ideal-agent/learnings/:
```bash
cat > ~/ideal-agent/learnings/YYYYMMDD-<task-id>.json << 'EOF'
{
  "task": "description",
  "date": "timestamp",
  "duration": "total time",
  "success_rate": 0.85,
  "subtasks_total": 10,
  "subtasks_succeeded": 8,
  "subtasks_failed": 2,
  "tool_performance": {"tool1": {"attempts": 5, "success": 4}},
  "improvements": ["better error handling", "parallelize independent tasks"]
}
EOF
```

13. **Refine heuristics** - Update task-orchestrator config based on learnings

## Output Format

```markdown
## Task: [Task Name]

### Decomposition
- 10 subtasks identified across 4 phases
- 3 parallel execution groups detected
- Estimated complexity: HIGH

### Execution Summary
- Total duration: 45m 12s
- Success rate: 80% (8/10 subtasks)
- Failures: 2 (non-blocking)

### Results
[Combined outputs from all subtasks]

### Learnings Captured
- Learning ID: LRN-20260416-0XX
- Key insights stored in ideal-agent/learnings/

### Next Steps
[Actionable follow-up items]
```

## Guardrails

- **Never skip dependencies** - Always complete prerequisite tasks first
- **Max retry limit** - 3 attempts per subtask (configurable)
- **Checkpoint before critical** - Save state before irreversible actions
- **Ask on ambiguity** - If task decomposition unclear, ask for clarification
- **Don't hallucinate outputs** - Mark missing data explicitly
- **Recovery first** - If total failure, recover from last checkpoint

## Failure Handling

### Subtask Fails
1. Attempt retry (up to 3 times with backoff)
2. Check if dependent tasks can run anyway
3. Try fallback approach if available
4. If still failing:
   - Mark as failed with reason
   - Skip dependent blocking tasks
   - Continue independent tasks
   - Report at the end

### Total Orchestration Fails
1. Restore from last checkpoint
2. Re-analyze what caused failure
3. Adjust plan if needed
4. Resume execution
5. If still fails: report for manual intervention

## Tool Commands

### Start New Task
```bash
task-orch start "complex task description" --complexity=high --checkpoint-dir=/home/morpheus/.task-checkpoints
```

### Resume from Checkpoint
```bash
task-orch resume <task-id>
```

### Add Step to Plan
```bash
task-orch add-step <task-id> --depends-on=<step-id> --tool=<tool-name>
```

### Check Status
```bash
task-orch status <task-id>
```

### List Learnings
```bash
task-orch learnings --recent=5
```

### Analyze Task (no execution)
```bash
task-orch analyze "task description" --dry-run
```

## Examples

### Example 1: Content Creation Pipeline

**User:** "Create a blog post about OpenClaw skills with code examples and publish it"

**Orchestrator Breakdown:**
1. Research OpenClaw skills (tool: web_search, knowledge)
2. Select 3 best examples (tool: summarization)
3. Write outline (tool: text_generation)
4. Write content (tool: text_generation)
5. Generate code snippets (tool: agent-browser, code_gen)
6. Test examples (tool: exec)
7. Format as Markdown (tool: file_edit)
8. Upload to blog CMS (tool: gog, web)
9. Create social snippets (tool: summarize)
10. Publish & track (tool: gh-pages)

**Parallel Groups:** Steps 4-5 can run together, 7-9 can run together

### Example 2: Job Application Campaign

**User:** "Apply to software engineering roles at 5 AI companies"

**Orchestrator Breakdown:**
1. Find open positions (tool: web_search)
2. Extract job requirements (tool: summarization)
3. Match skills to jobs (tool: knowledge)
4. Tailor resume per company (tool: file_edit)
5. Write cover letters (tool: text_generation)
6. Fill applications (tool: agent-browser)
7. Track submissions (tool: file_write)
8. Follow up reminders (tool: calendar)

## Configuration

Create `~/.config/task-orchestrator/config.json`:

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
    "fileOps": ["self-improving-agent"]
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

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│  Task Input                                                │
└──────────────┬────────────────────────────────────────────┘
               │
┌──────────────▼──────────────┐
│  Task Analyzer               │
│  - Complexity detection      │
│  - Pattern recognition       │
│  - Decomposition engine      │
└──────────────┬──────────────┘
               │
┌──────────────▼──────────────┐
│  Task Graph                    │
│  - Subtasks + dependencies    │
│  - Tool recommendations       │
│  - Parallel analysis          │
└──────────────┬──────────────┘
               │
       ┌───────┴───────┐
       ▼               ▼
┌──────────────┐ ┌──────────────┐
│  Sequential  │ │   Parallel   │
│  Pipeline    │ │   Groups     │
└──────┬───────┘ └────┬─────────┘
       │              │
       └──────┬───────┘
              │
┌─────────────▼─────────────┐
│  Executor                   │
│  - Run subtasks            │
│  - Check dependencies      │
│  - Retry on failure        │
│  - Update checkpoints      │
└─────────────┬─────────────┘
              │
       ┌──────┴──────┐
       ▼             ▼
┌──────────┐   ┌──────────┐
│  Success │   │  Failure │
└────┬─────┘   └────┬─────┘
     │              │
     └──────┬───────┘
            │
┌───────────▼───────────┐
│ Learning Engine         │
│ - Analyze outcomes     │
│ - Update heuristics    │
│ - Store learnings      │
└───────────────────────┘
```

## Installation

```bash
# Install the orchestrator package
npm install -g task-orchestrator

# Verify
task-orch --version

# Create directories
mkdir -p ~/.task-checkpoints ~/.ideal-agent/learnings

# Initialize config
task-orch init
```

## Troubleshooting

### Skill not loading
```bash
openclaw skills check task-orchestrator
openclaw skills list --verbose
```

### Checkpoints missing
```bash
ls -la $CHECKPOINT_DIR/
task-orch recovery --scan
```

### Stuck in loop
```bash
task-orch status <task-id>
task-orch kill <task-id>
task-orch resume <task-id>  # fresh start
```

### Learning not working
```bash
ls ~/.ideal-agent/learnings/
# Check if write permissions
wc -l ~/.ideal-agent/learnings/*.json
```

## Status

**Version:** 1.0.0  
**Author:** Mario Villalpando (ideal-agent project)  
**License:** MIT-0 (Free use, modification, distribution)  
**Created:** 2026-04-16  
**Platform:** Linux, Darwin (macOS)  
**Dependencies:** Node.js, jq, task-orch CLI
