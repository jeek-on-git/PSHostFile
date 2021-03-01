
Describe "HostFile Tests" {

    Context "Tests - Host File Object" {

        BeforeAll {

            $psdFile = "..\PSHostFile.psd1"


        } # beforeAll

        It 'Test - Specified PSD file exists' {
            Test-Path $psdFile | Should -Be $true
        }

        AfterAll {
            # Set-Location .\Tests
        }

    } # context

}