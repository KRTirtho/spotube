# query_build Diagnostics Reference

Comprehensive guide to inspecting build results, diagnosing failures, and monitoring progress with `query_build` and `wait_build`.

## Quick Reference

| Goal                     | Tool Call                                                                      |
|--------------------------|--------------------------------------------------------------------------------|
| See recent/active builds | `query_build()`                                                                |
| Build-level summary      | `query_build(buildId="ID")`                                                    |
| Specific failure         | `query_build(buildId="ID", kind="FAILURES", query="F0")`                       |
| Specific problem         | `query_build(buildId="ID", kind="PROBLEMS", query="P1")`                       |
| Task output              | `query_build(buildId="ID", kind="TASKS", query=":app:compileJava")`            |
| List failed tests        | `query_build(buildId="ID", kind="TESTS", outcome="FAILED")`                    |
| Per-test stack trace     | `query_build(buildId="ID", kind="TESTS", query="com.example.MyTest.myMethod")` |
| Console logs (regex)     | `query_build(buildId="ID", kind="CONSOLE", query="ERROR")`                     |
| Full export to file      | `query_build(buildId="ID", kind="CONSOLE", outputFile="path/to/logs.txt")`     |
| Wait for log pattern     | `wait_build(buildId="ID", timeout=60, waitFor="Started")`                      |
| Wait for task            | `wait_build(buildId="ID", timeout=120, waitForTask=":app:assemble")`           |
| Wait for finish          | `wait_build(buildId="ID", timeout=600)`                                        |

---

## 1. Build Dashboard (`query_build()`)

Call `query_build()` with no arguments to see the **Build Dashboard** — a list of active background builds and recently completed builds with `BuildId`, status, and failure counts. Use this to discover valid `BuildId`s and ensure no
orphaned background builds are consuming resources.

```json
{}
```

---

## 2. Build Summary (`query_build(buildId="ID")`)

Provide a `buildId` to get a structured summary of that specific build, including:

- Overall build status (SUCCESS, FAILED, etc.)
- Failure IDs and descriptions
- Problem IDs and descriptions
- Test result counts (passed, failed, skipped, etc.)

The summary includes a guide on how to inspect specific details using the appropriate `kind`.

```json
{
  "buildId": "BUILD_ID"
}
```

---

## 3. Failure Inspection (`kind="FAILURES"`)

Inspect a specific build failure to see the full error message and stack trace. Find failure IDs (`F0`, `F1`, etc.) in the build summary. If you provide a unique prefix instead of the exact ID, the tool auto-resolves it.

```json
{
  "buildId": "BUILD_ID",
  "kind": "FAILURES",
  "query": "F0"
}
```

---

## 4. Problem Inspection (`kind="PROBLEMS"`)

Inspect a specific compilation or configuration problem. Find problem IDs (`P0`, `P1`, etc.) in the build summary. Provides file locations, error messages, and suggestions where available.

```json
{
  "buildId": "BUILD_ID",
  "kind": "PROBLEMS",
  "query": "P1"
}
```

---

## 5. Task Output Inspection (`kind="TASKS"`)

If the failure is task-related, check the isolated output of a specific task. Supports prefix matching on the task path.

```json
{
  "buildId": "BUILD_ID",
  "kind": "TASKS",
  "query": ":app:compileJava"
}
```

---

## 6. Test Inspection (`kind="TESTS"`)

### Listing Failed Tests (Summary Mode)

Quickly see which tests failed without being overwhelmed by logs:

```json
{
  "buildId": "BUILD_ID",
  "kind": "TESTS",
  "outcome": "FAILED"
}
```

### Getting Detailed Test Output (Details Mode)

**CRITICAL**: Always use `kind="TESTS"` and `query` to see the complete stdout, stderr, and stack trace for a specific test. Supports unique prefix matching on the test name.

```json
{
  "buildId": "BUILD_ID",
  "kind": "TESTS",
  "query": "com.example.MyTest.testMethod"
}
```

### Individual Test Case vs. Task Output

**DO NOT** use `taskPath` or `captureTaskOutput` for investigating specific test failures:

- **Task output** is the aggregated log of the entire test process. It is often truncated, interleaved, and lacks the full stack traces and per-test isolation needed for debugging.
- **Individual test output** (retrieved via `query`) is authoritative, includes full stdout/stderr for just that test case, and provides the complete stack trace for any failure.

### Filtering by Name

Use `query` with summary mode to see all executions of a test across different projects or iterations:

```json
{
  "buildId": "BUILD_ID",
  "kind": "TESTS",
  "query": "MyTest"
}
```

### Monitoring Test Progress

While a build is running, progress notifications provide real-time counts of passed, failed, and skipped tests. Call `query_build(buildId="ID")` repeatedly to see updated test counts: `(5 passed, 1 failed)`.

### Pagination for Large Test Suites

```json
{
  "buildId": "BUILD_ID",
  "kind": "TESTS",
  "pagination": {
    "limit": 50,
    "offset": 0
  },
  "query": "com.example.service"
}
```

---

## 7. Console Log Inspection (`kind="CONSOLE"`)

If structured reports are insufficient, examine the raw console output. Use `query` as a regex filter.

### Head (first N lines)

```json
{
  "buildId": "BUILD_ID",
  "kind": "CONSOLE",
  "pagination": {
    "limit": 100,
    "offset": 0
  }
}
```

### Tail (last N lines)

```json
{
  "buildId": "BUILD_ID",
  "kind": "CONSOLE",
  "pagination": {
    "limit": 100
  }
}
```

### Filtered by Regex

```json
{
  "buildId": "BUILD_ID",
  "kind": "CONSOLE",
  "query": "ERROR|FAILURE"
}
```

---

## 8. Progress Monitoring (`wait_build`)

Use `wait_build` with `timeout`, `waitFor`, or `waitForTask` to block until a condition is met in a background build.

### Waiting for a Log Message

The most common pattern for background builds (dev servers) is waiting for a specific readiness message:

```json
{
  "buildId": "BUILD_ID",
  "timeout": 60,
  "waitFor": "Started Application"
}
```

### Waiting for Task Completion

```json
{
  "buildId": "BUILD_ID",
  "timeout": 120,
  "waitForTask": ":app:assemble"
}
```

### Waiting for Build Completion

If `timeout` is set without a wait condition, the tool waits for the build to finish:

```json
{
  "buildId": "BUILD_ID",
  "timeout": 600
}
```

### Handling Timeouts

If a build takes longer than the `timeout` value, `wait_build` returns the current status. You can call it again with a new timeout.

### Continuous Builds

For continuous builds, wait for the "Waiting for changes" message after the first build completes:

```json
// Start
{ "commandLine": ["build", "--continuous"], "background": true }

// Wait
{ "buildId": "BUILD_ID", "timeout": 120, "waitFor": "Waiting for changes" }
```

---

## 9. Full Export (`outputFile`)

Use `outputFile="path/to/file.txt"` to write the entire result to a file. This bypasses pagination limits and reduces token usage. Works with all `kind` values.

```json
{
  "buildId": "BUILD_ID",
  "kind": "CONSOLE",
  "outputFile": "C:/temp/build_output.txt"
}
```

---

## 10. Diagnostic Workflow

When a build fails, follow this structured approach:

### Step 1: Get the Build Summary

```json
{ "buildId": "BUILD_ID" }
```

Provides the high-level overview: failures, problems, and failed tests.

### Step 2: Inspect Failures

```json
{ "buildId": "BUILD_ID", "kind": "FAILURES", "query": "F0" }
```

### Step 3: Inspect Problems

```json
{ "buildId": "BUILD_ID", "kind": "PROBLEMS", "query": "P1" }
```

### Step 4: Check Task Outputs

```json
{ "buildId": "BUILD_ID", "kind": "TASKS", "query": ":app:compileJava" }
```

### Step 5: Check Test Failures

```json
{ "buildId": "BUILD_ID", "kind": "TESTS", "outcome": "FAILED" }
```

Then drill into each failed test:

```json
{ "buildId": "BUILD_ID", "kind": "TESTS", "query": "com.example.MyTest.shouldWork" }
```

### Step 6: Fall Back to Console Logs

```json
{ "buildId": "BUILD_ID", "kind": "CONSOLE", "pagination": { "limit": 100 } }
```

---

## 11. Build Failures vs. Test Failures

Sometimes a test run fails because the build itself failed (compilation error, configuration error, task dependency failure), not because a test failed.

1. Check the build summary: `query_build(buildId="ID")`.
2. If failures or problems are listed, inspect them directly via `kind="FAILURES"` or `kind="PROBLEMS"`.
3. If the build failed but no tests are reported, focus on build-level failures and problems.

---

## 12. Common Failure Scenarios

### Compilation Errors

- Look for problems with the specific `severity: ERROR` in the build summary.
- Check `kind="PROBLEMS"` for file location and error details.

### Dependency Resolution Issues

- Check `kind="FAILURES"` for messages like "Could not resolve all dependencies".
- Use `inspect_dependencies` to investigate the dependency graph.

### Task Execution Failures

- Check `kind="TASKS"` to see which task failed and its output.

### Build Script Errors

- Usually appear in the `kind="FAILURES"` section with a stack trace and line reference.

### Assertion Failures

- Check `kind="TESTS"` with the specific test `query` for expected vs. actual values.

### Timeouts

- Tests that time out may be marked as ERROR or FAILED. Check console output for "Timeout" messages.

### Infrastructure Issues

- If many tests fail with similar errors (`NoClassDefFoundError`, `DatabaseConnectionException`), check build-level failures and problems.

---

## 13. Stopping Background Builds

Always stop background builds when they are no longer needed:

```json
{
  "stopBuildId": "BUILD_ID"
}
```

---

## 14. Foreground vs. Background Identity

Monitoring a background build using `query_build` or `wait_build` provides exactly the same rich diagnostic data as a foreground build, including progressive disclosure. The difference is control flow: background allows non-blocking work
while the build proceeds; foreground blocks until completion.
