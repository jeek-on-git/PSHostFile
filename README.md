# PSHostFile

A PowerShell Module for managing the Windows Host file. It provides a collection of custom functions making it easy to add, remove and update hosts file entries using the familiar PowerShell syntax.

## Overview

The Windows' Hosts file stores 'host entries'; an IP Address and hostname combination that is used by the OS to resolve host names to IP Addresses.

The Host Entry uses a standard text format: `IPAddress Hostname # Comment`. Note, the comment is not mandatory and only the first two parts, `IPAddress` and `HostName` are required.

This module has been tested on both Windows PowerShell (5.1) and PowerShell (7). Given this is modifying the Windows' Hosts file it will not work on Linux or Mac.

### The Basics

Start by installing the module.

```PowerShell
# all users - requires local administrator rights
Install-Module PSHostFile -Scope AllUsers

# current user
Install-Module PSHostFile -Scope CurrentUser
```

Import the module for use

```PowerShell
# import the module
Import-Module PSHostFile
```

Get the module's details.

```PowerShell
Get-Module PSHostFile
```

List all of the module's commands.

```PowerShell
Get-Command -Module PSHostFile
```

To remove the module, run the following,

```PowerShell
Get-Module PSHostFile | Remove-Module
Uninstall-Module PSHostFile -AllVersions -Confirm:$false
```

## Getting Started

Start by loading the Hosts file into memory and creating a `HostFileObject` object using the `Get-HostFile` command.

```PowerShell
Get-HostFile

# or use the alias
ghf
```

> This creates two script level variables, `$hostFile` and `$hostFileObject`.

The `$hostFile` variable holds the the path to the currently loaded host file. By default this is the host file located in the `C:\Windows\System32\Drivers\etc directory`, however, you can specify a different hosts file, e.g. `\\server\C$\System32\Drivers\etc\hosts`.

```PowerShell
# get the current 'HostFilePath'
Get-HostFilePath
```

The `$hostFileObject` variable is the custom PowerShell Object representing the Windows Hosts file. This is what gets modified when updating, adding or removing entries via the various commands. Once all changes are complete then they are saved (written) back to the Hosts file using the `Save-HostFileObject` command.

```PowerShell
# get the current 'HostFileObject'
Get-HostFileObject
```

You can see the value of either variables by using the `Get-HostFileVariable` command and specifying the variable name. However, `Get-HostFile` and `Get-HostFilePath` will do the same thing as `Get-HostFileVariable hostFileObject`.

```PowerShell
 Get-HostFileVariable hostFile
 Get-HostFileVariable hostFileObject
```

You can run the `Get-HostFile` command at any time to view the state of the `$hostFileObject`, and this is great way to view any changes that have been made. Changes aren't committed until they have been written back to the file. If you do make a mistake and want to start again, then use the `Clear-HostFileObject` to clear to `$hostFileObject`.

```PowerShell
# Clear the 'HostFileObject' and then reload it.
Clear-HostFileObject
Get-HostFile
```

If you want to load a custom hosts file then use the `New-HostFilePath` command with the `-hostFilePath` parameter and specify the path to an alternate hosts file. Then run the `Get-HostFile` or `New-HostFileObject` command.

```PowerShell
# this specifies a 'hosts' file from the '.\HostFile\hosts' file in the HostFile module directory.
New-HostFilePath -hostFilePath "C:\Program Files\PowerShell\Modules\HostFile\Files\hosts"

# which is then loaded when the Get-HostFile command is run
Get-HostFile
```

## `EntryType`

When the hosts file is loaded, each line of the file is read and designated an `EntryType` based on pattern of the text.

There are 5 different Entry Types (`EntryType`) defined, these are;

`Header`: The first 22 rows of the host file are flagged as a `Header` Type; any line that starts with a "*# text*". This allows for the 'Header' information of the hosts file to be preserved.

`Comment` : This is the same as the Header type, using the same "# *text*" pattern, however, anything after the 22nd row is flagged as a comment. This allows for inline comments to be add and/or removed.

`Blank` : This is a Blank line and is used to preserve spacing. Blank lines can also be added and/or removed as necessary.

`HostEntry` : This is the IPAddress and the Hostname entry. It may also contain a "# *comment*" at the end of the line.

`Commented` : Any HostEntry line that has been "commented out" and starts with "# *IPAddress*", i.e. `"# 192.168.0.1    hostname    # comment"`

This is an example of a `HostFileObject` object after being loaded. As this is a PowerShell object it makes it very easy to filter, add, remove and modify entries.

In addition to the `EntryType` property a `Line` number is added. This makes selecting specific lines very easy.

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

## Commands

The commands have been logically grouped. Use the Get-Help to get further details and examples.

Typically when working with the host file your workflow will follow a similar pattern

+ Load the hosts file
+ View, and filter, the hosts file entries
+ Modify (Add, Remove or Update) the hosts file entries
+ Backup the hosts file
+ Save changes back to the hosts file

### Managing host file object

Use the following set of commands to manage the `$hostFileObject`.

|Command|Description|
|-----|-----|
|`Get-HostFile (Get-HostFileObject)`|Gets the `HostFileObject`. Will also create it if it doesn't exist|
|`New-HostFileObject`|Creates a new HostFileObject|
|`Clear-HostFileObject`|Clears the HostFileObject|
|`Save-HostFileObject`|Saves the HostFileObject, and any changes, back to disk|
|||

### Managing host file entries

Use the following set of commands to add, remove, and update host file entries.

|Command|Description|
|-----|-----|
|`Get-HostFileEntry`|Returns the specified `HostFileEntry`|
|`New-HostFileEntry`|Creates a new `HostFileEntry` object. Used for adding and/or removing a host file entry|
|`Add-HostFileEntry`|Adds a new `HostFileEntry` to the `HostFileObject`.|
|`Remove-HostFileEntry`|Removes the specified `HostFileEntry` from the `hostFileObject`|
|`Set-HostFileEntry`|Modifies the specified `HostFileEntry`|
|`Clear-HostFileEntry`|Clears all Host File Entries, i.e. removes everything except the header information|
|||

### Managing the Hosts File

The following set of commands are used to manage the Host File.

|Command|Description|
|-----|-----|
|`Get-HostFileBackups`|Returns a list of Hosts file backups from the specified directory.|
|`Backup-HostFile`|Backs up (copies) the Hosts file|
|`Restore-HostFile`|Restores the specified Hosts file from backup|
|||

### Managing Host File Variables

The following set of commands are used to manage the Host File variables.

|Command|Description|
|-----|-----|
|`Test-HostFileVariable`|Returns a `$true` or `$false` for the specified variable |
|`Clear-HostFilePath`|Clears the `$hostFilePath` variable|
|`Get-HostFilePath`|Returns the `$hostFilePath` variable|
|`New-HostFilePath`|Creates a new `$hostFilePath` variable|
|`Get-HostFileVariable`|Returns the `$hostFilePath` variable|
|||

### Hidden

Hidden commands

|Command|Description|
|-----|-----|
|`New-FileName`|Creates a new file 'name' used for renaming a file|
|`Get-HostFileLineType`|Returns the 'line' type|
|`Get-HostFileEntryType`|Returns the `HostFileObject`'s type|
|`Convert-HostFileObjectToString`|Coverts a `HostFileObject` to a String|
|`New-HostFileLineObject`|Creates a new Host File Entry `[HostFile]`|
|`Convert-StringToBlank`|Converts a string to `HostFile` Object EntryType `Blank`|
|`Convert-StringToComment`|Converts a string to `HostFile` Object EntryType `Comment`|
|`Convert-StringToCommented`|Converts a string to `HostFile` Object EntryType `Commented`|
|`Convert-StringToHeader`|Converts a string to `HostFile` Object EntryType `Header`|
|`Convert-StringToHostEntry`|Converts a string to `HostFile` Object EntryType `HostEntry`|
|`Test-IsAdmin`|Test is the current user in a local administrator|
|||

### Filtering
Because the host file is now an PowerShell Object, filtering becomes very easy.

Use the `Get-HostFileEntry` command.

```PowerShell
# get the lines 30 to 32
30..32 | foreach { Get-HostFileEntry -line $_ }

# get line 23 of the hosts file
Get-HostFileEntry -line 23

# get all hosts file entry that have the specified IP Address
Get-HostFileEntry -ipAddress 192.168.0.1

# get all hosts file entry that have the specified hostname
Get-HostFileEntry -hostname test
```

In addition, you can filter the resutls from the `Get-HostFile`

```PowerShell
# this will filter entries by on the EntryType equaling 'HostEntry'
Get-HostFile | Where-Object EntryType -eq 'HostEntry'

# this will filter entries by on the EntryType equaling 'Commented'
Get-HostFile | Where-Object EntryType -eq 'Commented'

# this will filter entries and return the specific line number
Get-HostFile | Where-Object Line -eq 24

# this will match the '2\d' (number 2 followed by any digits) pattern, i.e 20 through to 29.
Get-HostFile | Where-Object line -match '2\d'

# select the last line
Get-HostFile | Select-Object -Last 1

# this will join the specified numbers using the regex and/or (the pipe "|" symbol)
# and will match the line against the specified numbers
$lines = '21','23','25','26' -join '|'
Get-HostFile | Where-Object line -match $lines
```

## Modifying

There are a couple of ways to update, add and remove entries.

The first is by creating a custom "Host File Entry" object using the `New-HostFileEntry` command. The result of this command is used to add a new entry to the `$HostFileObject`. This is used in combination with the `Add-HostFileEntry`.

### Add Host Entry

There are a number of ways to add entries.

```PowerShell
# this creates a new Host File Entry
$entry = New-HostFileEntry -entryType HostEntry -ipAddress 192.168.1.1 -hostname router -comment 'Comment'

# then add the $entry using the Add-HostFileEntry command.
Add-HostFileEntry -hostFileEntry $entry

# or just pipe the results to the `Add-HostFileEntry` command
New-HostFileEntry -entryType HostEntry -ipAddress 192.168.1.1 -hostname router -comment 'Comment' | Add-HostFileEntry

# or pass the $entry to the Add-HostFileEntry command via pipeline.
$entry | Add-HostFileEntry

# adding a blank line
$blank = New-HostFileEntry -entryType Blank
Add-HostFileEntry $blank
```

By default, when adding a new entry it will be appended to the end of the `$hostFileObject`. If you want to add an entry at specific line you will first need to remove all entries, including the line where you wish to insert the new row, add the line you want and then add back all of the removed entries. This is very simple to do.

In this example, we want to add a new line at line 32 of a 50 line hosts file. Start by selecting all entries from line 32 to the end, remove them all, add the new line and then add the removed entries back.

```PowerShell
# in this example the hosts file has 50 entries. We want to add an entry to line 32. Select all entries, including line 32.
# select those entries to be removed; the last 18 entries are being selected.
$temp = Get-HostFile | select -Last 18

# remove the selected entries.
$temp | Remove-HostFileEntry

# confirm they are gone.
Get-HostFile

# add the new entry
$entry = New-HostFileEntry -entryType HostEntry -ipAddress 192.168.1.1 -hostname 'router' -comment 'Comment'
$entry | Add-HostFileEntry

# add the removed entries back
$temp | Add-HostFileEntry

# confirm they are all back
Get-HostFile
```

The newly created `$entry` is now line 32.

## Remove Host Entry

Removing entries is just as easy

```PowerShell
# this will remove all entries that equal the specific line number
$entry = Get-HostFileEntry -lineNumber 26
Remove-HostFileEntry -hostFileEntry $entry

# this will remove all entries that equal the specific line number
Get-HostFile | Where-Object Line -eq 26 | Remove-HostFileEntry

# this will remove all entries that equal the specified hostname
$entry = Get-HostFile | Where-Object Hostname -eq 'server'
Remove-HostFileEntry -hostFileEntry $entry

# this will remove all entries that equal the specified IP Address
$entry = Get-HostFile | Where-Object IPAddress -eq '192.168.0.1'
$entry | Remove-HostFileEntry

# this will remove all entries that equal the 'EntryType' of 'HostEntry'
Get-HostFile | Where-Object EntryType -eq 'HostEntry' | Remove-HostFileEntry

# This will remove the last entry from the hostfile
Get-HostFile | Select-Object -Last 1 | Remove-HostFileEntry

# you can use the `New-HostFileEntry` command to create a new `HostFileEnty`, however, the need to be exact.
$entry = New-HostFileEntry -entryType HostEntry -ipAddress 192.168.1.1 -hostname 'router' -comment 'Comment'
$entry | Remove-HostFileEntry

```

## Clear All Host Entries

If you want to remove all entries in one go then use the `Clear-HostFileEntry` command.

```PowerShell
# this will remove all entries, excluding the 'header' rows.
Clear-HostFileEntry
```

## Update Host Entry

Updating an existing entry.

```PowerShell
# Comment out an entry
Get-HostFileEntry 26 | Update-HostFileEntry -commented

# Select the line number you want to modify and update its IPAddress and Hostname
Get-HostFileEntry 35 | Update-HostFileEntry -ipAddress 192.168.1.11 -hostname Server2

# select an entry to modify
$entry = Get-HostFile | select -Last 1

# modify the hostname
$entry.Hostname = 'router1'

# modify the IPAddress
$entry.IPAddress = '192.168.2.2'
```

## Backing up and Restoring

`Backup-HostFile`

Backs up the HostFile.
## Restoring

`Restore-HostFile`

A command to restore the HostFile from backup. To be implemented.
