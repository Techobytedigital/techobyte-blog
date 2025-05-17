---
title: "Backup_restore_wsl"
date: 2025-05-16T01:58:14-04:00
draft: false
tags: []
categories: ["tutorial", "wsl"]
description: ""
author: ""
featured: false
toc: false
---

WSL has a feature that lets you backup your existing installations to a `.tar` file, which you can restore to create clones of an installation. You can, for instance, create a base image of a Debian installation with your user account and some applications you want available on every WSL instance you create from this image, like `wget`, `curl`, and `git`.

## Backup WSL

The command to backup a WSL installation is:

```shell
wsl --export $EXISTING_CONTAINER_NAME C:/path/to/backup/$CONTAINER_NAME.tar
```

This will create a backup of whatever WSL container name you pass for `$EXISTING_CONTAINER_NAME`, at the location you pass after. If you navigate to `C:/path/to/backup/$CONTAINER_NAME.tar`.

For example, if you have a WSL distribution named `debian`, and you want to create a backup at `C:/wsl_backup/debian.tar`:

```shell
wsl --export debian C:/wsl_backup/debian.tar
```

## Restore WSL

Restoring a WSL backup can be used to create "clones" of an existing image, move your WSL installation to other machines, or restore from automated backups you keep of an important WSL installation.

The syntax is similar to the backup command, but in reverse. Restoring requires 3 parameters:

* `distribution`: The type of Linux (Debian, Ubuntu, etc)
* `install location`: The place to restore the WSL machine to, i.e. `c:\wsl`
* `backup path`: Path to the WSL backup

```powershell
wsl --import $NEW_CONTAINER_NAME $NEW_WSL_DATA_DIR C:/path/to/$BCAKUP_NAME.tar
```

For example, to restore a backup named `debian-base.tar` to a new WSL installation named `debian-development` with data at `C:/wsl_machines/debian-development`:

```powershell
wsl --import debian-development C:/wsl_machines/debian-development C:/path/to/debian.tar
```
