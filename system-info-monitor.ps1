$ErrorActionPreference = 'Stop'

$logFile = Join-Path $PSScriptRoot 'system.info'
$refreshSeconds = 10

function Get-ReadableSize {
    param(
        [double]$Bytes
    )

    $units = @('B', 'KB', 'MB', 'GB', 'TB')
    $index = 0
    $value = [double]$Bytes

    while ($value -ge 1024 -and $index -lt ($units.Length - 1)) {
        $value /= 1024
        $index++
    }

    return '{0:N2} {1}' -f $value, $units[$index]
}

function Write-SystemSnapshot {
    param(
        [string]$LogPath
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $os = Get-CimInstance Win32_OperatingSystem
    $memoryFreeKb = [double]$os.FreePhysicalMemory
    $memoryFreeMb = $memoryFreeKb / 1024
    $memoryTotalKb = [double]$os.TotalVisibleMemorySize
    $memoryTotalMb = $memoryTotalKb / 1024
    $memoryUsedMb = $memoryTotalMb - $memoryFreeMb

    $lines = @(
        "[$timestamp]",
        "Memory: Free = $(Get-ReadableSize -Bytes ($memoryFreeMb * 1024 * 1024)) | Total = $(Get-ReadableSize -Bytes ($memoryTotalMb * 1024 * 1024)) | Used = $(Get-ReadableSize -Bytes ($memoryUsedMb * 1024 * 1024))",
        'Disk:'
    )

    $diskInfo = Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3'
    foreach ($disk in $diskInfo) {
        $freeBytes = [double]$disk.FreeSpace
        $totalBytes = [double]$disk.Size
        $usedBytes = $totalBytes - $freeBytes
        $percentFree = if ($totalBytes -gt 0) { ($freeBytes / $totalBytes) * 100 } else { 0 }

        $lines += "  $($disk.DeviceID) : Free = $(Get-ReadableSize -Bytes $freeBytes) | Total = $(Get-ReadableSize -Bytes $totalBytes) | Used = $(Get-ReadableSize -Bytes $usedBytes) | Free% = $([math]::Round($percentFree, 2))%"
    }

    $lines += ''
    $text = $lines -join [Environment]::NewLine

    $text | Out-File -FilePath $LogPath -Append -Encoding UTF8
    Clear-Host
    Write-Host $text
    Write-Host "`nPress Q to quit. Refresh every $refreshSeconds seconds. Log file: $LogPath"
}

"System info monitor started. Log file: $logFile" | Out-File -FilePath $logFile -Encoding UTF8

while ($true) {
    Write-SystemSnapshot -LogPath $logFile

    if ($Host.UI.RawUI.KeyAvailable) {
        $key = $Host.UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        if ($key.Character -in @('q', 'Q')) {
            Write-Host "`nExit requested by user. Monitoring stopped."
            break
        }
    }

    Start-Sleep -Seconds $refreshSeconds
}
