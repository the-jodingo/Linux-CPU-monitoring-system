[![Bash](https://img.shields.io/badge/Bash-4%2B-4EAA25?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)](https://www.kernel.org/)
[![No dependencies](https://img.shields.io/badge/dependencies-none-brightgreen)](https://www.kernel.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

# Linux CPU Monitoring System

A dependency-free Bash script that prints overall CPU usage, per-core usage,
load average, and the top CPU processes — refreshing in place.

No packages required. Uses `/proc/stat` directly for the overall figure.

## Usage

```bash
chmod +x cpu-monitor.sh
./cpu-monitor.sh
```

Press `Ctrl+C` to stop. Refreshes every 2 seconds.

## Optional: better per-core accuracy

The script falls back to parsing `top` if `mpstat` is missing. For accurate
per-core numbers install `sysstat`:

```bash
sudo apt install sysstat     # Debian/Ubuntu
sudo dnf install sysstat     # RHEL/Fedora
```

## How it works

- Overall CPU: reads `/proc/stat` twice 0.2 s apart and computes the delta
  between idle and total jiffies.
- Load average: parsed from `uptime`.
- Per-core: `mpstat -P ALL` when available, otherwise `top`.
- Top processes: `ps -eo pid,comm,%cpu,%mem --sort=-%cpu`.

## License

MIT
