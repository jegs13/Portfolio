# Lab 01 — Linux User & Group Management

## Overview

This lab simulates a real-world scenario where a Linux Administrator is tasked with setting up a multi-department server environment from scratch. The goal is to create a secure, organized file system with proper users, groups, directories, and permissions for three newly created departments in a fast-growing company.

---

## Scenario

A company has hired 9 new employees across 3 departments: **Engineering**, **Sales**, and **IS (Information Systems)**. As the Linux Administrator, I was responsible for configuring the server to support these departments with appropriate access controls and data confidentiality.

---

## Objectives

- Create a dedicated directory at the root (`/`) of the file system for each department
- Create a Linux group for each department
- Create one administrative user and two regular users per department, all using Bash as their login shell
- Assign each user their respective department group as their **primary group**
- Configure directory permissions to enforce the following security policy:
  - The department administrator owns the directory and has full access
  - Regular department users have full access (Read, Write, Execute)
  - Only the file owner can delete their own files (Sticky Bit)
  - No access for users outside the department
- Create a confidential document in each department directory:
  - Readable by all department members
  - Only modifiable by the department administrator
  - Inaccessible to everyone else

---

## Environment

| Item | Details |
|---|---|
| OS | Linux (Ubuntu) |
| Shell | Bash (`/bin/bash`) |
| Privilege level | Root |

---

## Implementation

### Step 1 — Create Directories, Groups, and Users

```bash
# Switch to root
su

# Create department directories at /
mkdir Engineering
mkdir Sales
mkdir IS

# Create department groups
groupadd Engineering
groupadd Sales
groupadd IS

# Create admin users (primary group = department group)
useradd -s /bin/bash -g Engineering Engineer1
useradd -s /bin/bash -g Sales Salesperson1
useradd -s /bin/bash -g IS ISperson1

# Create regular users for Engineering
useradd -s /bin/bash -g Engineering Engineer2
useradd -s /bin/bash -g Engineering Engineer3

# Create regular users for Sales
useradd -s /bin/bash -g Sales Salesperson2
useradd -s /bin/bash -g Sales Salesperson3

# Create regular users for IS
useradd -s /bin/bash -g IS ISperson2
useradd -s /bin/bash -g IS ISperson3
```

### Step 2 — Set Directory Permissions

The permission mode `3770` was applied to each directory:

| Bit | Meaning |
|---|---|
| `3` | Setgid (new files inherit the directory's group) + Sticky Bit (only file owners can delete their files) |
| `7` | Owner (admin): Read, Write, Execute |
| `7` | Group (department users): Read, Write, Execute |
| `0` | Others: No access |

```bash
chmod 3770 Engineering
chmod 3770 Sales
chmod 3770 IS
```

### Step 3 — Set Directory Ownership

```bash
chown Engineer1:Engineering Engineering
chown Salesperson1:Sales Sales
chown ISperson1:IS IS
```

### Step 4 — Create Confidential Documents

```bash
echo "This file contains confidential information for the department." > /Engineering/Engineeringdoc.txt
echo "This file contains confidential information for the department." > /Sales/Salesdoc.txt
echo "This file contains confidential information for the department." > /IS/ISdoc.txt
```

### Step 5 — Set File Ownership and Permissions

The permission mode `640` was applied to each file:

| Permission | User | Access |
|---|---|---|
| `6` (`rw-`) | Owner (admin) | Read and Write |
| `4` (`r--`) | Group (department users) | Read only |
| `0` (`---`) | Others | No access |

```bash
# Engineering
chown Engineer1 /Engineering/Engineeringdoc.txt
chmod 640 /Engineering/Engineeringdoc.txt

# Sales
chown Salesperson1 /Sales/Salesdoc.txt
chmod 640 /Sales/Salesdoc.txt

# IS
chown ISperson1 /IS/ISdoc.txt
chmod 640 /IS/ISdoc.txt
```

---

## Verification

### Users created — `grep /etc/passwd`

```bash
grep Engineer /etc/passwd
grep Salesperson /etc/passwd
grep ISperson /etc/passwd
```

All 9 users confirmed with `/bin/bash` shell and correct GID assignments.

### Groups created — `grep /etc/group`

```bash
grep Engineering /etc/group
grep Sales /etc/group
grep IS /etc/group
```

Engineering (GID 1002), Sales (GID 1003), IS (GID 1004) confirmed.

### Group membership per user — `id`

```bash
id Engineer1   # uid=1002 gid=1002(Engineering) groups=1002(Engineering)
id Engineer2   # uid=1005 gid=1002(Engineering) groups=1002(Engineering)
id Engineer3   # uid=1006 gid=1002(Engineering) groups=1002(Engineering)

id Salesperson1  # uid=1003 gid=1003(Sales) groups=1003(Sales)
id Salesperson2  # uid=1007 gid=1003(Sales) groups=1003(Sales)
id Salesperson3  # uid=1008 gid=1003(Sales) groups=1003(Sales)

id ISperson1   # uid=1004 gid=1004(IS) groups=1004(IS)
id ISperson2   # uid=1009 gid=1004(IS) groups=1004(IS)
id ISperson3   # uid=1010 gid=1004(IS) groups=1004(IS)
```

### Directory permissions — `ls -l | grep`

```bash
ls -l / | grep Engineering   # drwxrws--T  Engineer1  Engineering
ls -l / | grep Sales         # drwxrws--T  Salesperson1  Sales
ls -l / | grep IS            # drwxrws--T  ISperson1  IS
```

`drwxrws--T` confirms: full access for owner and group, no access for others, Setgid and Sticky Bit active.

### File permissions — `ls -l`

```bash
ls -l Engineering   # -rw-r----- Engineer1 Engineering Engineeringdoc.txt
ls -l Sales         # -rw-r----- Salesperson1 Sales Salesdoc.txt
ls -l IS            # -rw-r----- ISperson1 IS ISdoc.txt
```

`-rw-r-----` confirms: admin can read/write, department members can read, others have no access.

---

## Security Summary

| Security Requirement | Implementation | Result |
|---|---|---|
| Admin has full access to department directory | `chmod 3770` + `chown admin:group` | ✅ |
| Regular users have full access to department directory | Group permissions set to `rwx` | ✅ |
| Only file owner can delete their own files | Sticky Bit (`T`) enabled | ✅ |
| No access for users outside the department | Others permissions set to `---` | ✅ |
| New files inherit department group automatically | Setgid (`s`) enabled on directories | ✅ |
| Confidential file readable by all department members | File group permissions set to `r--` | ✅ |
| Confidential file only writable by admin | File owner permissions set to `rw-` | ✅ |
| Confidential file inaccessible to others | File others permissions set to `---` | ✅ |

---

## Skills Demonstrated

- Linux user and group administration (`useradd`, `groupadd`)
- File system permission management (`chmod`, `chown`)
- Special permission bits: **Sticky Bit** and **Setgid**
- Reading and interpreting `/etc/passwd` and `/etc/group`
- Applying the principle of **least privilege**
- Verifying system configurations with `id`, `ls -l`, and `grep`
