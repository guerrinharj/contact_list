# CONTACT LIST API

This is an API that i made as a challenge for UEX, it basically a contact management system,integrating with Via CEP (for CEP validations) and Google Maps (for creating latitude and longitude).

## API functions.

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


## API Information.

- This API follows a traditional MVC (Model-View-Controller) pattern, where the client interacts with specific routes that direct requests to their respective controllers. The controllers handle the business logic and interact with the database through the models, ensuring proper data manipulation and retrieval.

- The ApplicationController serves as the base controller for the API, ensuring all requests are authenticated before accessing protected resources. It implements an authorize method, which validates the presence of Email and Password headers in the request. If the credentials match an existing user in the database and the password is authenticated, the @current_user is set for the session. Otherwise, it returns an appropriate error response, denying access. This mechanism centralizes authentication logic, enforcing security across all controllers that inherit from it.

## API Flow

### API Flow Summary

#### Authentication Endpoints (`AuthController`)

- **Sign Up** (POST `/signup`):
  - Creates a new user with email, password, and password confirmation.
  - **Request Body**:
    ```json
    {
      "user": {
        "email": "example@test.com",
        "password": "password",
        "password_confirmation": "password"
      }
    }
    ```
  - **Response**:
    - `201 Created`: 
      ```json
      { "message": "User created successfully", "user": { ... } }
      ```
    - `422 Unprocessable Entity`: 
      ```json
      { "errors": [ ... ] }
      ```

- **Login** (POST `/login`):
  - Authenticates a user with email and password.
  - **Headers**: `Email` and `Password`.
  - **Response**:
    - `200 OK`: 
      ```json
      { "message": "Login successful", "user": { ... } }
      ```
    - `401 Unauthorized`: 
      ```json
      { "errors": [ "Invalid email or password" ] }
      ```

- **Logout** (POST `/logout`):
  - Logs the user out.
  - **Headers**: `Email` and `Password`.
  - **Response**:
    - `200 OK`: 
      ```json
      { "message": "Logout successful" }
      ```

- **Forgot Password** (POST `/forgot_password`):
  - Sends password reset instructions to the provided email.
  - **Request Body**:
    ```json
    { "user": { "email": "example@test.com" } }
    ```
  - **Response**:
    - `200 OK`: 
      ```json
      { "message": "Password reset instructions sent to your email" }
      ```
    - `404 Not Found`: 
      ```json
      { "message": "Email not found" }
      ```

- **Delete Account** (DELETE `/delete_account`):
  - Deletes the logged-in user account.
  - **Request Body**:
    ```json
    { "user": { "password": "password", "password_confirmation": "password" } }
    ```
  - **Response**:
    - `200 OK`: 
      ```json
      { "message": "Account deleted successfully" }
      ```
    - `422 Unprocessable Entity`: 
      ```json
      { "errors": [ "Password confirmation does not match" ] }
      ```

---

#### Contact Management Endpoints (`ContactsController`)

- **List Contacts** (GET `/contacts`):
  - Retrieves all contacts for the current user.
  - Supports filtering by `name` and `tax_number`.
  - **Query Parameters**:
    ```
    ?name=John&tax_number=12345678909
    ```
  - **Response**:
    - `200 OK`: List of contacts.

- **Get Contact** (GET `/contacts/:id`):
  - Retrieves a single contact by its ID.
  - **Response**:
    - `200 OK`: Contact details.
    - `404 Not Found`: 
      ```json
      { "errors": [ "Contact not found" ] }
      ```

- **Create Contact** (POST `/contacts`):
  - Creates a new contact associated with the logged-in user.
  - **Request Body**:
    ```json
    {
      "contact": {
        "name": "John",
        "tax_number": "12345678909",
        ...
      }
    }
    ```
  - **Response**:
    - `201 Created`: Created contact details.
    - `422 Unprocessable Entity`: 
      ```json
      { "errors": [ ... ] }
      ```

- **Update Contact** (PUT `/contacts/:id`):
  - Updates an existing contact.
  - **Request Body**:
    ```json
    { "contact": { "name": "Updated Name" } }
    ```
  - **Response**:
    - `200 OK`: Updated contact details.
    - `422 Unprocessable Entity`: 
      ```json
      { "errors": [ ... ] }
      ```

- **Delete Contact** (DELETE `/contacts/:id`):
  - Deletes a contact.
  - **Response**:
    - `200 OK`: 
      ```json
      { "message": "Contact deleted successfully" }
      ```
    - `404 Not Found`: 
      ```json
      { "errors": [ "Contact not found" ] }
      ```

- **Find Address** (GET `/contacts/find_address`):
  - Fetches address details for a given postal code.
  - **Query Parameters**:
    ```
    ?postal_code=22060021
    ```
  - **Response**:
    - `200 OK`: Address details from ViaCEP.
    - `400 Bad Request`: 
      ```json
      { "errors": [ "Postal code is required" ] }
      ```
    - `422 Unprocessable Entity`: 
      ```json
      { "errors": [ "Invalid postal code" ] }
      ```
    - `503 Service Unavailable`: 
      ```json
      { "errors": [ "Failed to fetch address from ViaCEP" ] }
      ```

---

#### User Profile Endpoint (`UsersController`)

- **Get Profile** (GET `/profile`):
  - Retrieves the profile details of the logged-in user.
  - **Headers**: `Email` and `Password`.
  - **Response**:
    - `200 OK`: User details.

---

### Models

- **User**:
  - **Attributes**: `email`, `password_digest`.
  - **Associations**: `has_many :contacts`.
  - **Validations**:
    - Presence: `email`, `password`.
    - Uniqueness: `email`.
    - Password length: Minimum 6 characters.

- **Contact**:
  - **Attributes**: `name`, `tax_number`, `phone`, `address_name`, `address_number`, `address_complement`, `postal_code`, `latitude`, `longitude`.
  - **Associations**: `belongs_to :user`.
  - **Validations**:
    - Presence: `name`, `tax_number`, `phone`, `address_name`, `address_number`, `postal_code`.
    - Uniqueness: `tax_number`.
    - CPF/CNPJ validation for `tax_number`.
    - Postal code validation using ViaCEP.
  - **Callback**:
    - Fetches latitude and longitude using Google Maps API before saving.



## API Gems

- We use `bcrypt` for filtering passwords.
- We use `concurrent_ruby` for avoiding Logger issues.
- We use `cpf_cnpj` for CPF/CNPJ validation.
- We use `factory_bot_rails` for creating factories for testing
- We use `faker` for generating fake information for factories. 



## Attention

- As is a challenge, we're just working with the development environment.

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
- This application use a series of shell scripts in order to simplify commands, they're all written inside the `devops` folder.


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
