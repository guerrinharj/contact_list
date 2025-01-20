# CONTACT LIST API

This is an API that i made as a challenge for UEX, it basically ia contact management system,integrating with Via CEP (for CEP validations) and Google Maps (for creating latitude and longitude) 

As an User you are able to:
- Signup to the platform (using username, password and password confirmation).
- Login to the platform (providing username and password)
- Logout off the platform (providing username and password)
- Change the password in case you missed (providing username and password and an email will be sent with the instructions).
- Delete your account (providing username and password)


After logged as an User will you will be able to manage your contact:
- You can get a list from all contacts, and you will also be able to filter by name and/or CPF.
- Get a specific contact information.
- Create a contact by providing name, CPF, phone, address (street name and number) and postal code (needs to be valid accordingly to ViaCEP system). Once you provide those informations, you will receive the latitude and longitude of the contact address (provided by Google Maps).
- Update a contact information.
- Delete a contact.
- Find the contact address by providing a CEP (needs to be valid accordingly to ViaCEP system).


## Attention

- Be aware that by using this API you will need to create a PostgreSQL database and have a valid Google Maps API Key that needs to be set out to your `.env` file, use `.env.example` as a blueprint.

## Versions :gem:
* **Ruby:** 3.1.0
* **Rails:** 6.0.3

#### Setup the API locally :monorail:

1. Run `bundle install` to install all the dependencies of the project;
2. Set up `config/database.yml` and add your database credentials;
3. Set up `.env` accordingly to your `config/database.yml` file.
4. Run `rails db:drop db:create db:migrate` to create the database and apply the migrations and seeds;
5. Run `rake user` to create a user, you will be asked in terminal to have for email and password;
6. If you feel like it, create a valid contact (me) by running `rails db:seed`
7. Run `rspec` to check for tests;
8. Run `rails s` and go for your localhost port.

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

### Run Rails server

```bash
cd contact_list
    ./devops/compose/up.sh
    ./devops/rails/server.sh
    # CTRL + C
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

## Request cURLs

- Use `examples.txt` to get example of cURLs for requests.

<h2>That's it. Happy coding :computer:</h2> 
