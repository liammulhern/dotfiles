Import-Module posh-git
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_lean.omp.json" | Invoke-Expression
Set-PSReadLineKeyHandler -Chord Ctrl+y -Function ForwardWord

function nf {
    fzf -m --preview="bat --color=always {}" --bind "enter:become(nvim {+})"
}

Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })

