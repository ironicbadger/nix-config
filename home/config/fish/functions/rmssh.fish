function rmssh --wraps='ssh-keygen -f "$HOME/.ssh/known_hosts" -R' --description 'alias rmssh=ssh-keygen -f "$HOME/.ssh/known_hosts" -R'
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R $argv
        
end
