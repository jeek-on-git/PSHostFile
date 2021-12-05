BeforeAll {

    Import-Module D:\Garry\Repos\Modules\HostFile\HostFile.psd1 -Force
    # New-HostFilePath -hostFilePath "$env:PSModulePath\HostFile\Files\Hosts"
    # $file = 'C:\Windows\System32\Drivers\etc\hosts'
    Clear-HostFileObject
    Clear-HostFilePath

    $file = "D:\Garry\Repos\Modules\HostFile\Files\hosts"
    New-HostFilePath $file
    Get-HostFile

} # beforeAll

Describe "HostFile Tests" {

    Context "Tests - Host File Path" {

        It "Test - Host File Path - Default Path" {
            New-HostFilePath
            Get-HostFilePath | Should -Be 'C:\Windows\System32\Drivers\etc\hosts'
        }
        It "Test - Host File Path - Specified Path" {
            $path = "D:\Garry\Repos\Modules\HostFile\Files\hosts"
            New-HostFilePath -hostFilePath $path
            Get-HostFilePath | Should -Be $path
        }
        AfterEach {
            Clear-HostFileObject
            Clear-HostFilePath
        }

    } # context

    Context "Tests - Host File Object" {
        BeforeAll {
            Clear-HostFileObject
            $file = "D:\Garry\Repos\Modules\HostFile\Files\hosts"
            New-HostFilePath $file
            Get-HostFile
        }
        It "Test - 'HostFileObject' variable is [HostFile]" {
            Get-HostFile | get-member | Select-Object -ExpandProperty TypeName -Unique | Should -Be 'HostFile'
        }
        It "Test - Contains 'Header'" -foreach $(Get-HostFile | Select-Object -First 22) {
            $_.EntryType | Should -Be 'Header'
        }
        It "Test - First 22 Entries Should Not Match EntryType" -foreach $(Get-HostFile | Select-Object -First 22 | Get-HostFileEntryType -diag) {
            $_.Entry -Match $_.EntryType | Should -Be $false
        }
        It "Test - Entry Should Match EntryType" -foreach $(Get-HostFile | Select-Object -Skip 22 | Get-HostFileEntryType -diag) {
            $_.Entry -Match $_.EntryType | Should -Be $true
        }
    }

    Context "Tests - Get-HostFileLineType" {
        BeforeEach {
            $strings = @{
                Blank = @(
                ''
                ' '
                '  '
                '   '
                '    '
                ""
                " "
                "  "
                "   "
                "    "
                )
                Commented = @(
                    '# 127.0.0.1'
                    '# 10.21.21.21   server.local'
                    )
                Comment =@(
                    '#'
                    '# '
                    '#  '
                    '#   '
                    '# ::1'
                    '# text'
                    '# text text'
                )
                HostEntry =@(
                    '10.10.10.10'
                    '0.0.0.0'
                    '192.168.0.0'
                    '172.16.0.0'
                )
            }
        } # beforeEach

        It "Test - Get-HostFileLineType Strings" {
            $strings.GetEnumerator() | ForEach-Object {
                $name = $_.Key
                foreach ($item in $strings.$name) {
                    Get-HostFileLineType $item | Should -Be $name
                }
            }
        }

    }

    Context "Tests - New-HostFileEntry" {
        It "Test - New-HostFileEntry 'HostEntry'" {
            $entry = New-HostFileEntry -ipAddress 10.10.10.10 -hostname server
            $entry | Get-HostFileEntryType | Should -Be 'HostEntry'
        }
        It "Test - New-HostFileEntry 'Commented'" {
            $entry = New-HostFileEntry -ipAddress 10.10.10.10 -hostname server -commented
            $entry | Get-HostFileEntryType | Should -Be 'Commented'
        }
    }

    Context "Tests - Set-HostFileEntry" {
        It "Test - Set-HostFileEntry 'Commented'" {
            Get-HostFileEntry 34 | Set-HostFileEntry -commented
            Get-HostFileEntry 34 | Get-HostFileEntryType | Should -be 'Commented'
        }
        It "Test - Set-HostFileEntry 'IPAddress'" {
            Get-HostFileEntry 34 | Set-HostFileEntry -ipAddress '10.10.10.10'
            (Get-HostFileEntry 34).IPAddress | Should -be '10.10.10.10'
        }
        It "Test - Set-HostFileEntry 'HostName'" {
            Get-HostFileEntry 34 | Set-HostFileEntry -hostname 'TestHostName'
            (Get-HostFileEntry 34).HostName | Should -be 'TestHostName'
        }
        It "Test - Set-HostFileEntry 'Comment'" {
            Get-HostFileEntry 34 | Set-HostFileEntry -comment 'Test Comment'
            (Get-HostFileEntry 34).Comment | Should -be 'Test Comment'
        }
    }

    Context "Tests - Remove-HostFileEntry" {
        It "Test - Remove-HostFileEntry via Pipeline" {
            $entry = Get-HostFileEntry 26
            $null = $entry | Remove-HostFileEntry
            $(Get-HostFile) -contains $entry | Should -Be $false
        }
        It "Test - New-HostFileEntry via Parameter" {
            $entry = Get-HostFileEntry 26
            $null = Remove-HostFileEntry -hostFileEntry $entry
            $(Get-HostFile) -contains $entry | Should -Be $false
        }
    }

    Context "Tests - Clear-HostFileEntry" {
        It "Test - Clear-HostFileEntry - Clears Host Entries" {
            Clear-HostFileEntry
            Get-HostFile | Measure-Object -Property LineNumber | Select-Object -ExpandProperty Count | Should -Be 22
        }

    }

}