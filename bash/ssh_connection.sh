
### ssh forwarding to local pc
ssh -o 'ProxyCommand ssh -W %h:%p user@server' user@computer


### ssh mounting on local machine
user_id="p5"

mkdir ~/mount_dir/
fusermount -u -z ~/mount_dir/
sshfs -ocache=yes,kernel_cache,compression=no,default_permissions,idmap=user,uid=$(id -u),gid=$(id -g),follow_symlinks $user_id@SERVER_ADRESS:/home/ ~/mount_dir/



