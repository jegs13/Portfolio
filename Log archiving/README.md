# Bash Lab — Log Archiving & Backup

A hands-on lab focused on archiving and extracting files using `tar` in a Linux environment.

---

## 📋 Scenario

Suspicious activity was detected on the system. To preserve evidence, all `.log` files from `/var/log` needed to be archived and backed up.

---

## 🎯 Objectives

- Create a `tar` archive of all `.log` files in `/var/log`
- Store the archive at `~/archive/log.tar`
- Strip path names so files are archived without directory prefixes
- Produce verbose output during archiving
- List archive contents without extracting
- Extract the archived files to `~/backup`

---

## 🛠️ Commands

### 1. Set up directories

```bash
mkdir ~/archive
mkdir ~/backup
```

### 2. Create the archive

```bash
cd /var/log && tar -cvf ~/archive/log.tar *.log
```

> `cd /var/log` first so `tar` picks up the files without their full path — this is what keeps the archive clean with just filenames and no `var/log/` prefix.

**Flags breakdown:**
| Flag | Meaning |
|------|---------|
| `-c` | Create a new archive |
| `-v` | Verbose — show files as they're archived |
| `-f` | Specifies the archive file to use |

### 3. List archive contents (without extracting)

```bash
tar -tf ~/archive/log.tar
```

**Flags breakdown:**
| Flag | Meaning |
|------|---------|
| `-t` | List contents of the archive |
| `-f` | Specifies the archive file to use |

### 4. Extract to `~/backup`

```bash
tar -xf ~/archive/log.tar -C ~/backup
```

**Flags breakdown:**
| Flag | Meaning |
|------|---------|
| `-x` | Extract files from the archive |
| `-f` | Specifies the archive file to use |
| `-C` | Extract into the specified directory |

---

## 💡 Key Takeaways

- **`tar` and glob expansion:** The shell expands `*.log` before `tar` even runs. By `cd`-ing into `/var/log` first, the glob expands in the right directory and files get archived without path prefixes — no need for `--strip-components`.

- **The `-f` flag:** `tar` stands for *Tape Archive* — it was originally designed to write to physical tape drives. The `-f` flag tells it to use a regular file instead. It always needs to come right before the filename.

- **`-C` on extract vs create:** `-C` works reliably during extraction (`-x`), telling `tar` exactly where to place the files. During creation, it's trickier because the shell may expand globs before `tar` changes directory.

---

## ⚠️ Notes

- `/var/log/boot.log` threw a `Permission denied` error since it requires elevated privileges. Since it wasn't part of the expected output, `sudo` wasn't necessary for this lab.
- The VM's `/var/log` had additional files not present in the lab's reference environment (`apport.log`, `cloud-init.log`, `Xorg.0.log`, etc.). The commands are correct — the difference in output is purely due to environment differences.
