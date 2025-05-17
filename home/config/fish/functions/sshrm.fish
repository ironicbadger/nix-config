function sshrm
    ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$argv[1]"
end
