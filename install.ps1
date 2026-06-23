# Links chip-claude framework into $env:USERPROFILE\.claude\
# Does NOT touch your personal ~/.claude/CLAUDE.md — that file is yours alone.
# Safe to re-run. Backs up existing non-link files/dirs.
# Uses directory junctions (no admin / Developer Mode needed). All targets are dirs.

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$BackupDir = Join-Path $ClaudeDir "backups\install-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

function Link-Item {
  param([string]$Src, [string]$Dst)
  if (Test-Path $Dst) {
    $item = Get-Item $Dst -Force
    if ($item.LinkType) {
      # Existing junction/symlink we manage — remove just the reparse point,
      # never the target contents.
      $item.Delete()
    } else {
      Write-Host "  backing up: $Dst -> $BackupDir\"
      Move-Item $Dst $BackupDir
    }
  }
  New-Item -ItemType Junction -Path $Dst -Target $Src | Out-Null
  Write-Host "  junction: $Dst -> $Src"
}

Write-Host "Linking framework into $ClaudeDir"
Link-Item "$RepoDir\agents"    "$ClaudeDir\agents"
Link-Item "$RepoDir\skills"    "$ClaudeDir\skills"
Link-Item "$RepoDir\commands"  "$ClaudeDir\commands"
Link-Item "$RepoDir\hooks"     "$ClaudeDir\hooks"
Link-Item "$RepoDir\templates" "$ClaudeDir\chip-templates"

Write-Host ""
Write-Host "Personal CLAUDE.md: not touched."
$PersonalClaude = Join-Path $ClaudeDir "CLAUDE.md"
if (-not (Test-Path $PersonalClaude)) {
  Write-Host "  You don't have one yet. Copy the template as a starting point:"
  Write-Host "    Copy-Item `"$RepoDir\CLAUDE.template.md`" `"$PersonalClaude`""
  Write-Host "  Then edit to reflect how you actually want Claude to work."
} else {
  Write-Host "  You already have one at $PersonalClaude — leaving it alone."
}

Write-Host ""
Write-Host "Settings: $ClaudeDir\settings.json — not touched."
Write-Host "  Merge bits from $RepoDir\settings.template.json by hand if useful."
Write-Host ""
# Drop the backup dir if nothing was displaced.
if ((Get-ChildItem $BackupDir -Force | Measure-Object).Count -eq 0) {
  Remove-Item $BackupDir -Force
  Write-Host "Done. (No files displaced.)"
} else {
  Write-Host "Done. Backups: $BackupDir"
}
