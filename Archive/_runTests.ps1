$file = "$PSScriptRoot"

$container = New-PesterContainer -Path "$PSScriptRoot\*.Tests.ps1" -Data @{ folder = $folders }
Invoke-Pester -Container $container -Output Detailed

Invoke-Pester -Path 'd:\Garry\Repos\PSModules\PSHostFile\Tests'
Invoke-Pester -Path 'd:\Garry\Repos\PSModules\PSHostFile\Tests' -Output 'Detailed'
