function Start-PipelinesFuzzily {
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string] 
        $Branch = "master"
    )
    Get-PipelineNamesFuzzily | % { Start-Build -PipelineName $_.name -Branch $Branch }
}

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

function Get-Pipelines {
    Invoke-Expression "az pipelines list" | ConvertFrom-Json | Select-Object -Property name, id    
}

function Get-PipelineNamesFuzzily {
    #Requires -Module PSFzf
    $SelectedPipelines = Get-Pipelines | Tee-Object -Variable Pipelines | Invoke-Fzf -Multi
    $Pipelines | Where-Object -Property name -in -value $SelectedPipelines
}

function Wait-BuildComplete {
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline)]
        [int]
        $BuildId,
        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        $PipelineName,
        [Parameter(Mandatory = $false, Position = 2)]
        [int]
        $PollInterval = 1000
    )
    while ((Get-RunProgress $BuildId) -in "inProgress", "notStarted") {
        Write-Host "Waiting for $BuildId $PipelineName"
        Start-Sleep -Milliseconds $PollInterval
    }
}

function Get-RunProgress {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [int]
        $RunId
    )
    (Invoke-Expression "az pipelines runs show --id $RunId" | ConvertFrom-Json).status
}

function Start-ReleaseFuzzily {
    param(
        [Parameter(mandatory = $false)]
        [string]
        $Branch = ""
    )
    if ($Branch -eq "") {
        Write-Host "No branch parameter given, using HEAD"
        $Branch = Invoke-Expression "git rev-parse --abbrev-ref HEAD"
    }

    Write-Host "Running on branch: " -ForegroundColor Yellow -NoNewline
    Write-Host "$Branch" -ForegroundColor Cyan

    $SelectedArtifacts = Get-LastBuildArtifact | Tee-Object -Variable BuildArtifacts | Invoke-Fzf -Multi
    $BuildArtifacts | Select-Object Start-Release
}

function Get-LastBuildArtifact {
    param (
        [Parameter(mandatory = $true, position = 0)]
        [string]
        $Branch
    )

    Invoke-Expression "az pipelines build list" | convertfrom-json
    | where-object -Property sourceBranch -EQ -value "refs/heads/$Branch"
    | ForEach-Object { [pscustomobject]@{ name = $_.definition.name; 
                                          buildNumber = $_.buildNumber; 
                                          finishTime = $_.finishTime } }
    | Sort-Object -Stable -Property finishTime -Descending
    | Group-Object -Property name 
    | ForEach-Object { $_.Group[0] }
}

# function Start-Release {
#     param(
#         [string]
#         $BuildName,
#         [string]
#         $BuildNumber        
#     )

    
# }
