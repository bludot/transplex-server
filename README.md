# transplex-server

## About
This is just a simple ubuntu server hosting transmission torrent downloader in a private netowrk.
The idea is to allow to add torrents through and api and have then download to my plex server.
This server also mounts an nfs volume that corrolates to my plex server.

## How to use

Below are the variables i 
```
gateway_ip = gateway ip of your dhcp server (usually x.x.x.1)
transmission_ip = ip you want for your server
plex_ip = ip of your plex server (used for nfs)

ssh_key_pub = public ssh key for ssh into server
username = server username

guest_name = guestname for vmware esxi and server hostname (make sure you use a valid hostname)

esxi_hostname      = x.x.x.x
esxi_hostport      = "22"
esxi_hostssl       = "443"
esxi_username      = username
esxi_password      = password
```

```
terraform init
terraform plan
terraform apply
```

