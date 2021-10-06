
### ssh forwarding to local pc
ssh -o 'ProxyCommand ssh -W %h:%p user@server' user@computer


### ssh mounting on local machine
user_id="p5"

mkdir ~/mount_dir/
fusermount -u -z ~/mount_dir/
sshfs -ocache=yes,kernel_cache,compression=no,default_permissions,idmap=user,uid=$(id -u),gid=$(id -g),follow_symlinks $user_id@SERVER_ADRESS:/home/ ~/mount_dir/



### LOW SECURITY !! faster parallelized rsync for all subdir from dir
### from: https://egafni.wordpress.com/2013/01/31/blazing-fast-file-transfer-with-rsync-and-ssh-hpn/
### update: arcfour not supported anymore
ls /dir | xargs -P 10 -I {} \ 
rsync -avP --inplace -e "ssh -c arcfour128" dir/{} dest/






