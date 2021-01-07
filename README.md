# HostFile

A PowerShell Module for managing the Windows Host file.

## Table of Contents

+ [Overview](#Overview)
+ [Installing](#Installing)
+ [Uninstalling](#Uninstalling)
+ [Commands](#Commands)

## Overview

This module provides an easy way to manage the Windows 'hosts' file using PowerShell. It provides a collection of custom functions adding, removing and updating entries in the Windows 'hosts' file.

## Installing

Start by installing the module.

```PowerShell
# all users - requires local administrator rights
Import-Module HostFile

# current user
Import-Module HostFile -Scope AllUsers
```

Get the modules details.

```PowerShell
Get-Module HostFile
```

List all of the module's commands.

```PowerShell
Get-Command -Module HostFile
```

## Uninstalling

To remove the module from your system you can easily uninstall it using the following PowerShell command.

```PowerShell
Get-Module HostFile | Remove-Module
Uninstall-Module HostFile -AllVersions -Confirm:$false
```

# Getting Started (Overview)

Start by creating a host file object and running the `Get-HostFile` command. This will load the host file into memory and create two global variables `$hostFile` and `$hostFileObject`.

`$hostFile` is the path to the current host file loaded into memory.

+ By default the Windows host file is selected, however, you can specify a different hosts file.

The `$hostFileObject` variable is the custom PSObject `[HostFile]` representing the Windows 'Hosts' file. This is what gets modified when setting, adding or removing entries via the `Add-HostFileEntry` and `Remove-HostFileEntry` commands.

You can run the `Get-HostFile` command at any time to view the state of the `$hostFileObject`; especially if you make any a change and you want to see the result.

If you want to load a custom hosts file then use the `Get-HostFileObject` command with the `-hostFilePath` parameter and specify the path to the hosts file. The `Get-HostFile` command calls the `Get-HostFileObject` command in the background but allows you to specify an alternate hosts file.

## `EntryType`

When the hosts file is loaded, each line is read and then designated an 'Entry Type' based on pattern of the line. There are 5 Entry Types (`EntryType`). These are defined as;

`Header`: The first 21 rows of the host file are flagged as a `Header` Type; any line that starts with a "*# text*". This allows for the 'Header' information of the hosts file to be preserved.

`Comment` : This is the same as the Header type, using the same "# *text*" pattern, however, anything after the 21st row is flagged as a comment. This allows for comments to be add to file.

`Blank` : This is a Blank line and is used to preserve spacing. Blank lines can also be added and/or removed.

`HostEntry` : This is the IPAddress and the Hostname entry. This may also contains a "# *comment*" at the end of the line.

`Commented` : Any HostEntry line that has been commented out and starts with "# *IPAddress*", i.e. `"# 192.168.0.1    hostname    # comment"`

This is the resulting `HostFileObject` object after being loaded. As this is a PowerShell object it makes it very easy to filter, add and remove entries.

In addition to the `EntryType` property a `Line` number property is also added.

```PowerShell
Line EntryType IPAddress        Hostname          Comment
---- --------- ---------        --------          -------
   0 Header                                       # Copyright (c) 1993-2009 Microsoft Corp.
   1 Header                                       #
   2 Header                                       # This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
   3 Header                                       #
   4 Header                                       # This file contains the mappings of IP addresses to host names. Each
   5 Header                                       # entry should be kept on an individual line. The IP address should
   6 Header                                       # be placed in the first column followed by the corresponding host name.
   7 Header                                       # The IP address and the host name should be separated by at least one
   8 Header                                       # space.
   9 Header                                       #
  10 Header                                       # Additionally, comments (such as these) may be inserted on individual
  11 Header                                       # lines or following the machine name denoted by a '#' symbol.
  12 Header                                       #
  13 Header                                       # For example:
  14 Header                                       #
  15 Header                                       #      102.54.94.97     rhino.acme.com          # source server
  16 Header                                       #       38.25.63.10     x.acme.com              # x client host
  17 Blank
  18 Header                                       # localhost name resolution is handled within DNS itself.
  19 Header                                       #     127.0.0.1       localhost
  20 Header                                       #     ::1             localhost
  21 Blank
  22 Comment                                      # Hash space comment
  23 Comment                                      # hash comment
  24 HostEntry 192.168.100.10   server.host.local
  25 HostEntry 192.168.100.10   server.host.local # comment
  26 HostEntry 192.168.100.10   server
  27 HostEntry 192.168.100.10   server            # comment
  28 Blank
  29 Comment                                      # comment
  30 Blank
  31 Commented # 192.168.100.10 server.host.local
  32 Commented # 192.168.100.10 server.host.local # comment
  33 Commented # 192.168.100.10 server
  34 Commented # 192.168.100.10 server            # comment
```
## Filtering
Because the host file is now an PowerShell Object, filtering becomes very easy.

```PowerShell
# this will filter entries by on the EntryType equaling 'HostEntry'
Get-HostFile | Where-Object EntryType -eq 'HostEntry'

# this will filter entries by on the EntryType equaling 'Commented'
Get-HostFile | Where-Object EntryType -eq 'Commented'

# this will filter entries and return the specific line number
Get-HostFile | Where-Object Line -eq 24

# this will match the '2\d' (number 2 followed by any digits) pattern
Get-HostFile | Where-Object line -match '2\d'

# select the last line
Get-HostFile | Select-Object -Last 1

# this will join the specified numbers using the regex and/or (the pipe "|" symbol) and will match the line against the specified numbers
$lines = '21','23','25','26' -join '|'
Get-HostFile | Where-Object line -match $lines
```

## A new [HostFile] object

There are a couple of ways to add and remove entries.
The first is by creating a `[HostFile]` object using the `New-HostFileEntry` command. This can be used to add and remove entries from the `$HostFileObject`.

Start by creating a `[HostFile]` object.

### Adding

There are a number of ways to add entries.

```PowerShell
# this creates a HostFile object
$entry = New-HostFileEntry -entryType HostEntry -ipAddress 192.168.1.1 -hostname router -comment 'Comment'

# then add the $entry using the Add-HostFileEntry command.
Add-HostFileEntry -hostFileEntry $entry

# or pass the $entry to the Add-HostFileEntry command via pipeline.
$entry | Add-HostFileEntry

# adding a blank line
$blank = New-HostFileEntry -entryType Blank
Add-HostFileEntry $blank
```

By default, when adding a new entry it will be appended to the end of the `$hostFileObject`. If you want to add an entry at specific spot you first need to remove all entries from the specific line, add the new line, then add back the removed entries. This is very simple to do.

In this example, we want to add a new line at line 32. Start by selecting all entries from line 32 to the end. Next, remove them all, add the new line and then add the removed entries back.
```PowerShell
# in this example the hosts file has 50 entries. We want to add an entry to line 32. Select all entries, including line 32.
# select those entries to be removed. the last 18 entries are being selected.
$temp = Get-HostFile | select -Last 18

# remove the selected entries.
$temp | Remove-HostFileEntry

# confirm they are gone.
Get-HostFile

# add the new entry
$entry | Add-HostFileEntry

# add the removed entries back
$temp | Add-HostFileEntry

# confirm they are all back
Get-HostFile
```

## Removing

```PowerShell

# this will remove all entries that equal the specified hostname
$entry = Get-HostFile | Where-Object Hostname -eq 'server'
Remove-HostFileEntry -hostFileEntry $entry

# this will remove all entries that equal the specified IP Address
$entry = Get-HostFile | Where-Object IPAddress -eq '192.168.0.1'
$entry | Remove-HostFileEntry

# this will remove all entries that equal the 'EntryType' of 'HostEntry'
Get-HostFile | Where-Object EntryType -eq 'HostEntry' | Remove-HostFileEntry

# this will remove all entries that equal the specific line number
Get-HostFile | Where-Object Line -eq 24 | Remove-HostFileEntry

# This will remove the last entry
Get-HostFile | Select-Object -Last 1 | Remove-HostFileEntry
```

## Updating

Updating an existing entry

```PowerShell
# Select the line number you want to modify and update its IPAddress and Hostname
Get-HostFile | Where-Object line -eq 35 | Update-HostFileEntry -ipAddress 192.168.1.11 -hostname Server2
Get-HostFile | Select-Object | Update-HostFileEntry -ipAddress 192.168.1.11 -hostname Server2

# select an entry to modify
$entry = Get-HostFile | select -Last 1

# modify the hostname
$entry.Hostname = 'router1'

# modify the IPAddress
$entry.IPAddress = '192.168.2.2'
```


## Backing up and Restoring

## Restoring

