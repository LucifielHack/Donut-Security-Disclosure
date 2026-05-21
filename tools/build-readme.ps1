$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$SourceDir = Join-Path $RepoRoot 'docs\zh-CN'
$HeaderPath = Join-Path $SourceDir '_readme-header.md'
$ManifestPath = Join-Path $SourceDir '_manifest.csv'
$ReadmePath = Join-Path $RepoRoot 'README.md'
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$Lf = [string][char]10
$CrLf = ([string][char]13) + ([string][char]10)

function Read-TextFile([string]$Path) {
  return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF)
}

function Write-TextFile([string]$Path, [string]$Text) {
  [System.IO.File]::WriteAllText($Path, $Text, $Utf8NoBom)
}

function Normalize-ModuleFile([string]$Path) {
  $text = Read-TextFile $Path
  $text = $text.Replace($CrLf, $Lf)
  $text = [regex]::Replace($text, '(?s)\n---\n\s*---\n\s*(\[[^\]]+\]\(\.\./\.\./README\.md\))\s*$', ($Lf + '---' + $Lf + $Lf + '$1' + $Lf))
  Write-TextFile $Path ($text.TrimEnd() + $Lf)
}

function Get-ModuleBody([string]$Path) {
  $text = Read-TextFile $Path
  $text = $text.Replace($CrLf, $Lf)
  $text = [regex]::Replace($text, '^\s*<p align="right">[\s\S]*?</p>\s*', '')
  $text = [regex]::Replace($text, '(?s)\s*---\s*(---\s*)?\[[^\]]+\]\(\.\./\.\./README\.md\)\s*$', '')
  return $text.Trim()
}

function Get-ModuleTitle([string]$Body, [string]$Fallback) {
  foreach ($line in ($Body -split $Lf)) {
    if ($line -match '^##\s+(.+)$') { return $Matches[1].Trim() }
  }
  return $Fallback
}

if (-not (Test-Path -LiteralPath $HeaderPath)) { throw 'Missing docs/zh-CN/_readme-header.md' }
if (-not (Test-Path -LiteralPath $ManifestPath)) { throw 'Missing docs/zh-CN/_manifest.csv' }

$modules = Import-Csv -LiteralPath $ManifestPath
if (-not $modules -or $modules.Count -eq 0) { throw 'Module manifest is empty.' }

foreach ($module in $modules) {
  $path = Join-Path $SourceDir $module.File
  if (-not (Test-Path -LiteralPath $path)) { throw "Missing module: $($module.File)" }
  if (-not $module.Anchor) { throw "Missing anchor for module: $($module.File)" }
  Normalize-ModuleFile $path
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('<!-- README GENERATED FROM docs/zh-CN/*.md. Edit module files, then run ./tools/build-readme.ps1. -->')
$lines.Add('')
$header = (Read-TextFile $HeaderPath).TrimEnd()
foreach ($line in ($header -split $Lf)) { $lines.Add($line) }
$lines.Add('')
$lines.Add([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('IyMg55uu5b2V')))
$lines.Add('')

$number = 1
foreach ($module in $modules) {
  $path = Join-Path $SourceDir $module.File
  $body = Get-ModuleBody $path
  $title = Get-ModuleTitle $body $module.File
  $lines.Add("$number. [$title](#$($module.Anchor))")
  $number++
}

$lines.Add('')
$lines.Add('---')

foreach ($module in $modules) {
  $path = Join-Path $SourceDir $module.File
  $body = Get-ModuleBody $path
  $lines.Add('')
  $lines.Add("<!-- source: docs/zh-CN/$($module.File) -->")
  $lines.Add('<a id="' + $module.Anchor + '"></a>')
  $lines.Add('')
  $lines.Add($body)
  $lines.Add('')
  $lines.Add('---')
}

Write-TextFile $ReadmePath (($lines -join $Lf).TrimEnd() + $Lf)
Write-Host "Generated README.md from $($modules.Count) modules."
