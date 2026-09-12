# AGENTS.md

## 0. Project Mission

Build **AI Daily News**, a personal, free-to-run, serverless Flutter news reader.

Primary goals:

- Mobile-first Flutter app matching `mobile-design.html`
- Daily AI news is read from JSON files under `resources/`
- No login / account system
- Firebase Analytics passively learns reading preferences
- Page turning uses `https://github.com/Aethey/flutter_page_flip` directly as a Git dependency
- Architecture uses Riverpod + Freezed
- JSON models are generated from the real JSON schema
- Dio is the network client when a remote JSON source is needed
- Development prioritizes **speed, low token usage, and working vertical slices**
- Do not over-engineer, over-test, or spend many iterations polishing an isolated detail

The app must remain usable without any custom backend server.

---

# 1. Source of Truth / Priority

When requirements conflict, use this priority:

1. This `AGENTS.md`
2. `ANALYTICS_TRACKING.md`
3. Actual JSON files in `resources/`
4. `mobile-design.html`
5. Existing project code
6. Agent assumptions

Important:

- `mobile-design.html` is the visual / interaction reference.
- `resources/*.json` is the **data schema source of truth**.
- Do not invent fields only because the HTML prototype contains sample content.
- If the design contains a section but the JSON has no corresponding field, hide/omit the section instead of fabricating data.
- Do not silently rewrite product requirements.

Before coding, inspect only the files needed for the current task. Do not recursively read the entire repository unless necessary.

---

# 2. Development Philosophy

## Highest priority: efficiency

Work in large, useful vertical slices.

Preferred loop:

```text
inspect relevant files
→ decide the smallest architecture that supports the feature
→ implement the complete feature
→ run formatter/analyzer once
→ fix real errors
→ continue
```

Avoid:

```text
write 10 lines
→ run every test
→ tweak one pixel
→ rerun everything
→ investigate harmless warning
→ refactor unrelated code
→ repeat
```

Do not spend excessive time on:

- speculative abstractions
- exhaustive unit tests for trivial getters/models
- perfect pixel matching before the app works
- unrelated lint cleanup
- premature performance optimization
- hypothetical edge cases with no current product impact
- large refactors that are not required for the requested feature

Prefer shipping a coherent working slice over maximizing theoretical purity.

---

# 3. Validation Strategy

Validation is required, but keep it proportional.

After a meaningful implementation batch:

```bash
dart format lib test
flutter analyze
```

Run targeted tests only when they provide value.

Do **not** automatically run the full test suite after every small edit.

Before declaring a major feature complete:

```bash
flutter analyze
```

If relevant tests already exist:

```bash
flutter test
```

Do not block progress on unrelated pre-existing warnings or unrelated failing tests. Report them briefly instead.

For code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run code generation after model/schema changes, not after every unrelated edit.

---

# 4. Target Platforms

Primary:

```text
iOS
Android
```

The UI is mobile-first and should follow `mobile-design.html`.

If the existing Flutter project also supports Web:

- do not intentionally break Web compilation
- do not spend significant time optimizing desktop/web layout unless requested
- secure identity persistence on Web may use a browser-local fallback; mobile behavior is primary

---

# 5. UI / UX Reference

Implement the app based on:

```text
mobile-design.html
```

Preserve the design language:

- editorial / newspaper / magazine feeling
- warm paper-like light theme
- dark/night paper theme
- serif display typography + sans-serif body + mono metadata
- restrained accent color
- minimal rounded corners
- thin rules / borders
- strong hierarchy rather than card-heavy UI
- compact iPhone-oriented composition
- no generic Material 3 look replacing the supplied design

Major product surfaces from the design:

```text
Today
Reader
Shelf
Bookmarks
Search
Morning / Night paper mode
```

Bottom navigation:

```text
Today
Shelf
Bookmarks
```

Top area:

```text
AI Morning Journal
Search
Bookmarks shortcut
Paper mode toggle
```

Do not copy fake iPhone hardware chrome from the HTML into the real app:

```text
fake Dynamic Island
fake status bar
fake home indicator
device frame
```

Use real safe areas and system UI in Flutter.

---

# 6. Reader / Page Flip

Do not implement a custom page-flip engine.

Use the GitHub package directly:

```yaml
dependencies:
  flutter_page_flip:
    git:
      url: https://github.com/Aethey/flutter_page_flip.git
      ref: main
```

Do not clone or vendor the package into this repository.

Use the package for the Reader page-turn interaction.

Requirements:

- horizontal page turning
- natural touch gesture
- current page index available to app state
- page change must update reading progress
- analytics must know which article/page became visible
- app state should survive ordinary rebuilds/navigation

If package API details differ from assumptions:

1. inspect the dependency API
2. adapt our reader integration
3. do not modify/vendor the dependency unless absolutely necessary

---

# 7. Data Source

News data comes from JSON files under:

```text
resources/
```

Before creating any models:

1. inspect the actual JSON
2. identify the real root structure
3. identify nullable/optional fields
4. identify stable IDs
5. generate models based on the actual schema

Do not model from the HTML mock data.

Add resources to `pubspec.yaml` if required:

```yaml
flutter:
  assets:
    - resources/
```

Current default implementation should favor the simplest source that matches the repository:

```text
bundled resources JSON
→ AssetDataSource
→ Repository
→ Riverpod
→ UI
```

If the project already points to hosted/raw GitHub JSON, use Dio through the same repository interface.

Do not invent a backend REST API.

---

# 8. Dio

Use Dio as the standard HTTP client for remote data.

Dependency:

```yaml
dependencies:
  dio:
```

Keep configuration minimal.

Example responsibility:

```text
DioProvider
→ timeout/basic headers
→ RemoteNewsDataSource
```

Do not add:

- complex interceptor stacks
- token refresh
- auth interceptors
- retry frameworks
- certificate pinning
- elaborate error middleware

unless a real requirement appears.

There is no login.

If all current news data is bundled locally, do not force Dio into the local asset-loading path just to say it is being used. Keep the remote data-source seam ready and small.

---

# 9. Models / Code Generation

Use:

```text
freezed
json_serializable
build_runner
```

Suggested dependencies:

```yaml
dependencies:
  freezed_annotation:
  json_annotation:

dev_dependencies:
  build_runner:
  freezed:
  json_serializable:
```

Models should use Freezed:

```dart
@freezed
class Article with _$Article {
  const factory Article({
    required String id,
    required String title,
    // fields must match actual JSON
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
```

Rules:

- use actual JSON keys
- prefer explicit `@JsonKey` only when needed
- nullable only when source data can genuinely omit/null the field
- do not invent `whyImportant`, `score`, `importance`, etc.
- do not create giant generic `Map<String, dynamic>` models when schema is known
- avoid manual parsing if generator can do it cleanly

Generate with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

# 10. State Management

Use Riverpod.

Suggested dependency:

```yaml
dependencies:
  flutter_riverpod:
```

Prefer simple providers/controllers over unnecessary generator layers.

Use Riverpod for:

- current issue/date
- issue/article loading
- reader page/progress
- bookmarks
- theme/paper mode
- persistent local reading state
- analytics/identity services

Suggested organization:

```text
lib/
  app/
  core/
    analytics/
    identity/
    network/
    storage/
    theme/
  features/
    news/
      data/
      domain/
      presentation/
    reader/
    shelf/
    bookmarks/
    search/
```

Do not create domain/usecase/repository layers purely for ceremony.

A practical structure is preferred:

```text
DataSource
→ Repository
→ Provider/Controller
→ Widget
```

---

# 11. Suggested Dependencies

Use only what is needed.

Core:

```yaml
dependencies:
  flutter_riverpod:
  freezed_annotation:
  json_annotation:
  dio:
  firebase_core:
  firebase_analytics:
  uuid:
  flutter_secure_storage:
  url_launcher:
```

Page flip:

```yaml
  flutter_page_flip:
    git:
      url: https://github.com/Aethey/flutter_page_flip.git
      ref: main
```

Dev:

```yaml
dev_dependencies:
  build_runner:
  freezed:
  json_serializable:
```

Add another package only if it clearly saves implementation time or solves a real requirement.

---

# 12. Anonymous Installation Identity

There is **no login**.

On first launch, create a random anonymous UUID.

Use:

```text
uuid
flutter_secure_storage
```

Storage key:

```text
anonymous_installation_id
```

Logic:

```text
Firebase initialized
→ read anonymous_installation_id from secure storage
→ if found: reuse it
→ if missing: UUID v4 → store it
→ FirebaseAnalytics.setUserId(uuid)
```

Example shape:

```dart
final existing = await secureStorage.read(
  key: 'anonymous_installation_id',
);

final id = existing ?? const Uuid().v4();

if (existing == null) {
  await secureStorage.write(
    key: 'anonymous_installation_id',
    value: id,
  );
}

await FirebaseAnalytics.instance.setUserId(id: id);
```

Requirements:

- anonymous only
- never derive it from device serial, email, phone, Apple ID, advertising ID, etc.
- do not display it to the user
- do not require permission dialogs for this ID
- stable for normal usage as long as secure storage survives
- do not promise cross-uninstall persistence
- on Android use secure storage backed by platform secure mechanisms
- on iOS use Keychain-backed secure storage
- if Web is supported, use a browser-local fallback and accept that browser storage can be cleared

Firebase's own automatic identifiers still exist; this UUID is our stable anonymous application identity.

---

# 13. Firebase Analytics

Follow:

```text
ANALYTICS_TRACKING.md
```

Tracking must be passive.

Do not add UI asking the user to:

- rate articles
- like/dislike
- vote
- provide feedback
- share for recommendation learning
- explicitly select interests

The system learns from natural reading behavior.

Core events:

```text
article_impression
article_open
article_read
original_link_click
article_reopen
```

Do not create event spam.

Do not send full article bodies to Firebase.

Always use stable:

```text
article_id
```

as the content key.

---

# 14. Reader Analytics Rules

## article_impression

Record when an article is actually visible to the user.

For full-page reader pages, page activation is enough to identify visibility.

Preferred logic:

```text
page becomes active
→ wait ~500ms
→ if still active
→ log article_impression once for that reader/feed session
```

If one magazine page contains multiple clearly visible stories, log each visible story once.

Do not log from `build()`.

---

## article_open

Log when the user intentionally enters an article/issue reader.

Include:

```text
article_id
position
feed_date
```

where available.

---

## article_read

Do not send timer events every second.

Track locally:

```text
foreground visible duration
max progress / scroll depth
```

Flush one summarized event when:

- leaving an article
- moving to another article
- closing reader
- app lifecycle makes the current read session end

Parameters:

```text
article_id
reading_time_sec
max_scroll_percent
```

For a page-flip article without vertical scrolling, derive progress from page/article completion rather than inventing fake scroll values.

If the article itself scrolls vertically, calculate real max scroll percentage.

---

## original_link_click

Log immediately before launching the existing original-source link.

Use `url_launcher`.

---

## article_reopen

Keep local history of previously opened article IDs.

If an article has already been opened in the past and is opened again, log:

```text
article_reopen
```

Do not count rebuild/navigation restoration as a reopen.

---

# 15. Bookmarks

The supplied design includes bookmarks.

Implement them as a normal product feature.

Important distinction:

```text
bookmark exists for user utility
≠
bookmark is required feedback for recommendation
```

Do not require bookmarks.

Do not make personalization depend on bookmarks.

Unless explicitly requested later, do not add a special preference-learning analytics event for bookmark actions.

Persist bookmarks locally.

No server sync.

---

# 16. Local Persistence

Persist small local app state only.

Examples:

```text
anonymous UUID        → flutter_secure_storage
bookmarks             → lightweight local persistence
read article IDs      → lightweight local persistence
issue reading progress→ lightweight local persistence
paper mode            → lightweight local persistence
last opened issue     → lightweight local persistence
```

Use the simplest existing persistence mechanism in the project.

If none exists, prefer a lightweight solution.

Do not introduce a database unless JSON volume/state volume actually requires one.

---

# 17. Reading State

Shelf state should support at least:

```text
unread
partial
done
```

Derive state from local progress.

Suggested rule:

```text
never opened                    → unread
opened but not finished         → partial
reached final relevant page     → done
```

Persist by issue/date ID, not by UI list index.

---

# 18. Search

Search is local.

Search over loaded JSON content.

Start simple:

```text
title
summary
source
topics/category
```

Case-insensitive where applicable.

No remote search service.

No search indexing engine unless the dataset becomes large enough to justify it.

---

# 19. Original Links

Use:

```text
url_launcher
```

Open source articles externally.

Before launch:

```text
log original_link_click
→ launch URL
```

Do not proxy links through a backend.

---

# 20. Theme

Implement the design's two paper modes:

```text
Morning
Night
```

Persist locally.

Use a centralized theme/token layer.

Do not scatter raw colors throughout widgets.

Translate the HTML design tokens into Flutter theme constants.

Approximate unsupported CSS color functions visually instead of building unnecessary color-conversion infrastructure.

Visual consistency matters more than mathematically reproducing every OKLCH value.

---

# 21. Design Implementation Guidance

Translate the HTML, do not mechanically port it.

Use Flutter-native equivalents:

```text
SafeArea
Scaffold / custom shell
CustomScrollView / ListView
AnimatedSwitcher / AnimatedContainer
ThemeExtension or centralized design tokens
```

Reader uses `flutter_page_flip`.

Shelf/book extraction animation may use standard Flutter animation primitives.

Do not add WebView just to render the HTML design.

Do not use the HTML file at runtime.

---

# 22. Content Layout

The prototype contains editorial sections such as:

```text
headline
lead/summary
key points
source
original link
```

Render only fields present in the actual JSON.

If JSON does not contain a section:

```text
omit section
```

Never synthesize content inside the client app.

The Flutter app is a reader, not an LLM content generator.

---

# 23. Error Handling

Keep error UX simple.

Required states:

```text
loading
content
empty
error
```

For local JSON parse errors:

- show a concise recoverable UI
- log useful debug information in development
- do not crash the whole app if one optional issue/file fails

For remote Dio errors, if/when remote mode exists:

- timeout
- network unavailable
- invalid response
- parse failure

No elaborate error taxonomy unless needed.

---

# 24. No Backend / Cost Constraints

Do not introduce:

- custom API server
- EC2
- Lambda
- Cloud Functions
- custom database backend
- auth backend
- recommendation server

without explicit instruction.

Allowed external services:

```text
Firebase Analytics
GitHub/static JSON source if configured
original article websites
```

The normal app should not require a paid custom server.

---

# 25. Firebase Initialization Order

Startup should stay straightforward:

```text
WidgetsFlutterBinding.ensureInitialized()
→ Firebase.initializeApp(...)
→ initialize/retrieve anonymous UUID
→ FirebaseAnalytics.setUserId(...)
→ runApp(...)
```

Do not block app startup on nonessential analytics calls for a long time.

If analytics initialization fails unexpectedly, the news reader should still be able to start where reasonably possible.

---

# 26. Privacy / Analytics Guardrails

Never send to Analytics:

```text
name
email
phone
password
exact address
credentials
full article body
secret/API keys
```

Anonymous UUID is not tied to personal identity.

Do not access advertising IDs.

Do not add invasive device fingerprinting.

---

# 27. Implementation Order

Unless the existing project structure strongly suggests otherwise, implement in this order:

## Phase 1 — Foundations

```text
dependencies
Firebase init
anonymous UUID
theme tokens
Freezed models from real resources JSON
resource loader/repository
```

## Phase 2 — Working core

```text
Today screen
issue loading
Reader
flutter_page_flip
original source link
```

At this point the app must already be meaningfully usable.

## Phase 3 — Passive analytics

```text
article_impression
article_open
article_read
original_link_click
article_reopen
```

## Phase 4 — Library features

```text
Shelf
read progress
Bookmarks
Search
Morning/Night mode persistence
```

## Phase 5 — polish

```text
animations
layout refinement
empty/error states
minor responsive fixes
```

Do not start Phase 5 before the core path works.

---

# 28. Definition of MVP Done

The MVP is done when:

```text
[ ] App launches
[ ] Firebase initializes
[ ] anonymous UUID is reused across normal launches
[ ] Firebase Analytics user ID is set to the anonymous UUID
[ ] resources JSON loads successfully
[ ] JSON models use Freezed/generated serialization
[ ] Today screen follows mobile-design.html
[ ] Reader uses GitHub flutter_page_flip dependency
[ ] User can turn pages
[ ] Original link opens
[ ] Core passive analytics events fire
[ ] No rating/like/dislike feedback UI was added for learning
[ ] Shelf shows issue/read state
[ ] Bookmarks work locally
[ ] Search works locally
[ ] Morning/Night mode works
[ ] flutter analyze has no new blocking errors
```

Do not expand MVP scope without a requirement.

---

# 29. Agent Working Rules

When executing tasks in this repository:

1. **Read the actual relevant file before editing it.**
2. **Inspect the real JSON before defining/changing models.**
3. **Use existing conventions before introducing new ones.**
4. **Prefer editing existing files over creating needless abstractions.**
5. **Do not clone `flutter_page_flip`; depend on Git.**
6. **Do not build a custom server.**
7. **Do not add login.**
8. **Do not add explicit preference-feedback interactions.**
9. **Do not log analytics from Widget `build()`.**
10. **Do not manually edit generated `*.freezed.dart` / `*.g.dart`.**
11. **Do not run codegen repeatedly when models have not changed.**
12. **Batch related edits.**
13. **Run formatter/analyzer after a meaningful batch, not every tiny edit.**
14. **Do not fix unrelated repository issues unless they block the task.**
15. **Do not spend many turns debating implementation details when a conventional simple choice exists.**
16. **If a requirement is underspecified, choose the smallest reversible implementation.**
17. **Keep responses/status reports concise: what changed, important decision, remaining blocker.**
18. **Token efficiency is a product requirement for the development process.**

---

# 30. Avoid These Patterns

Do not introduce these unless a concrete requirement forces them:

```text
Clean Architecture with many empty layers
use-case class per trivial operation
service locator + DI framework on top of Riverpod
custom router framework for a tiny app
GraphQL
backend auth
remote database
event bus
complex caching framework
custom page-flip renderer
massive golden-test suite
test for every Freezed model getter
large design-system package
premature offline sync engine
```

Simple, readable Flutter code wins.

---

# 31. When in Doubt

Choose the option that best satisfies:

```text
works now
+
matches design
+
keeps data model correct
+
preserves passive analytics
+
requires least code
+
is easy to change later
```

Do not choose the most elaborate option merely because it is architecturally impressive.
