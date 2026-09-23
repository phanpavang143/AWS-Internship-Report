$repoName = "AWS-Internship-Report"
$projectRoot = $PSScriptRoot
$parentRoot = Split-Path -Parent $projectRoot
$previewRoot = Join-Path $parentRoot "site-preview"
$repoPreviewPath = Join-Path $previewRoot $repoName

if (Test-Path $previewRoot) {
    Remove-Item $previewRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $repoPreviewPath -Force | Out-Null

$hugoCmd = Get-Command hugo -ErrorAction SilentlyContinue
if (-not $hugoCmd) {
    Write-Error "Hugo is required to build the local preview."
    exit 1
}

& hugo --source $projectRoot --minify --quiet --baseURL "http://localhost:1322/$repoName/"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Hugo failed to build the local preview."
    exit $LASTEXITCODE
}

Copy-Item (Join-Path $projectRoot "public\*") $repoPreviewPath -Recurse -Force

Write-Host "Preview root: $previewRoot"
Write-Host "Open: http://localhost:1322/$repoName/"
Write-Host "Serving folder: $previewRoot"

$npxCmd = Get-Command npx.cmd -ErrorAction SilentlyContinue
if (-not $npxCmd) {
    Write-Error "Node.js and npx.cmd are required to start the preview server."
    exit 1
}

& npx.cmd -y http-server $previewRoot -p 1322 -c-1
