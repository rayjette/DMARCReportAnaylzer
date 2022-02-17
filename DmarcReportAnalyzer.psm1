# Dot source *.ps1 files located in the Public and Private subdirectories
(Get-ChildItem $PSScriptRoot\Public\*.ps1).foreach({ . $_.FullName })
(Get-ChildItem $PSScriptRoot\Private\*.ps1).foreach({ . $_.FullName })