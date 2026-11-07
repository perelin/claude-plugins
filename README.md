# claude-plugins

One Claude Code marketplace for all of my plugins, skills and mods. Each plugin lives in its own repository; this repo only holds the catalog (`.claude-plugin/marketplace.json`) that points at them.

| Plugin | What it does |
|---|---|
| [boxed-ui](https://github.com/perelin/boxed-ui) | Padded, themeable boxes around prompts and replies |
| [reladraw-view](https://github.com/perelin/reladraw-view) | Draws `reladraw` blocks in replies as inline images (kitty graphics) |
| [voice-brief](https://github.com/perelin/voice-brief) | `/voice-brief` speaks a short briefing of the last answer |
| [end-session](https://github.com/perelin/end-session) | Closes a session cleanly and prints a pointer-based handover |
| [visual-companion](https://github.com/perelin/visual-companion) | Shows mockups and diagrams in a local browser tab and collects click choices |

## Install

```
claude plugin marketplace add perelin/claude-plugins
claude plugin install <plugin>@perelin --scope user
```

or inside Claude Code: `/plugin marketplace add perelin/claude-plugins`, then `/plugin` to browse.

## Moving from the single-plugin marketplaces

Earlier each plugin was its own marketplace (`boxed-ui@boxed-ui` etc.). `scripts/migrate.sh` uninstalls those, removes the old marketplaces and installs the same plugins from this catalog. It is safe to run repeatedly:

```
bash scripts/migrate.sh
```

Run `/reload-plugins` (or start a new session) afterwards.

## Adding a plugin

1. Put the plugin in its own repo with `.claude-plugin/plugin.json` at the root.
2. Add an entry to `.claude-plugin/marketplace.json` with `"source": {"source": "url", "url": "https://github.com/perelin/<name>.git"}`.
3. `claude plugin validate .`

Entries are not pinned to a commit: installs follow each repo's default branch, and an update is picked up when the plugin's `version` changes.
