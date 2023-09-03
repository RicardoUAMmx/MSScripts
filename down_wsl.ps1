$preURL = 'https://aka.ms/wsl'
$postURL = @(
    'ubuntu'
    '-debian-gnulinux'
    '-kali-linux-new'
    '-SUSELinuxEnterpriseServer15SP3'
    '-opensuse-tumbleweed'
    '-opensuseleap15-3'
    '-oraclelinux-8-5'
)
$distros = @(
    'Ubuntu'
    'Debian'
    'Kali'
    'Suse'
    'Open_Suse'
    'Open_Suse_Leap'
    'Oracle'
)

Set-Location "~\Documents"
Write-Host "The following distros are available to download from trusted MS links:`n`n" -ForegroundColor Red

1..$postURL.Count | ForEach-Object {
    $formattedOutput = "{0,2}. {1,-15}: {2}" -f $_, $distros[$_ - 1], ($preURL + $postURL[$_ - 1])
    Write-Host $formattedOutput
}
Write-Host `n

$getDistro = Read-Host -Prompt "Write the number distro you'd like "
$link = $preURL + $postURL[$getDistro - 1]
$selectedDistro = $distros[$getDistro - 1]
Write-Host "You chose: $selectedDistro"
Write-Host "Downloading from: $link ..."`n`n
Invoke-WebRequest -Uri $link -OutFile $($selectedDistro + ".appx") -UseBasicParsing
Rename-Item $($selectedDistro + ".appx") -NewName $($selectedDistro + ".zip")
Expand-Archive $($selectedDistro + ".zip")
Remove-Item $($selectedDistro + ".zip")
$available = Get-ChildItem $selectedDistro\*.appx | Select-Object -Property Name

if ( $available.Count -ne 0 ){
    1..$available.Count | ForEach-Object {
        $formatOutput = "{0,2}. {1,-15}" -f $_, $available[$_ - 1].Name
        Write-Host $formatOutput
    }
    Write-Host `n
    $getLinux = Read-Host -Prompt "Get your prefered architecture "
    Move-Item ".\$selectedDistro\$($available[$getLinux -1].Name)" -Destination "~\Documents\$($selectedDistro + '.zip')"
    Remove-Item $selectedDistro -Recurse
    Expand-Archive $($selectedDistro + '.zip')
    Remove-Item $($selectedDistro + '.zip')
}

Write-Host `n
Write-Host "Ready!"`n`n
