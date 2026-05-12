---
name: gcp-dev
description: Ground GCP answers and debugging with official documentation and cloud context. Use when working on Google Cloud Platform tasks, debugging GCP services, or answering GCP architecture questions. Proactively searches GCP docs and logs to ensure answers are based on current realities, not outdated training data.
---

# Google Cloud Platform Development

When working with GCP, avoid guessing based on outdated training data. Always seek ground truth.

## Core Directives

1.  **Search First (Knowledge MCP -> Web Search):** Whenever asked a question about a GCP service, API, SDK, or architecture, attempt to use the `google-knowledge` MCP server first to query Google Knowledge Graph. If the MCP server is unavailable or doesn't yield high-quality/relevant results, fall back to performing a web search targeted at Google Cloud documentation (`site:cloud.google.com` or `site:cloud.google.com/docs`) before answering.
2.  **Verify with `gcloud`:** If the user is authenticated and has a project set, use the `gcloud` CLI (via `bash`) to verify current state, resource configuration, or available versions, rather than assuming. Use commands like `gcloud info`, `gcloud config get-value project`, or list specific resources (e.g., `gcloud run services list`).
3.  **Check Logs:** When debugging a GCP issue, proactively search Cloud Logging using `gcloud logging read`. Ask the user for the relevant time window or resource type if it's not clear.
4.  **Reference Specific Docs:** Always provide links to the specific, current GCP documentation pages you consulted.
5.  **Prefer Current SDKs:** Ensure code examples use the most current, supported versions of Google Cloud Client Libraries (e.g., `@google-cloud/*` for Node.js, `google-cloud-*` for Python), not deprecated legacy libraries.

## Workflow: Answering Questions

1. Identify the specific GCP service (e.g., Cloud Run, Pub/Sub, Spanner).
2. Attempt to use the `google-knowledge` MCP server to look up entities or concepts related to the service.
3. If the knowledge graph doesn't provide enough technical depth, use `web_search` with queries like:
   * `"Google Cloud <Service Name> documentation"`
   * `"site:cloud.google.com/docs <specific topic or error>"`
4. Read the relevant documentation.
5. Synthesize the answer, citing the source URLs or Knowledge Graph entities.

## Workflow: Debugging

1. Identify the failing service and project.
2. If the user hasn't provided logs, use `bash` and `gcloud logging read` to fetch recent errors for that service.
   * *Example:* `gcloud logging read "resource.type=cloud_run_revision AND severity>=ERROR" --limit=10 --format=json`
3. Analyze the logs. If the error message is generic, search the exact error text using `web_search`.
4. Propose a fix based on the documented solution or configuration requirements.
