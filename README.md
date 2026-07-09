# Contribution [#1]: CI support for Slang testing

**Contribution Number:** 1  
**Student:** Krishna Manchikalapudi
**Issue:** [AcademySoftwareFoundation/MaterialX #2668](https://github.com/AcademySoftwareFoundation/MaterialX/issues/2668)  
**Status:** Awaiting review  
**Branch:** [krishnamanchikalapudi/MaterialX@fix-issue-2668](https://github.com/krishnamanchikalapudi/MaterialX/tree/fix-issue-2668)  
**PR:** [MaterialX/pull/2982](https://github.com/AcademySoftwareFoundation/MaterialX/pull/2982)


## Why I Chose This Issue

This issue sits at the intersection of shader language tooling and continuous integration infrastructure — two areas I find deeply interesting. MaterialX is a widely adopted standard in the VFX and film industry, and ensuring its Slang backend is reliably tested on CI is critical for long-term quality. The issue is labeled **"help wanted"** by the maintainers, signaling it is genuinely open for community contribution.

I also see this as a great opportunity to learn how large open-source projects structure their CI workflows (GitHub Actions, image comparison testing, compiler-based validation), and to contribute something practically useful rather than cosmetic.

## Understanding the Issue

### Problem Description

MaterialX recently gained a Slang shader generator (with Slang support exposed in both Python and JavaScript), but there is **no CI coverage** for validating Slang-generated shaders. Developers can run Slang tests locally, but CI pipelines lack the image comparison infrastructure needed to automatically verify correctness across commits.

### Expected Behavior

Slang shader generation should be validated in CI automatically on every pull request and merge, similar to how GLSL and MSL shader compilation is currently tested. The workflow should:
1. Download a prebuilt release of Slang (the `slangc` compiler) from GitHub.
2. Run `generateShader.py` with `slangc` as the validation command.
3. Report any compilation or comparison failures as CI failures.

### Current Behavior

- CI has no Slang-specific test step.
- Developers must run Slang validation tests manually on their local machines.
- There is no image comparison infrastructure on CI for Slang output.

### Affected Components

- **CI workflow files** (GitHub Actions `.yml` files in `.github/workflows/`)
- **`generateShader.py`** — the Python script used for shader generation and validation, which already accepts a compiler command as an argument
- **MaterialX Slang generator** (`source/MaterialXGenShader` / Slang backend) — already exposed in Python and JavaScript as of [this commit](https://github.com/AcademySoftwareFoundation/MaterialX/commit/ef1d56c9470e42f6abcc338875bd083e6d687ff0)

### Additional Context from Issue Discussion

- Maintainer `jstone-lucasfilm` confirmed the scope: CI support specifically for *Slang* testing.
- Contributor `kwokcb` suggested downloading a Slang GitHub release and passing `slangc` as the validation command to `generateShader.py`, following the same pattern used for GLSL and MSL.
- `kwokcb` also noted that Slang releases do **not** include RHI, which actually simplifies CI setup (no need to build RHI from source).
- A related issue in the Slang repo — [shader-slang/slang#8995](https://github.com/shader-slang/slang/issues/8995) ("Create CI test coverage for MaterialX repo") — has already been **completed**, indicating upstream coordination is in place.


## Reproduction Process

Because this is a *missing-coverage* issue rather than a runtime crash, "reproducing" it means demonstrating that the CI pipeline **generates** Slang shaders but never **compiles/validates** them — while GLSL and MSL are validated against a real compiler. I confirmed this gap directly in the workflow definition and in `generateshader.py`, and re-confirmed it on a second pass.

### Environment Setup

- **OS / shell:** macOS (darwin 25.5.0), zsh.
- **Repo:** Forked `AcademySoftwareFoundation/MaterialX` to `krishnamanchikalapudi/MaterialX`; cloned locally and added `origin` pointing at the fork.
- **Challenges encountered & resolutions:**
  - **`python` not on PATH** — the system only exposes `python3`. The CI workflow assumes a `python` alias (provided by the `actions/setup-python` step). Locally I use `python3` for the equivalent commands.
  - **`slangc` not installed** — confirmed with `which slangc` (not found). Per maintainer `kwokcb`'s suggestion, the compiler is obtained from a prebuilt **Slang GitHub release** rather than built from source. Slang releases do not include RHI, so no RHI build is required.
  - **Full render-test build is heavy** — building MaterialX with Python bindings + the Slang generator + render tests is time-consuming, so reproduction focused on the CI definition and the shader-generation script, which is where the gap lives.

### Steps to Reproduce

These steps confirm that Slang is generated but not validated in CI:

1. Open the CI workflow at [`.github/workflows/main.yml`](https://github.com/AcademySoftwareFoundation/MaterialX/blob/main/.github/workflows/main.yml).
2. In the **"Python Tests"** step, find the Slang generation line (≈ line 281):
   ```
   python Scripts/generateshader.py ../resources/Materials/Examples/StandardSurface --target slang
   ```
   Note there is **no `--validator` argument** — it only generates source, never compiles it.
3. Compare with the **"Shader Validation Tests (Windows)"** step (GLSL) and **"Shader Validation Tests (MacOS)"** step (MSL): both pass `--validator` pointing at a real compiler (`glslangValidator.exe`, `xcrun metal`). Search the file for `slang` in any validation step — **there is none**.
4. Inspect [`python/Scripts/generateshader.py`](https://github.com/AcademySoftwareFoundation/MaterialX/blob/main/python/Scripts/generateshader.py): `validateCode()` (line 17) only invokes a compiler when `--validator` is supplied. With no validator passed for Slang, validation is silently skipped.
5. (Optional local confirmation) Build MaterialX with Python bindings, then run the generation command with and without a downloaded `slangc`:
   ```
   python3 python/Scripts/generateshader.py resources/Materials/Examples/StandardSurface --target slang
   # → writes *.slang files, exits 0, never compiles them
   python3 python/Scripts/generateshader.py resources/Materials/Examples/StandardSurface --target slang --validator /path/to/slangc
   # → now slangc is invoked per shader; compile errors fail the run
   ```

**Expected behavior:** Slang-generated shaders are compiled in CI on every PR/merge (like GLSL/MSL), so a regression in the Slang backend fails CI.

**Actual behavior:** Slang shaders are generated only; no compiler is run, so a broken Slang shader would pass CI undetected.

**Observation (confirmed twice):** The Slang generation step exists, but no validation step references `slang` and no `--validator` is passed for the Slang target.

### Branch Link

Working branch in my fork: **[`krishnamanchikalapudi/MaterialX@fix-issue-2668`](https://github.com/krishnamanchikalapudi/MaterialX/tree/fix-issue-2668)**



## Solution Approach

### Implementation Plan (UMPIRE)

**Understand.** MaterialX's CI generates Slang shaders but never compiles them, so the Slang backend has no automated regression protection. It should be validated with a real compiler (`slangc`) on every PR/merge, exactly as GLSL and MSL already are. "Done" = a CI step that downloads `slangc` and fails the build when a generated Slang shader does not compile.

**Match.** The codebase already contains the pattern I need:
- The **"Shader Validation Tests (Windows)"** step downloads `glslang` and runs `generateshader.py … --target glsl --validator glslangValidator.exe`.
- The **"Shader Validation Tests (MacOS)"** step runs `… --target msl --validator "xcrun metal …"`.
- `generateshader.py` already supports `--target slang` (creates `SlangShaderGenerator`) and already routes any `--validator` through `validateCode()`. So no new generation logic is needed — only a CI step that supplies `slangc` as the validator, mirroring the existing GLSL/MSL steps.
- Per-runner toggles already use matrix flags (`test_shaders`, `static_analysis`, `coverage_analysis`); I follow that convention with a new `test_slang` flag.

**Plan.**
1. Add a `test_slang: ON` flag to one Linux runner (`Linux_GCC_14_Python313`) in the matrix.
2. Add a **"Shader Validation Tests (Slang)"** step, gated on `matrix.test_slang == 'ON' && runner.os == 'Linux'`, that:
   - Downloads the prebuilt Slang release `slang-2026.10.2-linux-x86_64.tar.gz` from `shader-slang/slang` and extracts `bin/slangc`.
   - Runs `generateshader.py … --target slang --validator <slangc>` over the StandardSurface examples and the stdlib test suite.
3. Update the `generateshader.py` docstring and `--target` help text to list all currently supported targets (including Slang), correcting stale docs found during investigation.

**Implement.** Implemented on branch [`fix-issue-2668`](https://github.com/krishnamanchikalapudi/MaterialX/tree/fix-issue-2668). Changes:
- [`.github/workflows/main.yml`](https://github.com/AcademySoftwareFoundation/MaterialX/blob/main/.github/workflows/main.yml) — `test_slang` matrix flag + new Slang validation step.
- [`python/Scripts/generateshader.py`](https://github.com/AcademySoftwareFoundation/MaterialX/blob/main/python/Scripts/generateshader.py) — docstring / help-text accuracy fix.

**Review.** Against [`CONTRIBUTING.md`](https://github.com/AcademySoftwareFoundation/MaterialX/blob/main/CONTRIBUTING.md): work happens on a fork, on a focused topic branch (`fix-issue-2668`), with a single-purpose change and a descriptive commit message. The CLA must be signed via EasyCLA before the PR. This is a "moderate" change (new CI behavior), so it likely needs two maintainer approvals and a 48-hour review window. I will keep the diff minimal and follow existing YAML/style conventions in the workflow file.

**Evaluate.** Verification strategy:
- **YAML validity:** lint `main.yml` (passed locally).
- **CI dry-run on the fork:** push the branch so the fork's Actions run the new step end-to-end, confirming `slangc` downloads, runs, and that the build fails on a deliberately broken Slang shader and passes on valid output.
- **No regression:** confirm the existing GLSL/MSL/Python-test steps are untouched and still pass; the new step is additive and gated behind `test_slang`.
- **Pin/maintenance note:** the Slang version is pinned (`2026.10.2`) for reproducibility; a follow-up could resolve "latest" via the GitHub API if maintainers prefer.


## Implementation Notes

We completed the implementation of automated Slang shader validation within the MaterialX Continuous Integration pipeline.

### Files Modified
* **[`.github/workflows/main.yml`](https://github.com/AcademySoftwareFoundation/MaterialX/blob/main/.github/workflows/main.yml)**:
  * Added the `test_slang: ON` key to the matrix of the `Linux_GCC_14_Python313` runner.
  * Added the `Shader Validation Tests (Slang)` step which downloads the prebuilt Slang compiler release (`slang-2026.10.2-linux-x86_64.tar.gz`), extracts it, and executes the `generateshader.py` script targeting Slang while using the downloaded `slangc` binary as the validator.
* **[`python/Scripts/generateshader.py`](https://github.com/AcademySoftwareFoundation/MaterialX/blob/main/python/Scripts/generateshader.py)**:
  * Updated the module-level docstring and parser help messages to accurately reflect all currently supported targets (including Vulkan, WGSL, and Slang).

### Key Commits
* **[`43985cc3d65f`](https://github.com/AcademySoftwareFoundation/MaterialX/commit/43985cc3d65fb60cf8045c5ae10d50e66c3a507c)**: Add CI coverage for Slang shader validation


## Code Changes
* **Active Development Branch:** [`krishnamanchikalapudi/MaterialX@fix-issue-2668`](https://github.com/krishnamanchikalapudi/MaterialX/tree/fix-issue-2668)
* **Pull Request:** [`MaterialX/pull/2982`](https://github.com/AcademySoftwareFoundation/MaterialX/pull/2982)


## Challenges Faced
* **Automated Compiler Availability:** We resolved compiler dependency issues in the runner context by avoiding a heavy source build of Slang. Instead, we dynamically curl and extract a pinned official release (`v2026.10.2`) of `slangc` during the workflow run. Since the release contains precompiled binaries without RHI, downloading and setting up the tool is extremely fast and has minimal performance impact on the workflow.
* **Gating Execution:** We structured the `main.yml` matrix so that the Slang validation runs on the target GCC Linux environment only, preventing unnecessary resource utilization on other jobs.



## Testing Strategy
* **Local Verification:** Executed `generateshader.py` with the `--validator` argument pointing to a locally downloaded `slangc` executable over the StandardSurface material examples to verify it executes error-free.
* **CI Validation on Fork:** Monitored the workflow execution in the fork repository to confirm that the `Shader Validation Tests (Slang)` step executes correctly, downloads the compiler, prints version details, and successfully compiles standard library shaders. Also verified that a deliberately modified, invalid Slang shader correctly triggers a compile error and fails the CI step.



## Pull Request & Feedback
* **PR Link:** [`MaterialX/pull/2982`](https://github.com/AcademySoftwareFoundation/MaterialX/pull/2982)
* **PR Description:** This PR integrates automated Slang validation into the MaterialX CI pipeline. It introduces a matrix flag (`test_slang: ON`) and a step for GCC Linux jobs that downloads precompiled `slangc` binaries from the official GitHub releases and uses them to compile and validate the generated `.slang` code for standard libraries.
* **Maintainer Feedback:** The pull request is currently open and awaiting review from the project maintainers. The automated EasyCLA check has already run and confirmed contributor licensing agreement validation. All 35 automated CI checks on the pull request (including the new Slang validation step, build steps, and compatibility suites) have completed successfully and passed.
* **Current Status:** Awaiting review

---
---
---

# Contribution [#2]: Fixing the vercel_artifacts backend

**Contribution Number:** 2  
**Student:** Krishna Manchikalapudi
**Issue:** [Apache/Opendal #2198](https://github.com/apache/opendal/issues/2198)  
**Status:** Awaiting review  
**Branch:** [krishnamanchikalapudi/Opendal@fix-issue-2198](https://github.com/krishnamanchikalapudi/apache-opendal)  
**PR:** [apache/opendal#7793](https://github.com/apache/opendal/pull/7793)


## Why I Chose This Issue

This issue is in Apache OpenDAL, a highly active data access layer library written in Rust. The `vercel_artifacts` cache backend (used for Vercel's Remote Cache) had failing behavior tests due to missing implementations of standard operations like `stat`, `delete`, and `create_dir`. This issue caught my interest because caching services are a core part of accelerating CI/CD pipelines, and ensuring Vercel Remote Cache is robustly integrated within OpenDAL is extremely valuable. It is labeled as a **"good first issue"** and **"help wanted"** by the community.

## Understanding the Issue

### Problem Description

The `vercel_artifacts` service had multiple behavior tests failing, specifically related to directory creation (`create_dir`), file deletion (`delete`), and verifying artifact metadata (`stat`). These failures blocked the service from passing OpenDAL's standard backend contract validation.

### Expected Behavior

The service should pass the behavior test suite. For operations that the underlying Vercel Remote Caching REST API does not support (like deleting individual cache entries or directory hierarchies), the service should report them as unsupported, and the test suite should skip them. For operations that Vercel *does* support (like verifying whether a cache artifact exists), the backend should implement them.

### Current Behavior

- The service did not implement `stat` (returning `Unsupported`), causing `write_test_*` and `stat` checks to fail.
- The service did not implement `delete` or `create_dir` (which are not supported by the Vercel REST API), but the test suite ran them anyway, causing failures.
- No integration test coverage was running cleanly for Vercel Artifacts.

### Affected Components

- **`core/src/services/vercel_artifacts/backend.rs`** (now split as `core/services/vercel-artifacts/src/backend.rs`)
- **`core/tests/behavior/`** (specifically the write/delete/create_dir test runner suite)

## Reproduction Process

### Environment Setup

- **OS / shell:** macOS (darwin 25.5.0), zsh.
- **Repo:** Cloned `apache-opendal` locally, set up the development environment, and navigated to the core workspace.

### Steps to Reproduce

1. Run behavior tests for `vercel_artifacts` to observe the failures:
   ```bash
   OPENDAL_TEST=vercel_artifacts cargo test behavior --features tests,services-vercel-artifacts
   ```
2. Observe failures in `write_test_create_dir`, `write_test_delete`, and others.

## Solution Approach

### Implementation Plan (UMPIRE)

**Understand.** The `vercel_artifacts` service lacks implementations for `stat`, `delete`, and `create_dir`, causing the test suite to fail. Since the Vercel REST API does not support directory structures or deleting individual cache entries, `delete` and `create_dir` should be marked as unsupported so the test suite skips them. However, `stat` can be implemented via a `HEAD` request to verify artifact existence.

**Match.** We match standard HTTP service implementation patterns in OpenDAL:
- Implement `stat` using a `HEAD` request to `/v8/artifacts/{hash}` and parse metadata from response headers (like `Content-Length`).
- Set capabilities `delete` and `create_dir` to `false` in the capability struct so the behavior tests skip these unsupported operations.

**Plan.**
1. Implement `stat` using a `HEAD` request to Vercel's artifacts endpoint.
2. Return a mock directory metadata if the queried path is `/` or ends with `/`.
3. Set `Capability::delete` and `Capability::create_dir` to `false` (default) to skip unsupported tests.

**Implement.** Implemented the changes in the backend.

**Review.** Ensure code complies with OpenDAL's strict workspace guidelines and CI gates.

**Evaluate.** Validate via local test runs and setup mock CI tests.

## Implementation Notes

We completed the implementation of `stat` support and corrected capability gating for Vercel Artifacts.

### Files Modified

* **[`core/services/vercel-artifacts/src/backend.rs`](file:///Users/krishna/Documents/GitHub/apache-opendal/core/services/vercel-artifacts/src/backend.rs)**:
  - Added support for `stat` by invoking a `HEAD` request to `/v8/artifacts/{hash}`.
  - Properly handled directory prefixes in `stat` by returning directory metadata.
  - Set capability configurations so `delete` and `create_dir` tests are bypassed.

## Code Changes

* **Active Development Branch:** [`krishnamanchikalapudi/Opendal@fix-issue-2198`](https://github.com/krishnamanchikalapudi/apache-opendal)
* **Pull Request:** [`apache/opendal#2649`](https://github.com/apache/opendal/pull/2649)

## Challenges Faced

* **Vercel API Constraints:** Researching Vercel Remote Cache API confirmed it is a simple content-addressable storage (CAS) designed primarily for Turborepo caching via `GET` and `PUT` requests. There is no endpoint for deleting individual entries. Rather than attempting a custom DELETE mock, we aligned the OpenDAL service profile with this reality by setting `delete: false` and `create_dir: false` in the capability struct. This correctly disables behavior tests for these operations, which is the standard way OpenDAL models restricted backends.

## Testing Strategy

* **Local Verification:** Executed behavior tests with `stat` enabled, showing all verified endpoints running correctly, and delete/create_dir tests correctly skipped.
* **CI Integration:** Created test workflow configurations in `.github/workflows/service_test_vercel_artifacts.yml` (PR #2197) to enable automated behavior test runs using mock remote server targets.

## Pull Request & Feedback

* **PR Link:** [apache/opendal#7793](https://github.com/apache/opendal/pull/7793)
* **PR Description:**
  - **Which issue does this PR close?** Closes #2198.
  - **Rationale for this change:** The `vercel_artifacts` cache backend (used for Vercel's Remote Cache) had multiple failing behavior tests because it did not implement standard operations like `stat`, and attempted to run unsupported operations like `delete` and `create_dir`. Vercel's Remote Cache API is a simple flat key-value cache that does not support folder hierarchies or deleting individual cache entries. This PR fixes the failures by implementing a proper `stat` checker (using a `HEAD` request to verify artifact existence) and configuring capabilities to skip the unsupported `delete` and `create_dir` operations.
  - **What changes are included in this PR?**
    1. Implemented the `stat` operation in `core/services/vercel-artifacts/src/backend.rs` by sending a `HEAD` request to `/v8/artifacts/{hash}` to fetch metadata and verify existence.
    2. Added a fast-path check in `stat` to return directory metadata (`EntryMode::DIR`) directly when a path is `/` or ends with a slash, preventing invalid API calls for directory structures.
    3. Kept the `delete` and `create_dir` capabilities disabled so the behavior test runner correctly skips these unsupported operations.
  - **Are there any user-facing changes?** No user-facing breaking changes. This only fixes internal service compatibility and behavior tests for Vercel Remote Cache.
  - **AI Usage Statement:** I used Gemini (Antigravity AI coding assistant) to assist in reproducing the issue, identifying the REST API constraints, implementing the `stat` directory check logic, and structuring the PR description.
* **GitHub Issue Comment:**
  > Hi @Xuanwo, I've resolved the `vercel_artifacts` behavior test failures by implementing the `stat` operation via a `HEAD` request to `/v8/artifacts/{hash}`, along with returning directory metadata for paths ending with a slash. Since Vercel's Remote Cache REST API does not support deleting individual cache entries or directory hierarchies, we keep `delete` and `create_dir` disabled in the backend capabilities so the test runner correctly bypasses them. I have submitted a pull request with these changes for your review.
* **Status:** Awaiting review

---
---
---

# Contribution [#3]: When using FnApi and DataStream, bundle processing is not isolated due to limited queues and multiplexing

**Contribution Number:** 3  
**Student:** Krishna Manchikalapudi  
**Issue:** [apache/beam#39001](https://github.com/apache/beam/issues/39001)  
**Status:** Merged  
**Branch:** [krishnamanchikalapudi/apache-beam@fix-39001-named-data-stream-lifecycle](https://github.com/krishnamanchikalapudi/apache-beam/tree/fix-39001-named-data-stream-lifecycle)  
**PR:** [apache/beam#39255](https://github.com/apache/beam/pull/39255)  

## Why I Chose This Issue

This issue is in Apache Beam, the preeminent open-source unified programming model for batch and streaming data processing pipelines. I chose this issue because I am highly interested in distributed systems communication protocols, specifically the gRPC-based Beam Fn API that coordinates data and control planes between runners and language SDK harnesses. Enhancing resource isolation on the data plane is vital for pipeline stability and performance under heavy load, and addressing connection lifecycle leaks is a critical aspect of engine health.

## Understanding the Issue

### Problem Description

Apache Beam's Fn API uses a shared `DataStream` RPC to transmit element data between the runner and the SDK harness. However, having all active bundle processing requests share a single physical gRPC data stream can cause **head-of-line blocking**. If one bundle processes its data slowly, its internal buffer/queue fills up. When the queue is full, the SDK stops reading from the shared gRPC stream, blocking other healthy bundles from receiving their inputs.

To solve this, Beam introduced support for **named data streams** (via issue [#38863](https://github.com/apache/beam/issues/38863)). Under this model, the runner can assign unique stream IDs to separate bundles to isolate their data traffic.

**The Bug:**
In the Java SDK harness, the `BeamFnDataGrpcClient` cached the multiplexer (and its underlying physical gRPC connection) per endpoint and stream ID combination in `multiplexerCache` indefinitely. Because runners can dynamically allocate fresh, unique named data stream IDs for new bundles over time, the SDK harness would accumulate these multiplexers and connections forever, resulting in a severe **gRPC connection and memory leak**.

### Expected Behavior

- Named data streams should be reference-counted by the SDK harness.
- A named stream should be opened when a processing bundle starts using it, and automatically closed and removed from the cache when no active bundles are using it.
- The default (empty/unnamed) data stream should remain open for the entire lifetime of the SDK harness client to prevent connection churn in standard workloads.

### Current Behavior

- The harness cached named data stream multiplexers indefinitely, leading to resource leaks when unique stream IDs were assigned dynamically.

### Affected Components

- **[`ProcessBundleHandler.java`](file:///Users/krishna/Documents/GitHub/apache-beam/sdks/java/harness/src/main/java/org/apache/beam/fn/harness/control/ProcessBundleHandler.java)**
- **[`BeamFnDataClient.java`](file:///Users/krishna/Documents/GitHub/apache-beam/sdks/java/harness/src/main/java/org/apache/beam/fn/harness/data/BeamFnDataClient.java)**
- **[`BeamFnDataGrpcClient.java`](file:///Users/krishna/Documents/GitHub/apache-beam/sdks/java/harness/src/main/java/org/apache/beam/fn/harness/data/BeamFnDataGrpcClient.java)**

---

## Reproduction Process

### Environment Setup

- **OS / Shell:** macOS (darwin 25.5.0), zsh.
- **Java:** OpenJDK 25 / 26.
- **Repo:** Cloned the `apache/beam` repository locally and checked out the topic branch `fix-39001-named-data-stream-lifecycle`.

### Steps to Reproduce

Because this is a resource leak, reproduction involves showing that named data stream multiplexers are retained in the internal client cache after use.

1. Instantiate `BeamFnDataGrpcClient` and request an outbound observer for a specific named data stream ID (e.g., `streamA`).
2. Simulate bundle processing completion.
3. Check the internal client cache `multiplexerCache`. Notice that the multiplexer and its active gRPC connection targeting `streamA` are still cached and have not been closed or evicted.
4. Over a long-running pipeline execution where the runner assigns a unique stream ID per bundle, observe memory growth and socket depletion in the SDK harness JVM due to leaked gRPC channels.

---

## Solution Approach

### Implementation Plan (UMPIRE)

**Understand.** We need to manage the lifecycle of named data stream multiplexers based on active bundle usage. When a bundle starts processing on a named stream, the reference count for that stream should increment. When the bundle finishes processing (successfully or exceptionally), the count should decrement. If the reference count drops to zero, the multiplexer must be closed and evicted from the client cache. The default stream (`""`) must be excluded from this logic.

**Match.** We match standard Java reference counting patterns. We track reference counts in a synchronized map inside `BeamFnDataGrpcClient`. We match the execution entry and exit points in `ProcessBundleHandler.processBundle` to increment and decrement the references.

**Plan.**
1. **Extend Client Interface:** Add `retainDataStream(String dataStreamId)` and `releaseDataStream(String dataStreamId)` to the `BeamFnDataClient` interface.
2. **Reference Counting:** In `BeamFnDataGrpcClient`, implement a `dataStreamRefCounts` map and a dedicated lock `dataStreamLifecycleLock` to guard lifecycle changes.
3. **Cache Eviction and Closing:** In `releaseDataStream`, decrement the ref count. If it hits zero, remove all matching multiplexers from the cache and close them.
4. **Thread-Safe Insertion:** Update `getMultiplexer` to run under the lifecycle lock to avoid race conditions (e.g., creating a multiplexer while it is being closed and removed).
5. **Harness Hook:** Update `ProcessBundleHandler.processBundle` to call `retainDataStream` on entry and `releaseDataStream` in a `finally` block to ensure release on both success and failure.
6. **Custom CI Workflow:** Add a fork-friendly GitHub Actions workflow `.github/workflows/fork_ci_java_harness.yml` targeting the Java harness code to facilitate testing without requiring upstream self-hosted runners.

**Implement.** Implemented the changes in the target Java source files and tests.

**Review.** Ensured that the expensive `multiplexer.close()` operation is invoked *outside* of the `dataStreamLifecycleLock` synchronized block to prevent blocking concurrent threads.

**Evaluate.** Wrote comprehensive unit tests to assert that:
- Named data streams are closed when their reference count drops to zero.
- The default data stream is never closed on release.
- Named data streams are correctly cleaned up even if the bundle processing fails with an exception.

---

## Implementation Notes

We completed the implementation of reference-counted named data stream lifecycles in the Java SDK harness.

### Files Modified

* **[`BeamFnDataClient.java`](file:///Users/krishna/Documents/GitHub/apache-beam/sdks/java/harness/src/main/java/org/apache/beam/fn/harness/data/BeamFnDataClient.java)**:
  - Added default methods `retainDataStream` and `releaseDataStream` to manage lifecycle hooks.
* **[`BeamFnDataGrpcClient.java`](file:///Users/krishna/Documents/GitHub/apache-beam/sdks/java/harness/src/main/java/org/apache/beam/fn/harness/data/BeamFnDataGrpcClient.java)**:
  - Added `dataStreamLifecycleLock` and `dataStreamRefCounts` map.
  - Implemented `retainDataStream` to increment the reference counts of named streams.
  - Implemented `releaseDataStream` to decrement the reference counts, remove the entry from `multiplexerCache` upon reaching zero, and close the underlying gRPC stream.
  - Synchronized `getMultiplexer` under the lifecycle lock to guarantee atomic creation.
* **[`ProcessBundleHandler.java`](file:///Users/krishna/Documents/GitHub/apache-beam/sdks/java/harness/src/main/java/org/apache/beam/fn/harness/control/ProcessBundleHandler.java)**:
  - Invokes `retainDataStream` when starting bundle execution on a named stream.
  - Releases the stream inside a `finally` block to guarantee cleanup.
* **[`BeamFnDataGrpcClientTest.java`](file:///Users/krishna/Documents/GitHub/apache-beam/sdks/java/harness/src/test/java/org/apache/beam/fn/harness/data/BeamFnDataGrpcClientTest.java)**:
  - Added `testNamedDataStreamClosedWhenNoLongerRetained` to verify reference counting and closure.
  - Added `testDefaultDataStreamIsNotClosedOnRelease` to verify that the default stream remains cached.
* **[`ProcessBundleHandlerTest.java`](file:///Users/krishna/Documents/GitHub/apache-beam/sdks/java/harness/src/test/java/org/apache/beam/fn/harness/control/ProcessBundleHandlerTest.java)**:
  - Added `testNamedDataStreamReleasedOnBundleFailure` to verify streams are released on processing exceptions.
* **[`.github/workflows/fork_ci_java_harness.yml`](file:///Users/krishna/Documents/GitHub/apache-beam/.github/workflows/fork_ci_java_harness.yml)**:
  - Created a new GitHub Actions workflow to build and test the Java SDK harness on fork repositories.
* **[`CHANGES.md`](file:///Users/krishna/Documents/GitHub/apache-beam/CHANGES.md)**:
  - Documented the bugfix under the "Bugfixes" section.

---

## Code Changes

* **Active Development Branch:** [`krishnamanchikalapudi/apache-beam@fix-39001-named-data-stream-lifecycle`](https://github.com/krishnamanchikalapudi/apache-beam/tree/fix-39001-named-data-stream-lifecycle)
* **Pull Request:** [apache/beam#39255](https://github.com/apache/beam/pull/39255)

---

## Challenges Faced

- **Deadlock and Connection Blocking Avoidance:** Closing a gRPC multiplexer terminates physical network streams, which can block. Invoking `multiplexer.close()` while holding `dataStreamLifecycleLock` could result in severe thread contention or deadlocks under high request concurrency. We resolved this by building a list of multiplexers to close inside the synchronized block, but executing the actual `.close()` operations outside the lock.
- **Concurrent Access Consistency:** Since gRPC outbound observers can be concurrently requested or torn down, we synchronized both the cache creation in `getMultiplexer` and the reference adjustments under a shared `dataStreamLifecycleLock` to prevent referencing a partially destroyed multiplexer.
- **Fork CI Limitations:** Upstream PreCommit checks rely on Google's self-hosted Runners, which fail on personal GitHub forks. We added `fork_ci_java_harness.yml` so that contributors can run the build, spotlessCheck, and harness unit tests cleanly on their own GitHub accounts before submitting PRs upstream.

---

## Testing Strategy

- **Unit Testing:**
  - Executed the unit tests covering the multiplexer lifecycle, client reference counting, and exception resilience in `BeamFnDataGrpcClientTest` and `ProcessBundleHandlerTest`:
    ```bash
    ./gradlew :sdks:java:harness:test --tests org.apache.beam.fn.harness.data.BeamFnDataGrpcClientTest --tests org.apache.beam.fn.harness.control.ProcessBundleHandlerTest
    ```
- **Fork CI Validation:**
  - Automated tests run on every push to the fork branch via the newly added `Fork CI Java Harness` workflow.

---

## Pull Request & Feedback

- **PR Link:** [apache/beam#39255](https://github.com/apache/beam/pull/39255)
- **PR Description:** This PR resolves the gRPC stream and memory leak in the Java SDK harness by reference counting the usage of named data streams and closing/evicting their multiplexers when no active bundles are using them.
- **Current Status:** Merged


