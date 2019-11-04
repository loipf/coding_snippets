
### ssh forwarding to local pc
ssh -o 'ProxyCommand ssh -W %h:%p user@server' user@computer