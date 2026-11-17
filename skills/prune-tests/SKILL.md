---
name: prune-tests
description: Prune tests that guard no behavior, and keep new tests focused and effective. Deletes or rewrites tests that pin removed code, test nothing, mirror the implementation, or duplicate another test. Use when the user asks to prune, clean up, or audit tests, and before opening a PR on the tests the branch adds or changes.
argument-hint: "[optional path]"
---

# Prune tests

Prune every test that guards no behavior. Keep only tests that would fail on a regression, and only on a regression.

## Scope

- **A path is given:** the tests under that path.
- **Called from the `pr` skill, or the user means "my changes":** the tests the branch adds or changes (`git diff origin/<base>...HEAD`). Leave untouched tests alone, except a test that a change on the branch made redundant or turned into a guard for removed code.
- **Otherwise:** ask which path to prune.

## 1. Judge each test

Keep a test only if it depends on intended behavior: it changes only when that behavior changes, and fails only when it regresses.

Prune tests that depend on:

**The past:** it guards code that no longer exists, so it can never catch a regression.

- A feature was removed, and a test asserts it is gone.
- A module was moved, and a test asserts it is absent from its old path.

**Nothing:** no change to the code can make it fail.

- It tests the platform or a framework: a `<button>` renders, a click event fires.
- It mocks the unit under test, then asserts what the mock returns.
- It asserts what the type system already guarantees.

**The implementation:** it changes whenever the code does, even when behavior did not.

- The expected value is computed with the same logic as the code, so a wrong result still passes.
- It asserts private state, internal call order, or which helper was called.

**Another test:** a second test already guards the same behavior.

- Two tests in different files assert the same result.
- Several tests feed inputs that all take the same code path. Keep one, plus one per real edge case (empty, boundary, error).

## 2. Prune

- Delete every test that is not anchored to intended behavior.
- If a test also covers behavior that callers rely on, rewrite it against that behavior instead of deleting it.
- Delete production code that only existed for the removed tests.
- Merge near-duplicates into one test, or one table-driven test when the cases cross real edges.

In branch scope, also check the reverse: if the branch changes behavior and no test would catch its regression, add one focused test, provided the repo tests that area. One test per behavior, not one per function.

Run the affected test suites after pruning. They must pass.

## Done when

- Every remaining test is anchored to intended behavior and would fail on a regression, and only on one.
- No test asserts code that no longer exists.
- No two tests guard the same behavior.
- No production code exists only for tests.
- The affected suites pass.

## Report

List each pruned or rewritten test as `file | test | verdict | reason`, with verdict `deleted`, `rewritten`, `merged`, or `added`. Cap the list at 10 rows and give the count of the rest. Name any production code removed.

## Example

```diff
--- a/pricing.test.ts
+++ b/pricing.test.ts
@@ rewritten: the expected value repeated the code's logic @@
 test("applies the discount", () => {
-  const price = 100;
-  expect(applyDiscount(price, 0.2)).toBe(price - price * 0.2);
+  expect(applyDiscount(100, 0.2)).toBe(80);
 });
--- a/cart.test.ts
+++ b/cart.test.ts
@@ rewritten against what callers see: it asserted private state @@
 test("adds an item to the cart", () => {
   const cart = new Cart();
   cart.add(book);
-  expect(cart._items.length).toBe(1);
+  expect(cart.total()).toBe(book.price);
 });
@@ deleted: checkout.test.ts already guards the same total @@
-test("total includes tax", () => {
-  expect(cartTotal([book], { tax: 0.1 })).toBe(11);
-});
--- a/slug.test.ts
+++ b/slug.test.ts
@@ merged: three tests took the same code path @@
-test("slugifies hello world", () => expect(slug("Hello World")).toBe("hello-world"));
-test("slugifies foo bar", () => expect(slug("Foo Bar")).toBe("foo-bar"));
-test("slugifies a b", () => expect(slug("A B")).toBe("a-b"));
+test.each([
+  ["Hello World", "hello-world"],
+  ["", ""],
+  ["  --A--  ", "a"],
+])("slugifies %j", (input, expected) => expect(slug(input)).toBe(expected));
--- a/export.test.ts
+++ b/export.test.ts
@@ deleted: it guards code that no longer exists @@
-test("legacy exporter is gone", () => {
-  expect(existsSync("src/export/legacy.ts")).toBe(false);
-});
--- a/session.test.ts
+++ b/session.test.ts
@@ deleted, with the production code that only existed for it @@
-test("clears the cache", () => {
-  _resetCacheForTests();
-  expect(_getCacheSize()).toBe(0);
-});
--- a/session.ts
+++ b/session.ts
@@ @@
-export function _resetCacheForTests() { cache.clear(); }
-export function _getCacheSize() { return cache.size; }
```
