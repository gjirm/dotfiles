# My dotfiles

Workstation setup for Linux, WSL and Windows, managed by
[mise](https://mise.jdx.dev). One bootstrap script installs mise, clones this
repo into `~/.config/mise` and runs `mise bootstrap`, which installs packages
and tools, deploys dotfiles and sets up the shell for the selected **profile**.

> The mise-based setup lives on the `mise` branch.

## Profiles

Each profile is a mise environment (`-E <profile>`) backed by a
`config.<profile>.toml` file layered on top of the shared `config.toml`.

| Profile        | Platform              | Purpose                                              |
| -------------- | --------------------- | ---------------------------------------------------- |
| `personal`     | Linux                 | Personal machine                                     |
| `work`         | Linux                 | Work machine                                         |
| `server`       | Linux                 | Server, minimal toolset, no atuin                    |
| `wsl`          | Ubuntu on WSL2        | Personal + SSH agent bridge to Windows               |
| `wsl-work`     | Ubuntu on WSL2        | Work + SSH agent bridge to Windows                   |
| `win-personal` | Windows               | Personal Windows machine (winget, PowerShell 7)      |
| `win-work`     | Windows               | Work Windows machine (winget, PowerShell 7)          |

What a profile sets up:

* **Linux / WSL** - apt packages, mise tools (starship, eza, fzf, zoxide,
  atuin, ...), zsh as login shell with plugins (syntax highlighting,
  autosuggestions, completions, fzf-tab), tmux + tpm, rendered `~/.zshrc`,
  `~/.gitconfig` and app configs (bat, micro, starship, superfile, atuin).
* **Windows** - winget packages (Git, gh, PowerShell 7, fd, fzf, micro,
  starship, zoxide, eza, ...), PowerShell profile + aliases, PowerShell modules
  (`utils/install-pwsh-modules.ps1`), `~/.gitconfig` and app configs.

The chosen profile is persisted in `~/.config/mise/miserc.toml` (gitignored),
so later `mise` commands use it without `-E`.

## Installation

### Linux / WSL

Prerequisites: `bash`, `curl` and `git`.

```shell
bash <(curl -fsSL https://raw.githubusercontent.com/gjirm/dotfiles/mise/bootstrap.sh)
```

The script asks for the profile:

```text
Select the configuration profile for this machine:
  1) Personal (Linux) [Default]
  2) Work (Linux)
  3) Server (Linux)
  4) WSL (Windows Subsystem for Linux)
  5) WSL Work (Windows Subsystem for Linux)
```

Use `bash <(curl ...)`, not `curl ... | bash`: the profile prompt reads from
stdin, which would be the script itself.

To skip mise's confirmation prompts, pass `--yes` (or set `BOOTSTRAP_YES=1`):

```shell
bash <(curl -fsSL https://raw.githubusercontent.com/gjirm/dotfiles/mise/bootstrap.sh) --yes
```

When it finishes, log out and back in (or start `zsh`) to get the new shell.

### Windows

Prerequisites: `winget` (App Installer from the Microsoft Store). Run as a
regular user, winget asks for elevation itself when needed. Works from Windows
PowerShell 5.1 as well as PowerShell 7.

Interactive, the script asks for the profile:

```powershell
irm https://raw.githubusercontent.com/gjirm/dotfiles/mise/bootstrap-win.ps1 | iex
```

```text
Select the configuration profile for this machine:
  1) Personal (Windows) [Default]
  2) Work (Windows)
Enter choice [1-2, default: 1]:
```

Accepts the number, the profile name (`win-work`) or its short form (`work`);
Enter picks the default.

Non-interactive, with the profile passed as a parameter:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/gjirm/dotfiles/mise/bootstrap-win.ps1))) -ProfileName win-work -Yes
```

or via environment variables, which also work with `irm | iex`:

```powershell
$env:BOOTSTRAP_PROFILE = 'win-work'; $env:BOOTSTRAP_YES = '1'
irm https://raw.githubusercontent.com/gjirm/dotfiles/mise/bootstrap-win.ps1 | iex
```

From a local checkout:

```powershell
.\bootstrap-win.ps1 [-ProfileName win-personal|win-work] [-Yes]
```

| Option         | Environment variable | Description                                    |
| -------------- | -------------------- | ---------------------------------------------- |
| `-ProfileName` | `BOOTSTRAP_PROFILE`  | `win-personal` or `win-work`; prompt if unset  |
| `-Yes`         | `BOOTSTRAP_YES=1`    | Pass `--yes` to `mise bootstrap`               |

The script installs Git and mise via winget, sets the `CurrentUser` execution
policy to `RemoteSigned` (if not already permissive), clones the repo, writes
`miserc.toml` and runs `mise bootstrap`. Open a new PowerShell 7 terminal
afterwards to load the profile.

### WSL SSH agent bridge

The `wsl` and `wsl-work` profiles forward `SSH_AUTH_SOCK` in WSL to the
Windows OpenSSH agent, so keys loaded on Windows are usable inside WSL. It uses
`socat` and `~/.wsl/npiperelay.exe`, both deployed by the WSL profile, and is
started from `~/.zshrc`.

1. On Windows, enable the agent and add your key:

    ```powershell
    Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service
    ssh-add $HOME\.ssh\id_ed25519
    ```

2. Bootstrap WSL with the `wsl` or `wsl-work` profile and open a new shell.
   `ssh-add -l` should list the Windows keys.

## Day-to-day usage

The repo lives in `~/.config/mise`. The `personal` and `wsl` profiles switch
its origin to SSH at the end of the bootstrap, the others keep HTTPS.

```shell
cd ~/.config/mise
git pull                    # get the latest config
mise bootstrap              # re-apply everything for the current profile
mise install                # install / update tools only
mise dot diff               # preview dotfile changes
mise dot apply              # deploy dotfiles only
```

To switch a machine to another profile, re-run the bootstrap script, or edit
`~/.config/mise/miserc.toml` (`env = ["<profile>"]`) and run `mise bootstrap`.

Local, machine-specific shell settings go into `~/.zshrc_local`, which is
sourced by `~/.zshrc` and never overwritten.

## Repository layout

```text
.
├── bootstrap.sh              # Linux / WSL bootstrap
├── bootstrap-win.ps1         # Windows bootstrap
├── config.toml               # Shared: common tools and dotfiles
├── config.<profile>.toml     # Per-profile packages, tools, dotfiles, hooks
├── dotfiles/
│   ├── .config/              # Sources for deployed configs
│   │   ├── zsh/zshrc.tera    # ~/.zshrc template (per-profile blocks)
│   │   ├── git/<profile>/    # ~/.gitconfig per profile
│   │   ├── powershell/       # PowerShell profile and aliases
│   │   └── atuin, bat, micro, starship, superfile, tmux
│   └── .wsl/npiperelay.exe   # Windows half of the WSL SSH agent bridge
└── utils/
    └── install-pwsh-modules.ps1
```

## Customizing

* **Add a tool** - add it under `[tools]` in `config.toml` (all machines) or
  in a `config.<profile>.toml`.
* **Add a system package** - `[bootstrap.packages]` in the profile config
  (`apt:<name>` on Linux, `winget:<id>` on Windows).
* **Add a dotfile** - put the source under `dotfiles/.config/` and add a
  `[dotfiles."<name>"]` entry with `source`, `mode` (`copy` or `template`) and
  per-OS `variants` targets.
* **Profile-specific content in a template** - `mise_env` is a list of the
  active environments, so test membership, not equality:

    ```tera
    {% if mise_env is defined and 'wsl' in mise_env %}
    ...
    {% endif %}
    ```

* **Add a profile** - create `config.<name>.toml` (copy the closest existing
  one, update the `miserc.toml` content) and add it to the menu in
  `bootstrap.sh` or to `$BootstrapProfiles` in `bootstrap-win.ps1`.
