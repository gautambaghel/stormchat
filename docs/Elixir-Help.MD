## Creating the application

```
$    # New app
$ mix phx.new microblog
$    # Create DB user
$ sudo su - postgres
postgres$ pwgen 12 1
...
postgres$ createuser -d -P microblog
password: <paste>
$ exit
```

* How to change DB password if we mess stuff up:
```
postgres$ psql
postgres=# alter user microblog with password '...';
```
* Config database: config/dev.exs

```
config :microblog, Microblog.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "microblog",
  password: "...",
  database: "microblog_dev",
  hostname: "localhost",
  pool_size: 10
```

* Add @import "bootstrap"; to scss file. Fix the brunch config:
```
plugins: {
 // ...
  sass: {
    options: {
      includePaths: ["node_modules/bootstrap/scss"],
      precision: 8,
    }
  }
},
// ...
npm: {
  globals: {
    $: 'jquery'
  }
}

```

* Brunch & Babel
 ```
assets$ npm install --save jquery bootstrap popper.js react react-dom reactstrap underscore
assets$ npm install --save-dev babel-preset-env babel-preset-react sass-brunch

 ```

 * Configure Brunch - In assets/brunch-config.js:

 ```
 plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/],
      presets: ['env', 'react'],
    },
    sass: {
      options: {
        includePaths: ["node_modules/bootstrap/scss"],
        precision: 8,
      }
    }
  },
 ```

 ```
 npm: {
   enabled: true,
   globals: {
     _: 'underscore',
     $: 'jquery'
   }
 }

 ```

 * Enable Bootstrap 4 - Add the following to assets/css/app.scss:
```
@import "bootstrap";

body { font-size: 20pt; }

```

* Go fix layouts/app.html.eex:

    - Remove header.
    - Fix flash.

* Go fix page/index.html.eex:

```
<div class="row">
  <div class="col">
    <h1>page/index</h1>
    <p>TODO: App</p>
  </div>
</div>

```
* Adding HTML resources

```
$ mix phx.gen.html Accounts User users email:string name:string
```

* Adding JSON resources

```
$ mix phx.gen.json Social Follow follows follower_id:references:users followee_id:references:users
```


## Setup Server
* As the root user:
```
sudo apt install nginx
cd /etc/nginx/sites-enabled
vim default

```

    * Change “root” to /home/name/www/main
    * service nginx restart
    * (as normal user) Create /home/name/www/main/index.html
    * Visit the server IP

 Testing while waiting for DNS:

    - Create an entry in /etc/hosts for the site.

 Let’s set up another web site too.

  *  (as root) Save off the template below in /etc/nginx/sites-available
  *  Edit the root and server name (ironbeard.com)
  *  Symlink the config file to /etc/nginx/sites-enabled
        - ln -s /etc/nginx/sites-available/ironbeard.com /etc/nginx/sites-enabled
        - ls -l /etc/nginx/sites-enabled
  *  Restart nginx
  *  Create hosts entry and test that.

 * nginx Config

 ```
 server {
        listen 80;
        listen [::]:80;

        root /home/nat/www/ironbeard.com;

        index index.html;

        server_name ironbeard.com www.ironbeard.com;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }
}
 ```

## Deployment

* Create new user account.

```
$ sudo su -
# pwgen 12 1
# adduser hangmanX
# sudo su - hangmanX
```
* Check out hangman.

```
$ git clone https://github.com/gautambaghel/Web-Development/hw06/tasktracker.git
```


* Install the nginx config:

  -  Make sure to pick a new port (5101 / 5102).
  -  Hostname
  -  Enable
  -  Restart

* Add distillery to mix.exs:

```
{:distillery, "~> 1.5", runtime: false}
```


    - mix release.init
    - rel/config.exs defaults are fine for now

* Walk through the deploy steps:

    - see deploy.sh
    - Start at mix deps.get
    - Need to recompile libsass.
    - server: true

```
#import_config "prod.secret.exs"

config :hangman, HangmanWeb.Endpoint,
    secret_key_base: "THIS+IS+NOT+SECURE+DONT+USE+SESSION+COOKIES+WITHOUT+FIXING"
```
* After running mix release, skip straight to:

```
PORT=5101 _build/prod/rel/hangman/bin/hangman foreground
```

    * Point out this
    * \_build/prod/rel/hangman/releases/0.0.1/hangman.tar.gz
    * This can conceptually be copied to a machine with the same OS as the build machine but no erlang / elixir / nodejs for deployment.
    * I’m suggesting on-server builds for ease of debugging.

```
PORT=5101 _build/prod/rel/hangman/bin/hangman start
```
    * @reboot crontab rule

    * upgrades

      -  Git pull
      -  Redeploy


## Course Webpage

For more info visit - [Course Webpage](http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/)

## Authors

* **Gautam Baghel** - *Initial work* - [Github](https://github.com/gautambaghel)

## Guides

The guide for this project is listed here - see the [Guide](http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/guides/) file for details

## Notes

The notes for this project is listed here - see the [Notes](http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/) file for details

## Acknowledgments

* **Nathaniel Tuck** - *Instructor* - [Info](https://www.ccis.northeastern.edu/people/michael-weintraub/)
