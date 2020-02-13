function Set-GitBranchFuzzily {
    # Requires -Modules PSFzf

    $RemoteBranchPrefix = "remotes/origin/";
    # Branches to filter from output, e.g remotes/origin/HEAD
    #$FilterBranches = "remotes/origin/HEAD*", "\* *";

    $Branches = & git branch -a;
    #$FilteredBranches = $Branches | Where-Object -FilterScript
    $UniqueBranches = $Branches | Foreach-Object { $_.Replace($RemoteBranchPrefix, "").Trim() } | Sort-Object -CaseSensitive | Get-Unique;
    $SelectedBranch = $UniqueBranches | Invoke-Fzf;

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
