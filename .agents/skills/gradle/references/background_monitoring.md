# Background Monitoring Patterns

This guide provides advanced patterns for monitoring and managing long-running background builds using `gradle`, `query_build`, and `wait_build`.

## Common Monitoring Patterns

### 1. Waiting for a Log Message

The most common pattern for background builds (like dev servers) is to wait for a specific log message that indicates the build is ready using `wait_build`.

```json
{
  "buildId": "BUILD_ID",
  "timeout": 60,
  "waitFor": "Started Application"
}
```

- **`timeout`**: Max seconds to wait for the message.
- **`waitFor`**: A regex pattern to match in the build logs.

### 2. Waiting for Task Completion

If you want to wait for a specific task to finish in a background build.

```json
{
  "buildId": "BUILD_ID",
  "timeout": 120,
  "waitForTask": ":app:assemble"
}
```

- **`waitForTask`**: The path of the task to wait for.

### 3. Monitoring Progress Without Waiting

To check the current status of a background build without waiting for a specific event using `query_build`.

```json
{
  "buildId": "BUILD_ID"
}
```

- This returns a summary of the current build state (e.g., `BUILD IN PROGRESS`, `SUCCESS`, `FAILURE`), failures, and problems.
- **Example**: `query_build(buildId="ID")`

### 4. Inspecting Active Builds (Build Dashboard)

To see all currently running background builds and recent history.

```json
{} 
```

- Call `query_build()` with **no arguments** to see the dashboard.
- This is the easiest way to find `BuildId`s for active or recently finished builds.

## Advanced Management

### 1. Stopping a Background Build

Always stop background builds when they are no longer needed to free up resources.

```json
{
  "stopBuildId": "BUILD_ID"
}
```

### 2. Continuous Builds

For continuous builds (e.g., `gradle build --continuous`), use the background pattern and wait for the "Waiting for changes" message.

```json
// Start the build
{
  "commandLine": ["build", "--continuous"],
  "background": true
}

// Wait for the first build to finish
{
  "buildId": "BUILD_ID",
  "timeout": 120,
  "waitFor": "Waiting for changes"
}
```

### 3. Handling Timeouts

If a build takes longer than the `timeout` time, `wait_build` will return the current status. You can then call it again with a new `timeout` time if needed.

## Troubleshooting Background Builds

- **Build Fails Immediately**: If a background build fails quickly, check the `failures` and `console` output using `query_build`.
- **Log Message Not Found**: Ensure the `waitFor` regex is correct and that the message is actually being printed to the console.
- **Resource Exhaustion**: If you have too many background builds running, stop the ones you don't need using `stopBuildId`.

## Functional Identity with Foreground Execution

Monitoring a background build using `query_build` or `wait_build` provides exactly the same rich diagnostic data as a foreground build. The primary difference is control flow: background execution allows you to yield control and perform
other tasks,
whereas foreground execution blocks until completion. Both methods utilize progressive disclosure to ensure session history remains clean and focused.
