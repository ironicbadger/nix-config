function myip --description 'Show the current public IP address'
    set -l public_ip (curl -s https://api.ipify.org)
    echo $public_ip
end
