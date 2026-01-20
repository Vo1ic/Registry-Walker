[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Registry Walker v1.0"
# Author: Vo1ic
function Get-RegValues {
    param($path)
    try {
        $props = Get-ItemProperty -Path $path -ErrorAction Stop
        $table = @()
        foreach ($name in $props.PSObject.Properties.Name) {
            if ($name -match '^(PSPath|PSParentPath|PSChildName|PSDrive|PSProvider)$') { continue }
            $val = $props.$name
            $type = $val.GetType().Name
            
            # Smart Type Formatting
            if ($val -is [byte[]]) {
                $displayVal = [System.BitConverter]::ToString($val) -replace '-', ' '
                $type = "REG_BINARY"
            } elseif ($val -is [Array]) {
                $displayVal = $val -join ", "
                $type = "REG_MULTI_SZ"
            } elseif ($val -is [int] -or $val -is [int64]) {
                $displayVal = $val.ToString()
                $type = "REG_DWORD/QWORD"
            } else {
                $displayVal = $val.ToString()
                $type = "REG_SZ"
            }

            $table += [PSCustomObject]@{
                'Value Name' = $name
                'Type'       = $type
                'Data'       = $displayVal
            }
        }
        if ($table.Count -eq 0) { 
            Write-Host "   [!] No values found here." -ForegroundColor Yellow 
        } else { 
            # Вивід таблиці
            $table | Format-Table -AutoSize 
        }
    } catch { 
        Write-Host "   [Error] Access Denied or Invalid Key" -ForegroundColor Red 
    }
}

$currentPath = "HKLM:\SOFTWARE"

# Clear screen on start
Clear-Host 
Write-Host "Registry Walker v1.5 Loaded." -ForegroundColor Green
Write-Host "Type 'help' for commands." -ForegroundColor Gray
Write-Host ""

while ($true) {
    # Гарний промпт
    Write-Host "[$currentPath]" -NoNewline -ForegroundColor Cyan
    $cmd = Read-Host " >"
    
    # Обробка пустих вводів
    if ([string]::IsNullOrWhiteSpace($cmd)) { continue }

    $parts = $cmd -split ' ', 2
    $action = $parts[0]
    $arg = $parts[1]
    
    switch ($action) {
        'exit' { exit }
        'quit' { exit }
        'cls'  { Clear-Host }
        'clear' { Clear-Host }
        
        'ls' {
            Get-ChildItem -Path $currentPath -ErrorAction SilentlyContinue | Select-Object Name | Format-Table -HideTableHeaders -AutoSize
        }
        'dir' {
            Get-ChildItem -Path $currentPath -ErrorAction SilentlyContinue | Select-Object Name | Format-Table -HideTableHeaders -AutoSize
        }
        
        'cd' {
            if (!$arg) { Write-Host "   [!] Usage: cd <Folder>" -ForegroundColor Yellow; continue }
            # Обробка переходу на рівень вгору через cd ..
            if ($arg -eq "..") {
                $currentPath = Split-Path -Parent $currentPath
                if (!$currentPath) { $currentPath = "HKLM:\" }
                continue
            }
            
            $testPath = Join-Path -Path $currentPath -ChildPath $arg
            if (Test-Path $testPath) { 
                $currentPath = $testPath 
            } else { 
                Write-Host "   [!] Folder not found: $arg" -ForegroundColor Red 
            }
        }
        
        'back' {
            $currentPath = Split-Path -Parent $currentPath
            if (!$currentPath) { $currentPath = "HKLM:\" }
        }
        '..' {
            $currentPath = Split-Path -Parent $currentPath
            if (!$currentPath) { $currentPath = "HKLM:\" }
        }
        
        'root' { $currentPath = "HKLM:\" }
        
        'read' { Get-RegValues -path $currentPath }
        
        'help' {
            Write-Host "  ls / dir  - List folders" -ForegroundColor Gray
            Write-Host "  cd <name> - Go to folder" -ForegroundColor Gray
            Write-Host "  back / .. - Go up" -ForegroundColor Gray
            Write-Host "  read      - Show values in current folder" -ForegroundColor Gray
            Write-Host "  root      - Go to HKLM" -ForegroundColor Gray
            Write-Host "  cls       - Clear screen" -ForegroundColor Gray
            Write-Host "  exit      - Close program" -ForegroundColor Gray
        }

        default { 
            if ($action) { Write-Host "   [!] Unknown command: $action" -ForegroundColor DarkGray } 
        }
    }
    Write-Host ""
}