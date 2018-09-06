# Stormchat Server Setup

### Activate Firewall

As root user

```
  ufw allow 22/tcp      # important, this allows ssh
  ufw allow 80/tcp      # allow normal HTTP
  ufw allow 443/tcp     # allow HTTPS
  ufw allow 4000/tcp    # allow the Phoenix dev server
  ufw enable

```


* adduser name
* Set a good password
* adduser name sudo
* from your machine: ssh-copy-id name@ip
* from your machine: test ssh login in separate terminal window
* Test sudo: sudo su -
* Disable root ssh (/etc/ssh/sshd_config; PermitRootLogin)
* restart the ssh service: service ssh restart
* Verify no root logins & user login still works.


### Next, set up the web server.

As the root user:

```

sudo apt install nginx
cd /etc/nginx/sites-enabled
vim default

```

  * Change “root” to /home/gautam/www/main
  * service nginx restart
  * (as normal user) Create /home/gautam/www/main/index.html
  * Visit the server IP

### Testing while waiting for DNS:

  *  Create an entry in /etc/hosts for the site.

### Let’s set up another web site too.


  * (as root) Save off the template below in /etc/nginx/sites-available
  * Edit the root and server name (stormchat.com)
  * Symlink the config file to /etc/nginx/sites-enabled
    -  ln -s /etc/nginx/sites-available/stormchat.com /etc/nginx/sites-enabled
    -  ls -l /etc/nginx/sites-enabled
  * Restart nginx
  * Create hosts entry and test that.

## sites-available/stormchat.com :

  ```
  server {
        listen 80;
        listen [::]:80;

        root /home/gautam/www/stormchat.com;

        index index.html;

        server_name stormchat.com www.stormchat.com;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }
}
  ```
