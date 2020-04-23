function Show-GitLog {
    $FzfCommonOpt = "--color=dark", "--preview-window=down", "--ansi"

    Check-Fzf
    Check-Git
    
    git -c log.date=relative log --color=always --pretty=format:"%C(auto,yellow)%h%C(auto,magenta) %C(auto,blue)%>(12,trunc)%ad %C(auto,green)%<(7,trunc)%aN%C(auto,reset)%s%C(auto,red)% gD% D"
    | fzf @FzfCommonOpt --preview "git diff --stat --color=always {1}" 
    | ForEach-Object { $_.split(" ")[0] } 
    | Tee-Object -Variable Output 

    if ([string]::IsNullOrWhiteSpace($Output)) {
        Write-Error "No commit selected" -ErrorAction Stop
    }

    $TopLevel = git rev-parse --show-toplevel

    $Output 
    | git diff --stat --color=always
    | Tee-Object -Variable Changes
    [array]::reverse($Changes); 

    $Changes
    | fzf @FzfCommonOpt --preview-window=right:60%:wrap `
                        --header-lines=1 `
                        --preview "git diff $Output -- $TopLevel/{1} | bat --color=always --style=numbers"  `
}

function Check-Git {
    get-command git.exe -ErrorAction Continue
    ((Test-CommandExists -Command git.exe)
        || Write-Error "Unable to find git, install using `"choco install git`""  -ErrorAction Stop)
    | Out-Null
}
function Check-Fzf {
    get-command git.exe -ErrorAction Continue
    ((Test-CommandExists -Command fzf.exe)
        || Write-Error "Unable to find fzf, install using `"choco install fzf`""  -ErrorAction Stop)
    | Out-Null
}
function Test-CommandExists {
    param ( [string] $Command )
    (Get-Command $Command -ErrorAction SilentlyContinue) ? $true : $false
}

Export-ModuleMember -Function Show-GitLog