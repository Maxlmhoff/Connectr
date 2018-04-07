
# HANDSHAKE SERVER

### Login

#### call

`baseURL/login
`

**method** : POST  
**data** :   

* username : *string*
* password : *string*

#### response

```
{
    "_id": "userid"
}
```



### register

#### call

`baseURL/newuser`

**method**: POST  
**data**:  

* name : *string*
* surname : *string*
* email : *string*
* username : *string*
* password : *string*

#### response

```
{
    "username": "username",
    "name": "name",
    "surname": "surname",
    "password": "password",
    "email": "email",
    "token": "", // null by default
    "networks": {
        "facebook": {
            "active": false,
            "userID": ""
        },
        "twitter": {
            "active": false,
            "userID": ""
        },
        "snapchat": {
            "active": false,
            "userID": ""
        }
    },
    "_id": "handshake user id"
}
```
### Edit a social network
`editnetwork/<id>`

#### Call

**method** : PUT  
**data**: 

* network : *[facebook, twitter or snapchat]*
* active : *boolean*
* userID  : *user id on the social network*

**params**: 

* id : *handshake user id*

#### response

```
{
    "success": "Updated network status"
}
```

### Get user by tag token 

#### Call

`baseURL/getuserbytoken/<token>`

**method** : GET  
**params** : *tag token*

#### Response

```
{
    "name": "name",
    "surname": "surname",
    "networks": {
        "facebook": "facebook user id",
        "twitter": "twitter user id"
        //...
    }
}
```






