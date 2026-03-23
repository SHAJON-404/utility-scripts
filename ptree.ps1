param(
    [string]$Path = ".",
    [string]$Output = ""
)

Set-Location $Path

$files = git ls-files --cached --others --exclude-standard | Sort-Object
$tree = @{}

foreach ($file in $files) {
    $parts = $file -split '/'
    $current = $tree
    foreach ($part in $parts) {
        if (!$current.ContainsKey($part)) {
            $current[$part] = @{}
        }
        $current = $current[$part]
    }
}

function Show-Tree($node, $indent) {
    foreach ($key in $node.Keys | Sort-Object) {
        $line = "$indent├── $key"
        if ($Output -ne "") {
            Add-Content -Path $Output -Value $line
        } else {
            Write-Output $line
        }
        Show-Tree $node[$key] "$indent│   "
    }
}

if ($Output -ne "") {
    if (Test-Path $Output) { Remove-Item $Output }
}

Show-Tree $tree ""
