

Swift Restful 
========


Swift Restful project provides some useful http access classes and tools, which hopefuly would make api calls easier. it also introduces a way to complete object serialization from/to json strings mostly behind the scene. the goal is for user to be able to call apis with their DTOs and receive DTOs in response automatically.

Features
=====

*	**Asynchronouse http calls**
*	**Interception in application scope and object scope**
*	**Using DataTransfer objects directly for Sending/Receiving data.**
*	**Accepting DTOs from multipile NamingConventions**
*	**OAuth Support**


How to get the library
=============



How to use
=======

Custome | Low level access | not so easy
--------------------------------------------

For calling an HTTP endpoint for **raw data** you  will use the simplest class: **HttpClient**. HttpClient wraps the swift internal Http access classes. It gives one *download()* method. which can add to http-request parameters and write any data using any http-method (GET/POST/PUT/...). It's more flexible but not the easiest way to call http end points and is mostly useful for make special calls that are not covered in HttpApiClient class.

Api Calls | easy!
-----------------

For calling HTTP endpoints **sending String body, url-parameters, WWWForms parameters, or your data objects, and receiving raw string or data objects back** you should use **HttpApiClient.** This class uses a fluent syntax and is easy to use. It's mostly useful for making Api calls.

RESTful CRUD endpoints
---------------------------

If you have a **fully RESTful** resource on an api endpoint, you can use **CrudClient** class. this one works mainly based on conventions. it uses HTTP methods to reach for objects in server, adding, deleting and updating them. Using **CrudClient** you will not deal with http protocol, and you will just use create,read,update and delete methods.

OAuth
-------
Since RESTful resources are usually protected and accessing them, needs authorization, you will need to add authorization headers into your requests, which is easy using an interceptor. but first you would need to login to your authorization server and receive a token. for that, you would use **OAuthClient** class. This class provides *login()*, *refresh()* and *revoke()* methods.


Example Codes:
==========



Issues Bugs
=======




