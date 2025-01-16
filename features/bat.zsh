if command -v bat >/dev/null 2>&1; then
  export PAGER=bat
  export BAT_STYLE=plain
  
  baty() {
    bat --color=always --language=yaml "$@"
  }

fi
