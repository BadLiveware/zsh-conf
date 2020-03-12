function Start-Build {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $PipelineName,
        [Parameter(Mandatory = $false, Position = 1)]
        [string] 
        $Branch = $null
    )
    if ($Branch -eq "") {
        Write-Host "No branch parameter given, using HEAD"
        $Branch = Invoke-Expression "git rev-parse --abbrev-ref HEAD"
    }

    Write-Host "Running on branch: " -ForegroundColor Yellow -NoNewline
    Write-Host "$Branch" -ForegroundColor Cyan

    $Command = "az pipelines build queue --definition-name `"$PipelineName`" --branch `"$Branch`"" 
    Write-Host "Running command: " -ForegroundColor Yellow -NoNewline
    Write-Host "$Command" -ForegroundColor Cyan
    $Result = Invoke-Expression $Command | ConvertFrom-Json
    $Result
}

function Wait-BuildComplete {
    param (
        [Parameter(Mandatory = $true, Position=0, ValueFromPipeline)]
        [int]
        $BuildId,
        [Parameter(Mandatory = $false, Position=1)]
        [string]
        $PipelineName,
        [Parameter(Mandatory = $false, Position=2)]
        [int]
        $PollInterval = 1000
    )

    while ((Get-RunProgress $BuildId) -eq "inProgress") {
        Write-Host "Waiting for $BuildId $PipelineName"
        Start-Sleep -Milliseconds $PollInterval
    }
}

function Get-PipelineNames {
    Invoke-Expression "az pipelines list" | ConvertFrom-Json | Select-Object -Property name,id    
}

function Get-PipelineNamesFuzzily {
    #Requires -Module PSFzf
    Get-PipelineNames | Where-Object -Property name -in -Value ($Pipelines.name | Invoke-Fzf -Multi)
}

function Get-RunProgress {
    param (
        [Parameter(Mandatory = $true, Position=0)]
        [int]
        $RunId
    )
    (Invoke-Expression "az pipelines runs show --id $RunId 2>&1 | Out-Null" | ConvertFrom-Json).status
}

# function Get-LatetestBuildDefinition {
#     param (

#     )
# }

# function Start-Release {
#     param (

#     )
# }
