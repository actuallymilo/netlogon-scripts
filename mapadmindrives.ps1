$drives = @(
    @{ Letter = "F:"; Path = "\\srv3\Files"; Name = "Files" },
    @{ Letter = "S:"; Path = "\\srv3\Software"; Name = "Software" },
    @{ Letter = "G:"; Path = "\\srv3\Group Policy Files$"; Name = "Group Policy Files" },
    @{ Letter = "R:"; Path = "\\srv3\Active Directory Resources$"; Name = "Active Directory Resources" }
)

function Map-Drive {
    param (
        [string]$Letter,
        [string]$Path,
        [string]$Name
    )
    
    if (Test-Path "$Letter") {
        net use $Letter /delete /y
    }
    
    net use $Letter $Path /persistent:yes
    
    $shell = New-Object -ComObject Shell.Application
    $drive = $shell.Namespace($Letter)
    if ($drive) {
        $drive.Self.Name = $Name
    }
}

foreach ($drive in $drives) {
    Map-Drive -Letter $drive.Letter -Path $drive.Path -Name $drive.Name
}

if (Test-Path "H:") {
    $shell = New-Object -ComObject Shell.Application
    $drive = $shell.Namespace("H:")
    if ($drive) {
        $drive.Self.Name = "Personal Files"
    }
}
