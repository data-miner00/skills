<#
.SYNOPSIS
    Links this repo's skills/ folder into ~/.claude/skills so Claude Code
    discovers them from every project.

.DESCRIPTION
    Claude Code only auto-discovers skills from fixed locations (personal:
    ~/.claude/skills, project: .claude/skills). This repo keeps its skills
    under version control on this drive, so a directory junction is used to
    make ~/.claude/skills *be* this repo's skills/ folder without moving it.

    Safe to re-run: if the junction already points at this repo's skills/
    folder, it's a no-op. If ~/.claude/skills exists as something else
    (a real directory with content, or a link elsewhere), the script stops
    without touching it so nothing is silently clobbered.
#>

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$target = Join-Path $repoRoot "skills"
$linkPath = Join-Path $HOME ".claude\skills"

if (-not (Test-Path $target)) {
    throw "Expected skills folder not found at: $target"
}

if (Test-Path $linkPath) {
    $existing = Get-Item $linkPath -Force

    if ($existing.LinkType -eq "Junction") {
        $existingTarget = $existing.Target | Select-Object -First 1
        if ($existingTarget -eq $target) {
            Write-Host "Already linked: $linkPath -> $target"
            exit 0
        }
        else {
            throw "$linkPath is a junction pointing elsewhere ($existingTarget). " +
                  "Remove it manually first if you want to relink it here."
        }
    }
    else {
        throw "$linkPath already exists and is not a junction created by this script. " +
              "Refusing to overwrite it - move or remove it manually first, then re-run."
    }
}

New-Item -ItemType Junction -Path $linkPath -Target $target | Out-Null
Write-Host "Linked: $linkPath -> $target"
