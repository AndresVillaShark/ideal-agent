# Example: Content Creation Pipeline

**Task:** "Create a technical blog post about OpenClaw skills with code examples and publish it to GitHub Pages"

## Execution Plan

```bash
task-orch start "Create a technical blog post about OpenClaw skills with code examples and publish it to GitHub Pages" \
  --complexity=high \
  --checkpoint-dir=/home/morpheus/.task-checkpoints/blog-post
```

## Expected Decomposition

### Phase 1: Research (Parallel)
1. Search for OpenClaw skill examples (web_search)
2. Find popular skills on ClawHub (clawhub list)
3. Read existing tutorials (agent-browser)

### Phase 2: Content Creation (Sequential)
4. Generate outline (text_generation)
5. Write introduction (text_generation)
6. Write skill examples section (text_generation)
7. Create code samples (agent-browser + exec)

### Phase 3: Verification (Sequential)
8. Test code examples (exec)
9. Verify accuracy (web_search)
10. Check formatting (file_read)

### Phase 4: Publication (Parallel)
11. Format as Markdown (file_edit)
12. Create cover image (image_generation)
13. Push to GitHub (github)
14. Setup GitHub Pages (github)

## Estimated Complexity
- Total subtasks: ~15
- Parallel groups: 3
- Estimated duration: 45-60 minutes

---

# Example: Job Application Campaign

**Task:** "Apply to 5 software engineering roles at AI companies"

```bash
task-orch start "Apply to 5 software engineering roles at AI companies" \
  --checkpoint-dir=/home/morpheus/.task-checkpoints/job-campaign
```

## Expected Decomposition

### Phase 1: Discovery (Parallel)
1. Search AI company jobs (web_search)
2. Extract job postings (agent-browser)
3. Filter by requirements (knowledge)

### Phase 2: Preparation (Parallel)
4. Tailor resume per company (file_edit x4)
5. Write cover letters (text_generation x4)
6. Prepare portfolio links (file_read)

### Phase 3: Application (Parallel)
7. Fill application forms (agent-browser x4)
8. Upload documents (agent-browser)
9. Submit all applications (agent-browser)

### Phase 4: Tracking (Sequential)
10. Log all applications (file_write)
11. Setup calendar reminders (gog)
12. Create follow-up schedule (text_generation)

## Estimated Complexity
- Total subtasks: ~25
- Parallel groups: 4
- Estimated duration: 2-3 hours

---

# Example: System Maintenance

**Task:** "Update all OpenClaw tools and skills, verify everything works"

```bash
task-orch start "Update all OpenClaw tools and skills, verify everything works" \
  --checkpoint-dir=/home/morpheus/.task-checkpoints/system-update
```

## Expected Decomposition

### Phase 1: Backup (Sequential)
1. Backup current skills (file_copy)
2. Backup configs (file_copy)
3. Log current versions (exec)

### Phase 2: Updates (Parallel)
4. Update npm packages (npm update)
5. Update clawhub skills (clawhub sync)
6. Check for new skill versions (clawhub search)

### Phase 3: Verification (Sequential)
7. Verify tool installations (exec)
8. Test key skills (skill tests)
9. Verify environment (exec)

### Phase 4: Cleanup (Sequential)
10. Remove old dependencies (npm prune)
11. Generate report (file_write)
12. Commit changes (github)

## Estimated Complexity
- Total subtasks: ~12
- Parallel groups: 1
- Estimated duration: 30-45 minutes
