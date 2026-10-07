[![CI](https://github.com/the-jodingo/Linux-CPU-monitoring-system/actions/workflows/ci.yml/badge.svg)](https://github.com/the-jodingo/Linux-CPU-monitoring-system/actions/workflows/ci.yml)
[![Bash](https://img.shields.io/badge/Bash-4%2B-4EAA25?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![ShellCheck](https://img.shields.io/badge/linted%20with-shellcheck-blue)](.github/workflows/ci.yml)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)](https://www.kernel.org/)
[![Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen)](https://www.kernel.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

# Linux CPU Monitoring System

A dependency-free Bash script that prints overall CPU usage, per-core usage,
load average, and the top CPU processes, refreshing in place.

No packages required — the overall figure comes straight from `/proc/stat`.

## Table of contents

- [Requirements](#requirements)
- [Usage](#usage)
- [Output](#output)
- [How it works](#how-it-works)
- [Optional: better per-core accuracy](#optional-better-per-core-accuracy)
- [Testing and CI](#testing-and-ci)
- [License](#license)

## Requirements

- Linux
- Bash 4 or newer

Nothing else. `sysstat` is optional and only improves per-core accuracy.

## Usage

```bash
git clone https://github.com/the-jodingo/Linux-CPU-monitoring-system.git
cd Linux-CPU-monitoring-system
chmod +x cpu-monitor.sh
./cpu-monitor.sh
```

Press `Ctrl+C` to stop. Refreshes every 2 seconds.

## Output

- Overall CPU usage, as a percentage
- Load average (1 / 5 / 15 minutes)
- Per-core usage
- The top 10 processes by CPU, with memory as well

## How it works

| Section | Method |
|---|---|
| Overall CPU | Reads `/proc/stat` twice, 0.2 s apart, and computes the delta between idle and total jiffies |
| Load average | Parsed from `uptime` |
| Per-core | `mpstat -P ALL` when available, otherwise `top` |
| Top processes | `ps -eo pid,comm,%cpu,%mem --sort=-%cpu` |

## Optional: better per-core accuracy

Without `mpstat` the per-core figures are approximations parsed from `top`.
Install `sysstat` for accurate numbers:

```bash
sudo apt install sysstat     # Debian / Ubuntu
sudo dnf install sysstat     # RHEL / Fedora
```

## Testing and CI

GitHub Actions runs:

- **ShellCheck** at warning severity
- **Smoke test** — `bash -n` syntax check, then runs the script for 5 seconds

## License

[MIT](LICENSE) © Joash Odingo
