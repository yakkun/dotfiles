# Fix Crashlytics Crash

Analyze and fix a crash reported in Firebase Crashlytics using the Firebase MCP server tools.
Supports both Android (Java/Kotlin) and iOS (Swift/Objective-C) projects.

## Arguments

- `$ARGUMENTS`: Optional. A Crashlytics issue ID or Firebase Console URL. If omitted, list top crashes and ask which to investigate.

## Prerequisites

- Firebase MCP server must be configured with Crashlytics enabled for the target project
- Firebase CLI must be logged in (`npx firebase-tools login`)

## Instructions

### Step 0: Detect platform

Determine whether this is an **Android** or **iOS** project by checking:
- `build.gradle`, `build.gradle.kts`, `AndroidManifest.xml` → **Android**
- `*.xcodeproj`, `*.xcworkspace`, `Podfile`, `Package.swift` → **iOS**
- If both are present (monorepo), ask the user which platform to target
- Remember the detected platform for subsequent steps

### Step 1: Identify the crash

- If `$ARGUMENTS` contains an issue ID or URL, extract the issue ID and proceed to Step 2
- If `$ARGUMENTS` is empty or "list":
  1. Use the `crashlytics_list_top_issues` MCP tool to retrieve top crash issues
  2. Present the list to the user showing: title, crash count, user count, app version(s)
  3. Ask the user which crash to investigate
  4. Proceed with the selected issue ID

### Step 2: Gather crash details

1. Use `crashlytics_get_issue` to get the full issue details
2. Use `crashlytics_list_events` to get recent crash events with **stack traces**
3. Summarize for the user:
   - Crash type and error message
   - Number of affected users and events
   - Affected app versions
   - First and last occurrence

### Step 3: Analyze the stack trace

1. Parse the stack trace from the crash events
2. Identify frames that belong to **this app's code**:
   - **Android**: Look for the app's package name (check `AndroidManifest.xml` or `build.gradle` for `applicationId`/`namespace`)
   - **iOS**: Look for the app's module name (check project/target name) and filter out system frameworks
3. Ignore system/framework frames:
   - **Android**: Android framework, Java/Kotlin runtime, third-party libraries
   - **iOS**: UIKit, Foundation, CoreFoundation, libdispatch, libsystem, etc.
4. For each relevant app frame:
   - Search the codebase for the class/method/function using Grep or find_symbol
   - Read the source code around the crash point
5. Present the relevant stack trace frames and corresponding source code to the user

### Step 4: Diagnose the root cause

Analyze the crash context and determine the root cause.

**Common Android crash patterns:**

- **NullPointerException** — add null checks, use Kotlin safe calls (`?.`), or `@Nullable`/`@NonNull` annotations
- **ArrayIndexOutOfBoundsException** — add bounds checking
- **ClassCastException** — verify type before casting, use `instanceof`/`is` checks
- **IllegalStateException** — check Fragment/Activity lifecycle state
- **ConcurrentModificationException** — use thread-safe collections or synchronization
- **OutOfMemoryError** — check for memory leaks, large bitmap allocations
- **SecurityException** — check runtime permissions
- **WindowManager$BadTokenException** — check Activity is not finishing before showing dialogs
- **DeadObjectException** — handle Binder/IPC failures gracefully
- **SQLiteException** — check database operations, schema migrations

**Common iOS crash patterns:**

- **EXC_BAD_ACCESS (SIGBUS/SIGSEGV)** — use-after-free, dangling pointer, force-unwrap of deallocated object
- **Fatal error: Unexpectedly found nil while unwrapping** — replace force-unwrap (`!`) with `guard let`/`if let` or nil-coalescing (`??`)
- **EXC_BREAKPOINT (SIGABRT)** — failed assertion, `fatalError()`, or forced unwrap
- **Index out of range** — add bounds checking before subscript access
- **Unrecognized selector sent to instance** — check `@objc` exposure, selector spelling, protocol conformance
- **NSInternalInconsistencyException** — UIKit called from background thread, invalid table view updates
- **EXC_BAD_ACCESS (code=1, KERN_INVALID_ADDRESS)** — null pointer dereference, often from Objective-C interop
- **Stack overflow** — infinite recursion, deeply nested calls
- **Core Data save errors** — check managed object context thread safety, migration issues
- **Deadlock / watchdog timeout** — main thread blocked by synchronous call or lock contention

Explain the root cause clearly to the user with:
- What is crashing and why
- Under what conditions the crash occurs
- The specific line(s) of code involved

### Step 5: Implement the fix

1. Create a feature branch: `fix/crashlytics-<short-description>`
2. Make the **minimal necessary** code changes to fix the crash
3. Follow the project's existing code style and patterns:
   - **Android**: Java/Kotlin standard conventions
   - **iOS**: Swift/Objective-C standard conventions
   - Comments in English
4. Ensure the fix is **backward compatible**
5. Do NOT refactor surrounding code or make unrelated improvements

### Step 6: Summarize

Present to the user:
- Root cause explanation
- What was changed and why
- Any potential side effects or edge cases to watch for
- Ask the user to **build and verify** the fix (do not build yourself)

### Step 7: (Optional) Add notes to the issue

If the user confirms the fix:
- Offer to add a note to the Crashlytics issue using `crashlytics_create_note` with the fix details
- Offer to create a commit and PR

## Important

- Do NOT push to remote or create a PR unless explicitly asked
- Do NOT build or run the app — ask the operator to do it
- When uncertain about the fix approach, present options and ask the user
- Prioritize crash safety over feature changes
- Keep the fix minimal and focused
- Be aware of minimum deployment targets (check `minSdk`/`MinimumOSVersion` in project config)
