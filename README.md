# CONTACT LIST API


## Versions :gem:
* **Ruby:** 3.1.0
* **Rails:** 6.0.3

#### Setup the API :monorail:

1. Run `bundle install` to install all the dependencies of the project;
2. Set up `config/database.yml` and add your database credentials;
3. Set up `.env` accordingly to your `config/database.yml` file.
3. Run `rails db:drop db:create db:migrate` to create the database and apply the migrations and seeds;
4. Run `rspec` to check for tests;
5. Run `rails s` and go for your localhost port.

## Docker :whale:

<p>This is a 100% dockerized application!</p>

#### Install Docker for Mac
<ul>
    <li>Install Docker Desktop: https://docs.docker.com/desktop/install/mac-install </li>
</ul>

#### Install Docker for Linux
<ul>
    <li>Uninstall docker engine: https://docs.docker.com/engine/install/ubuntu/#uninstall-docker-engine</li>
    <li>Install docker engine: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository</li>
    <li>Config docker as a non-root user: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user</li>
    <li>Config docker to start on boot: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot</li>
</ul>

#### Install Docker for Linux
<ul>
    <li>Do you use Windows? I'm sorry, docker doesn't work well on Windows. </li>
</ul>

#### Docker steps reminders

- Start terminal
- Make sure of permissions of your OS and terminal system are on point. (Don't be afraid to change the shebang in case you need)
- If you're not installing for the first time, don't overwrite archives
- If you're installing a new gem, be always sure to rebuild.


### Build the container and start the DB


```bash
cd contact_list
  sh devops/chmod.sh
  ./devops/compose/build.sh --no-cache
  ./devops/compose/up.sh
  ./devops/rails/restart.sh
  ./devops/compose/exec.sh
        bundle
        rspec
        exit
  ./devops/compose/down.sh
  exit
```

### Update DB and Rails

```bash
cd contact_list
    ./devops/compose/up.sh
    ./devops/rails/update.sh
    ./devops/compose/down.sh
  exit
```

### Uninstall

```bash
cd contact_list
  ./devops/compose/down.sh
  ./devops/compose/delete.sh
  exit
```

## DB reminders

- If you're having trouble when opening on a DB management system (like Beekeeper, DBeaver, PG Admin, etc.), don't forget that you need to run the container and use `localhost` as your host. 
- If any role issues appear Don't be afraid to `pkill postgres` and `brew services stop postgresql` (If you're running in homebrew).
- If you are having trouble with users accessing the DB, rebuild the container.

<h2>That's it. Happy coding :computer:</h2> 
