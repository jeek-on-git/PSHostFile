Describe "HostFile Tests" {
    Context "Tests - Host File Object" {
        BeforeAll {
            $psdFile = "..\PSHostFile.psd1"
            $root = ([System.IO.FileInfo]$PSScriptRoot).Directory.FullName
            $psdFile = Join-Path $root "PSHostFile.psd1"
        }

        It 'Test - Specified PSD file exists' {
            Test-Path $psdFile | Should -Be $true
        }

        AfterAll {
        }
    }
}