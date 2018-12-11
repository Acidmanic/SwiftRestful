

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

Intereception
---------------

Using interceptors, it's possible to change request params before sending a request. The most common example can be adding authorization token to request headers. for that, you can create a class which implements the **HttpRequestInterceptor** protocol. then in *onRequest()* method, you can make any changes you need on the requestParam object. currently rejecting of a request is not supported in http request interception.


Example Codes:
==========

Download an Html page using **HttpClient**:

```swift

    let client = HttpClient()

    client.download(url: "http://www.google.com", method:HttpMethod.GET,
        headers:[:],contentData:nil){ (result:HttpResponse<Data>) in

        let sResult = String(data:result.Value,encoding:result.ResponseCharsetEncoding)
        
        print(sResult)
    }
```
using **HttpApiClient**:

```swift

    let client = HttpApiClient()

    client.get.url("http://www.google.com").request(){(result:HttpResponse<String>) in
    
        print(result.Value)
    }

```

Getting and **object** using **HttpApiClient**:

```swift

    let client = HttpApiClient()

    client.get.url("http://jsonplaceholder.typicode.com/todos/12")
        .request(){(result:HttpResponse<Todo>) in
        
            // take any action needed with received object
            let todoObject = result.Value
            
}
```
the **Todo** class mentioned in this example, is a simple class with four fields: title, body and userId and id. you can find its definition in SwiftRestfulTests/TestModels/Todo.swift.

Post Object, Receive Object  using **HttpApiClient**:

```swift

    let client = HttpApiClient()

    let todo = Todo(title: "NewTodo", body: "TestObject", userId: 123)
    
    client.post.url("http://jsonplaceholder.typicode.com/todos")
    .jsonData(todo).request(){(result:HttpResponse<Todo>) in

        // take any action needed with received object
        let todoObject = result.Value
    }
```
Post data using xwwwForm:

```swift
    let client = HttpApiClient()

    client.post.url("http://jsonplaceholder.typicode.com/todos")
    .xwwwFormData(["title":"NewTodo","body":"dodo","userId":"123"])
    .request(){(result:HttpResponse<Todo>) in
    
        // take any action needed with received object
        let todoObject = result.Value
    }
```
you can also use **HttpApiClient**.*put*, **HttpApiClient**.*delete* and **HttpApiClient**.*patch* for update, delete and partially update tasks.

Getting and object with Id=12 from the server, using Crud client:

```swift
    let client = CrudClient(endpoint: "http://jsonplaceholder.typicode.com/todos")

    client.read(params: ["id":"12"]) { (result:Todo!) in
        // if successful, result is the object
        // if not, then result will be nil
    }
```

a crud create example:

```swift
    let client = CrudClient(endpoint: "http://jsonplaceholder.typicode.com/todos")

    let createdTodo = Todo(title: "NetworkTest", body: "PerformNetworkTest", userId: 123)

    client.create(object: createdTodo){(result:Todo) in
        // if successful, the result will be created objec
        // usually with its id set. and in case of unsuccessful
        // call, result will be nil.
    
    }

```

and a crud delete example:

this will try to delete a user which has the id = 12, from the http://reqres/api/users

```swift
    let client = CrudClient(endpoint: "http://reqres.in/api/users")

    client.delete(params: ["id":"12"]){(succeed:Bool) in
        // 🤔 pretty clear, right?
    }

```

Defining your Data Object Transfers
-----------------------------------------

For your DTOs to be used easily in http client classes of this library, these classes should confirm to the Jsonable protocol.
which means they are responsible to fill their fields from a given json data. this given json data, is infact the dictionary that
is produced from swift's halfway deserialization. let see an example:

```swift
class User:Jsonable{

    var name:String!
    var email:String!


    required init(){}
    
    func load(jsonData: JsonMediumType!) {
    
        self.name = jsonData["name"] as? String
        
        self.email = jsonData["email"] as? String
    }
}
```

this User class, can be now used to be sent to, or to be received from the server using **HttpApiClient** or **CrudClient**.  But
when the number of fields and their type variaty increases, it will become a lot harder to convert these values to what is needed for each field. in the other hand, we might want to support more than one NamingConventions for received jsons to cover a situation where backend is not uniform about naming conventions and etc. to make this conversion easier and also support multipile naming conventions, you can drive your DTO class from  **NamingRitchJsonable** base class. this way you will have access to conversion methods for fields (*getString(), getInt(),getDouble(),...*). also you can select which naming conventions you want to accept. conversion methods will use these conventions to parse the field name and pick correct pice of data from jsonData.

example:

```swift
class User:NamingRitchJsonableBase,Jsonable{

    var name:String!
    var email:String!
    var id:Int!


    required override init(){
        self.acceptingNamingConventions =
            [NamingConventions.CamelCase,NamingConventions.PascallCase]
    }

    func load(jsonData: JsonMediumType!) {

        self.name = getString(jsonData,"name")

        self.email = getString(jsonData,"email")
        
        self.id = getInt(jsonData,"id")
    }
}
```

this way, both jsons strings: ```{"name":"mani","email":"acidmanic.moayedi@gmail.com","id":12}``` and ```{"Name":"mani","Email":"acidmanic.moayedi@gmail.com","Id":12}``` will be parsed to the same object with valid values.

Jsonabe, supports nested Jsonabe classes. you can Jsonable fields in each Jsonable object and the conversions will work properly. for example consider our user have a Todo object field. then it would look like:


```swift
class User:NamingRitchJsonable,Jsonable{

    var name:String!
    var email:String!
    var id:Int!
    var todo:Todo!

    required override init(){
        self.acceptingNamingConventions =
            [NamingConventions.CamelCase,NamingConventions.PascallCase]
    }

    func load(jsonData: JsonMediumType!) {

        self.name = getString(jsonData,"name")

        self.email = getString(jsonData,"email")

        self.id = getInt(jsonData,"id")
        
        self.todo = getJsonable(jsonData,"todo")
    }
}
```

OAuth
-------

Currently **OAuthClient** class can perform login with *password* grant_type. it can login by username and password, refresh a previously received token and revoke a token.

```swift

    let client = OAuthClient(baseUrl: "", clientId: "TestClient" , clientSecret:"secret")

    client.login(url: "https://apifest-live.herokuapp.com/oauth20/tokens"
        , username: "mani", password: "mani") { (result:HttpResponse<LoginResult>) in

        if HttpClient.isReponseOK(code: result.ResponseCode){
            // provided access_token :
            let access_token = result.Value.access_token
        }
    }

```
refreshing a token:

```swift
    let client = OAuthClient(baseUrl: "", clientId: "TestClient" , clientSecret:"secret")

    client.refresh(url: "https://apifest-live.herokuapp.com/oauth20/tokens"
        , refreshToken: "mani") { (result:HttpResponse<LoginResult>) in
        
        if HttpClient.isReponseOK(code: result.ResponseCode){
            // provided access_token :
            let access_token = result.Value.access_token
        }
    }
```


revoking a token:

```swift

    let client = OAuthClient(clientId: "TestClient" , clientSecret:"secret")

    client.revoke(url: "https://apifest-live.herokuapp.com/oauth20/tokens/revoke",
        accessToken: "mani") { (result:Bool) in
        // succeeded = result
    }
```

Authorization interception
-----------------------------

to add authorization token to all requests from a specific client, first you should create an Interceptor class. for example:

```swift

public class AuthorizationInterceptor:HttpRequestInterceptor{

    var accessToken:String!

    public func onRequest(requestParams:HttpRequestParameters)->HttpRequestParameters{
    
        if self.accessToken != nil {
            requestParams.headers[HttpHeaderCollection.Authorization]
                = HttpHeaderCollection.AuthorizationBearerPrefix + self.accessToken
        }
        
        return requestParams
    }
}
```
this can be a shared object, or a singleton or etc. you can push such object in your clients interceptors. an interceptor can be added to a client or globally to all instances of the client class.

```swift
    let interceptor = AuthorizationInterceptor()
    
    interceptor.accessToken = "mani"
    // add interceptor to current client only
    client.pushInstanceInterceptor(interceptor:interceptor)
```
```swift
    let interceptor = AuthorizationInterceptor()

    interceptor.accessToken = "mani"
    
    // add interceptor to any request that is beeing made by a CrudClient object
    CrudClient.pushGlobalInterceptor(interceptor:interceptor)
    
    // add interceptor to any request that is beeing made with all ApiClients and therefore all CrudClients *
    HttpApiClient.pushGlobalInterceptor(interceptor:interceptor)
    
    // add interceptor to any request that is beeing made with this library *
    HttpClient.pushGlobalInterceptor(interceptor:interceptor)
```

* CrudClient objects, use HttpApiClients internally. and HttpApiClients internally use HttpClients. so if set an interceptor globally in lower level, all higher levels will be affected consequently.


Issues Bugs
=======




