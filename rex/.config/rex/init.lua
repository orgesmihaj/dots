-- ─── rex init.lua  ────────────────────────────────────────────────╯

-- Rex reads only key bindings from this file. Theme, font, cursor and
-- padding live in Rex's settings; scripts/apply-rex-settings.zsh copies
-- them over from the ghostty package.

-- ─── session picker ───────────────────────────────────────────────

-- cmd+k starts the sequences below, so the picker moves to shift+cmd+k.
rex.bind("shift+cmd+k", "session.switch")

-- ─── splits (same chords as ghostty) ──────────────────────────────

rex.bind("cmd+k>w>s>l", "pane.split", { direction = "right" })
rex.bind("cmd+k>w>s>j", "pane.split", { direction = "down" })

rex.bind("cmd+k>w>h", "pane.focus", { direction = "left" })
rex.bind("cmd+k>w>j", "pane.focus", { direction = "down" })
rex.bind("cmd+k>w>k", "pane.focus", { direction = "up" })
rex.bind("cmd+k>w>l", "pane.focus", { direction = "right" })
