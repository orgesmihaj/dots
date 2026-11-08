# Rex

[Rex](https://rex.superlogical.com) set up to look and feel like the
[ghostty](../ghostty/README.md) package.

After stowing, copy it over with:

```sh
zsh scripts/apply-rex-settings.zsh
```

That sets the JetBrainsMono Nerd Font at 14pt with 20% taller lines, an
underline cursor, 12pt side padding, Display P3 colors, copy on select, and
left Option as Alt.

It also matches Ghostty's themes: Modus Operandi for light and Catppuccin
Mocha for dark. Rex doesn't ship them, so the first run imports them from
Ghostty's theme folder through the running app. Open Rex and turn on Remote
Control (Settings > Rex Server) for that run. Later runs just reselect them.

Type `keymap rex` in the shell to see the keybindings.
