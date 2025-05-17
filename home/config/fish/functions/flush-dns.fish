function flush-dns
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
end
