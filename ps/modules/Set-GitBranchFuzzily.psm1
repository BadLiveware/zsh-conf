function Set-GitBranchFuzzily {
    # Requires -Modules PSFzf

    $RemoteBranchPrefix = "remotes/origin/";

    $Branches = & git branch -a;
    $FilteredBranches = $Branches | Foreach-Object { $_.Replace($RemoteBranchPrefix, "").Trim() } | Sort-Object -CaseSensitive | Get-Unique;
    $SelectedBranch = $FilteredBranches | Invoke-Fzf;

    if ($SelectedBranch -match $RemoteBranchPrefix) {
        $SelectedBranch = $SelectedBranch.Replace($RemoteBranchPrefix, "").Trim();
    }

    if (($null -eq $SelectedBranch) -or ($SelectedBranch -eq "")) {
        Write-Host "No branch selected"
        return;
    }

    Write-Host "checking out `"$SelectedBranch`""
    & git checkout $SelectedBranch;
}