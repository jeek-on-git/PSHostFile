# HostFile

A PowerShell Module for managing the Windows Host file.

The Hosts file stores 'host entries', an IP Address and hostname combination that is used by the local computer to resolve hostnames to IP Addresses.

It uses a standard text format: `IPAddress Hostname Comment`. Note, the comment is not mandatory and only the first two parts are required.

## Table of Contents

+ [Overview](#Overview)
+ [Installing](#Installing)
+ [Uninstalling](#Uninstalling)
+ [Commands](#Commands)

## Overview
This module provides an easy way to manage the Windows Hosts file using PowerShell. It provides a collection of custom functions for adding, removing and updating host file entries using the familiar PowerShell syntax.

## Installing

Start by installing the module.

```PowerShell
# all users - requires local administrator rights
Import-Module HostFile

# current user
Import-Module HostFile -Scope AllUsers
```

Get the module's details.

```PowerShell
Get-Module HostFile
```

List all of the module's commands.

```PowerShell
Get-Command -Module HostFile
```

## Uninstalling

To remove the module, run the following,

```PowerShell
Get-Module HostFile | Remove-Module
Uninstall-Module HostFile -AllVersions -Confirm:$false
```

# Getting Started (Overview)

To get started, create a "host file object" using the `Get-HostFile` command. This will load the Hosts file and turn it into an custom PowerShell object.

```PowerShell
Get-Host

# or use the alias
ghf
```

This creates two variables script level variables, `$hostFile` and `$hostFileObject`.

The `$hostFile` variable holds the the path to the currently loaded host file. By default this is Windows host file located in the `C:\Windows\System32\Drivers\etc directory`, however, you can specify a different hosts file, e.g. `\\server\C$\System32\Drivers\etc directory`.

The `$hostFileObject` variable is the custom PowerShell Object `[HostFile]` representing the Windows 'Hosts' file. This is what gets modified when updating, adding or removing entries via the various commands. Once all changes are complete then they are saved (written) back to the Hosts file using the `Save-HostFileObject` command.

You can see the value of either of these two variables by using the `Get-HostFileVariable` command and specifying the variable name. However, `Get-HostFile` will do the same thing as `Get-HostFileVariable hostFileObject`.

```PowerShell
 Get-HostFileVariable hostFile
 Get-HostFileVariable hostFileObject
```

You can run the `Get-HostFile` command at any time to view the state of the `$hostFileObject`, and it is great way to view any changes that have been made.

If you want to load a custom hosts file then use the `New-HostFilePath` command with the `-hostFilePath` parameter and specify the path to an alternate hosts file. Then run the `Get-HostFile` or `New-HostFileObject` command.

```PowerShell
# this loads the testing 'hosts' file from the '.\HostFile\hosts' file in the HostFile module directory.
New-HostFilePath -hostFilePath "C:\Program Files\PowerShell\Modules\HostFile\Files\hosts"
```

## `EntryType`

When the hosts file is loaded, each line of the file is read and designated an 'Entry Type' based on pattern of the line (text).

There are 5 different Entry Types (`EntryType`) defined, these are;

`Header`: The first 22 rows of the host file are flagged as a `Header` Type; any line that starts with a "*# text*". This allows for the 'Header' information of the hosts file to be preserved.

`Comment` : This is the same as the Header type, using the same "# *text*" pattern, however, anything after the 22nd row is flagged as a comment. This allows for inline comments to be add and/or removed.

`Blank` : This is a Blank line and is used to preserve spacing. Blank lines can also be added and/or removed as necessary.

`HostEntry` : This is the IPAddress and the Hostname entry. It may also contains a "# *comment*" at the end of the line.

`Commented` : Any HostEntry line that has been commented out and starts with "# *IPAddress*", i.e. `"# 192.168.0.1    hostname    # comment"`

This is an example of a `HostFileObject` object after being loaded. As this is a PowerShell object it makes it very easy to filter, add, remove and modify entries.

In addition to the `EntryType` property a `Line` number property is also added. This makes selecting specific lines very easy.

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

## Tasks

Provides an overview
Use the Get-Help to get further details and examples.

Typically when working with the host file your workflow will follow a similar pattern

+ Load the hosts file
+ View, and filter, the hosts file entries
+ Modify (Add, Remove or Update) the hosts file entries
+ Backup the hosts file
+ Save any changes back to the hosts file

### Managing host file object

Use the following set of commands to manage the `$hostFileObject`.

|Command|Description|
|-----|-----|
|`Get-HostFile (Get-HostFileObject)`|Gets the `HostFileObject`. Will also create it if it doesn't exist|
|`New-HostFileObject`|Creates a new HostFileObject|
|`Clear-HostFileObject`|Clears the HostFileObject|
|`Save-HostFileObject`|Saves the HostFileObject|
|||

### Managing host file entries

Use the following set of commands to add, remoe, and update host file entries.

|Command|Description|
|-----|-----|
|`Get-HostFileEntry`|Returns the specified `HostFileEntry`|
|`New-HostFileEntry`|Creates a new `HostFileEntry` object. Used for adding and/or removing a host entry|
|`Add-HostFileEntry`|Adds a new `HostFileEntry` to the `HostFileObject`.|
|`Remove-HostFileEntry`|Removes the specified `HostFileEntry`|
|`Set-HostFileEntry`|Modifies the specified `HostFileEntry`|
|`Clear-HostFileEntry`|Clears all Host File Entries|
|||

### Managing the Hosts File

The following set of commands are used to manage the Host File.

|Command|Description|
|-----|-----|
|`Get-HostFileBackups`|Returns a list of Hosts file backups from the specified directory.|
|`Backup-HostFile`|Backs up (Copies) the Hosts file|
|`Restore-HostFile`|Restores the specified Hosts file from backup|
|||

### Managing Host File Variables

The following set of commands are used to manage the Host File variables.

|Command|Description|
|-----|-----|
|`Test-HostFileVariable`|Returns the specified variable |
|`Clear-HostFilePath`|Clears the `$hostFilePath` variable|
|`Get-HostFilePath`|Returns the `$hostFilePath` variable|
|`New-HostFilePath`|Creates a new `$hostFilePath` variable|
|`Get-HostFileVariable`|Returns the `$hostFilePath` variable|

### Hidden

|Command|Description|
|-----|-----|
|`New-FileName`|Creates a new 'name' used for renaming a file|
|`Get-HostFileLineType`|Returns the 'line' type|
|`Convert-HostFileObjectToString`|Coverts a `HostFileEntry` to a String|
|`New-HostFileLineObject`|Creates a new Host File Entry `[HostFile]`|
|`Test-IsAdmin`|Test is the current user in a local administrator|
|`Test-Variable`|Tests is variable exists|
|||

### Filtering
Because the host file is now an PowerShell Object, filtering becomes very easy.

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

In addition to filtering the `$hostFileObject`, you can also use the `Get-HostFileEntry` command, which is just a wrapper for the above commands.
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

## Modifying

There are a couple of ways to update, add and remove entries.

The first is by creating a custom "Host File Entry" using the `New-HostFileEntry` command. The result of this command can be used to either add or remove entries from the `$HostFileObject`.

### Add Host Entry

There are a number of ways to add entries.

```PowerShell
# this creates a new Host File Entry
$entry = New-HostFileEntry -entryType HostEntry -ipAddress 192.168.1.1 -hostname router -comment 'Comment'

# or
New-HostFileEntry -entryType HostEntry -ipAddress 192.168.1.1 -hostname router -comment 'Comment' | Add-HostFileEntry

# then add the $entry using the Add-HostFileEntry command.
Add-HostFileEntry -hostFileEntry $entry

# or pass the $entry to the Add-HostFileEntry command via pipeline.
$entry | Add-HostFileEntry

# adding a blank line
$blank = New-HostFileEntry -entryType Blank
Add-HostFileEntry $blank
```

By default, when adding a new entry it will be appended to the end of the `$hostFileObject`. If you want to add an entry at specific line you will first need to remove all entries, including the line you wish to replace, add the line you want and then add back all of the removed entries. This is very simple to do.

In this example, we want to add a new line at line 32. Start by selecting all entries from line 32 to the end, remove them all, add the new line and then add the removed entries back.

```PowerShell
# in this example the hosts file has 50 entries. We want to add an entry to line 32. Select all entries, including line 32.
# select those entries to be removed; the last 18 entries are being selected.
$temp = Get-HostFile | select -Last 18

# remove the selected entries.
$temp | Remove-HostFileEntry

# confirm they are gone.
Get-HostFile

# add the new entry
$entry = New-HostFileEntry -entryType HostEntry -ipAddress 192.168.1.1 -hostname router -comment 'Comment'
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
# this will remove all entries that equal the specified hostname
$entry = Get-HostFile | Where-Object Hostname -eq 'server'
Remove-HostFileEntry -hostFileEntry $entry

$entry = Get-HostFileEntry
Remove-HostFileEntry -hostFileEntry $entry

# this will remove all entries that equal the specified IP Address
$entry = Get-HostFile | Where-Object IPAddress -eq '192.168.0.1'
$entry | Remove-HostFileEntry

# this will remove all entries that equal the 'EntryType' of 'HostEntry'
Get-HostFile | Where-Object EntryType -eq 'HostEntry' | Remove-HostFileEntry

# this will remove all entries that equal the specific line number
Get-HostFile | Where-Object Line -eq 24 | Remove-HostFileEntry

# This will remove the last entry from the hostfile
Get-HostFile | Select-Object -Last 1 | Remove-HostFileEntry
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
`Import-Module HostFile`


## Backing up and Restoring


`Get-Module HostFile`

## Restoring

`Get-Command -Module HostFile`

## Commands

Get-HostFileObject

Returns the Windows Host File Object.

Add-HostFileEntry
Clear-HostFileEntry
Clear-HostFileObject
Clear-HostFilePath
Convert-HostFileObjectToString
Get-HostFile
Get-HostFileEntry
Get-HostFileLineType
Get-HostFilePath
Get-HostFileVariable
New-FileName
New-HostFileEntry
New-HostFileLineObject
New-HostFileObject
New-HostFilePath
Remove-HostFileEntry
Restore-HostFile
Save-HostFileObject
Set-HostFileEntry
Test-HostFileVariable
Test-IsAdmin
Test-Variable
Update-HostFileObject

