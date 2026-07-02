---
name: verify-ui
description: Mobile-first UI verification before claiming any visual change is done.
---

A UI change isn't done because the code looks right — it's done because it was seen working.

1. **Mobile viewport first** — 375×812. Screenshot using whatever preview/browser tooling is available in this session.
2. **Describe what's actually visible** — layout, overflow, tap target size, contrast. Compare against what was asked for, not against the code that was written.
3. **Desktop second** — 1280×800, briefly. Mobile is the primary check; desktop is confirmation.
4. **No screenshot possible** — say exactly that. Never claim something was visually verified if it wasn't.
5. **Report** what was checked at which viewport, any discrepancies found, and flag anything that's a genuine aesthetic call — that decision stays with the user, don't make it for them.
