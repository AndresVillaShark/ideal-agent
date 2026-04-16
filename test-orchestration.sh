#!/bin/bash
# Real orchestration test

TASK="System Health Check & Skill Update"
TASK_ID="task-$(date +%s)"
CHECKPOINT_DIR="/home/morpheus/.task-checkpoints/$TASK_ID"

mkdir -p "$CHECKPOINT_DIR"

echo "🚀 Starting orchestration: $TASK"
echo "Task ID: $TASK_ID"
echo ""

# Phase 1: Discovery
echo "📋 Phase 1: Skill Discovery"
echo "{\"step\":\"discovery\",\"status\":\"started\",\"timestamp\":\"$(date -Iseconds)\"}" > "$CHECKPOINT_DIR/step-01.json"

for skill_dir in /home/morpheus/.openclaw/workspace/skills/*/; do
  skill_name=$(basename "$skill_dir")
  echo "🔍 Checking: $skill_name"
  if [ -f "$skill_dir/SKILL.md" ]; then
    echo "  ✅ SKILL.md found"
  else
    echo "  ❌ MISSING SKILL.md"
  fi
  if [ -x "$skill_dir/task-orch" ] || [ -x "$skill_dir/$skill_name"; then
    echo "  ✅ Executable found"
  fi
done

echo "{\"step\":\"discovery\",\"status\":\"completed\",\"timestamp\":\"$(date -Iseconds)\"}" >> "$CHECKPOINT_DIR/step-01-end.json"

# Phase 2: Update Check  
echo ""
echo "📦 Phase 2: Check for Skill Updates"
echo "{\"step\":\"update-check\",\"status\":\"started\",\"timestamp\":\"$(date -Iseconds)\"}" > "$CHECKPOINT_DIR/step-02.json"

if hash clawhub 2>/dev/null; then
  echo "✅ clawhub CLI available"
  clawhub search "agent-" --limit 5 2>&1 | head -10
else
  echo "⚠️  clawhub not installed"
fi

echo "{\"step\":\"update-check\",\"status\":\"completed\",\"timestamp\":\"$(date -Iseconds)\"}" >> "$CHECKPOINT_DIR/step-02-end.json"

# Phase 3: Health Check
echo ""
echo "🏥 Phase 3: System Health"
echo "{\"step\":\"health-check\",\"status\":\"started\",\"timestamp\":\"$(date -Iseconds)\"}" > "$CHECKPOINT_DIR/step-03.json"

echo "Node version: $(node --version 2>&1)"
echo "npm version: $(npm --version 2>&1)"
echo "OpenClaw version: $(openclaw --version 2>&1)"
echo "Skills in PATH: $(which agent-browser gog 2>&1)"

echo "{\"step\":\"health-check\",\"status\":\"completed\",\"timestamp\":\"$(date -Iseconds)\"}" >> "$CHECKPOINT_DIR/step-03-end.json"

# Summary
echo ""
echo "═══════ ORCHESTRATION SUMMARY ═══════"
echo "Task: $TASK"
echo "Duration: ~$(($(date +%s) - $(date +%s -d @$(find "$CHECKPOINT_DIR" -name "*.json" -type f | head -1 | xargs stat -c %Y) 2>/dev/null || echo $(date +%s))))s"
echo ""
echo "Checkpoint files created:"
ls -1 "$CHECKPOINT_DIR"/
echo ""
echo "✅ Orchestration complete! Checkpoints saved to:"
echo "   $CHECKPOINT_DIR"

cat > "$CHECKPOINT_DIR/summary.json" << SUMMARY
{
  "task": "$TASK",
  "task_id": "$TASK_ID",
  "status": "completed",
  "checkpoint_count": $(ls -1 "$CHECKPOINT_DIR"/*.json 2>/dev/null | wc -l),
  "duration_estimate": "2 minutes"
}
SUMMARY
