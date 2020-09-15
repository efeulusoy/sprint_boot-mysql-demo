# Running the Code
## Summary
The `docker-compose.yml` contains the config that is required to startup the MySQL server, this sets up the user, password and the database (there are some
lines that have been commented out, the plan was to start all three services together). The REST API connects to this database for any read/write operations, the API 
itself is written in Java with Spring Boot.

## MySQL Server
Type `docker-compose up` in the directory of the `docker-compose.yml` file, this will start the MySQL server. The database is accessible through port `5001`.

## REST API
Type `./mvnw spring-boot:run` in the terminal. This will run on port `8080`.

## Consuming the API
There are various ways to make calls to the API but I'll mention `curl` and Postman here as those are the tools I've used to test this.

### `curl`
- To save a user with an e-mail type `curl localhost:8080/users/add -d name={name} -d email={email}`. This should return with a message saying "Saved".
- To get all users type `curl localhost:8080/users/all`, the result should look similar to `[{"id":1,"name":"Name","email":"name@mail.com"}]`.

### Postman
- Select the `POST` request option and use `localhost:8080/users/add` as the target URL. Add the params `name` and `email` under the "Params" tab and then click on Send
to make the request to save a user. The message `Saved` will be visible in the response body.
- Pick the `GET` option and make a request to `localhost:8080/users/all`. You can view the JSON under the response body.

# Main Components
The tutorial that I've used for this is https://spring.io/guides/gs/accessing-data-mysql/.

## `User.java`
This represents the `User` that we want to store in our database.

```
@Table(name = "users") // Telling Spring to specifically use the table called `users` as this is what we defined in the `schema.sql` file.
@Entity // Telling Spring that this is an Entity so that Hibernate can automatically translate this.
public class User {
    @Id // The Id is generated automatically. When we create an instance of the User we only use a name and an e-mail. This will be unique for every record in our database regardless of the name and the e-mail.
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    private String email;

    // Getters and setters here
              .
              .
              .
}
```

## `UserRepository.java`
```
public interface UserRepository extends CrudRepository<User, Integer> {

}
```
This is the part that takes care of the database operations. The `CrudRepository` is an interface defined by Spring, by implementing this we get access to generic methods
like `save` and `delete`.

With `<User, Integer>` we are telling Spring that `User` is the entity that we want to store and the ID is of type `Integer` (this makes sure that we can call methods
such as `deleteByID(Integer x)` with the specified ID type).

## `MainController.java`
Our mappings are defined here with some Spring annotations.
`@RequestMapping(path="/users")` (this is the root path defined before the class declaration).
And then we can define specific mappings for the methods:
`@PostMapping(path="/add")` 
So when running on localhost the full url would be `localhost:PORT/users/add` and this URL would accept POST requests because of the @PostMapping annotation.
Within the class we create an instance of the `UserRepository` class to do our CRUD operations.
```
  @Autowired
  private UserRepository userRepository;
 ```
 @Autowired is used for dependency injection, even if we haven't assigned anything to it Spring will create an instance for us and assign it to that value. Through
 this we can call `userRepository.save(user)` to save the user in out database. Again, we actually didn't write any code for the save method but it comes from the 
 `CRUDRepository` interface which we implemented in the `UserRepository` class.

## `UsersDemoBackendApplication.java`
This is the main entry of the application and contains the `main()` method.

## `application.properties`
Contains the configuration required for the database connection such as the username, password, location of the database and some other properties regarding table
creation.

## `schema.sql`
Contains the schema for the "users" table. First part of the script drops the table to ensure that we use a clean table each time we start the application. The second
part defines the table which has an `id` used as the primary key, a `name` field to store the name and an `email` field to store the name. 
