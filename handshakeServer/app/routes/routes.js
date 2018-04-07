
var ObjectID = require('mongodb').ObjectID

module.exports = function(app, db){


    app.get('/getuserbytoken/:token', (req, res) => {

        let token = req.params.token
        console.log(token)

        const details = {'token' : token}
        console.log(details)
        db.collection('users').findOne(details, (err, result) => {
            if (err){
                res.send({"error":"could not find user with token " + token})
            } else {
                let networks = result.networks
                
                let response = {}
                for (network in networks){
                    if (networks[network].active){
                        response[network] = networks[network].userID
                    }
                }   
                res.send(response)
            }
        })
    })

    app.get('/addtag/:id/:token', (req, res) => {

        let token = req.params.token
        let id = req.params.id
        const details = { '_id': new ObjectID(id) };

        db.collection('users').findOne(details, (err, result) => {
            
            if (err) {
                res.send({"error": "could add tag ", "details":  err})
            } else {
                let newResult = result
                newResult.token = token
                db.collection('users').update(details, newResult, (err, result) => {
                    if (err) {
                        res.send({"error": "could not add tag ", 'details' : err})
                    } else {
                        res.send({"success" : "Updated tag"})
                    }
                })
            }
        })

    })

    app.post('/newuser', (req, res) =>{
        let body = req.body
        const user = {
            username: body.username,
            name : body.name,
            surname: body.surname,
            password: body.password,
            email: body.email,
            token: 0,
            networks: {
                facebook: {
                    active: false,
                    userID: ''
                },
                twitter: {
                    active: false,
                    userID: ''
                },
                snapchat: {
                    active: false,
                    userID: ''
                }
            }
                
            
        }

        db.collection('users').insert(user, (err, result) => {
            if (err){
                res.send({"error" : "there was an error"})
            } else {
                res.send(result.ops[0])
            }
        })
    })

    app.post('/login', (req, res) => {
        let username = req.body.username
        let password = req.body.password
        let query = {'username': username}
        db.collection('users').findOne(query, (err, result) => {
            if (err){
                res.send({'error': 'there was an error :' + err})
            } else {
                if (result.password == password){
                    res.send({'_id': result._id})
                } else {
                    res.send({'error': 'invalid password'})
                }
            }
        })
    })

    app.put('/editnetwork/:id', (req, res) => {
        
        const id = req.params.id
        const details = { '_id': new ObjectID(id) };
        db.collection('users').findOne(details, (err, result) => {
            
            if (err) {
                res.send({"error": "could not update network status"})
            } else {
                let newResult = result
                newResult.networks[req.body.network] = {
                    active: req.body.active,
                    userID: req.body.userID
                }
                db.collection('users').update(details, newResult, (err, result) => {
                    if (err) {
                        res.send({"error": "could not update network status"})
                    } else {
                        res.send({"success" : "Updated network status"})
                    }
                })
            }
        })
    })

    
}