express = require('express')
mongoskin = require('mongoskin')
bodyParser = require('body-parser')

app = express()
app.use bodyParser()

db = mongoskin.db 'mongodb://@localhost:27017/stutz_survey_api',  safe : true 

app.param 'collectionName', (req, res, next, collectionName) ->
  req.collection = db.collection collectionName
  next()

app.get '/', (req, res) ->
	res.send 'invalid collection'

app.get '/collections/:collectionName', (req, res, next) ->
	req.collection.find {}, 
		limit : 10
		sort : [['_id', -1]]
	.toArray (e, results) ->
		return next e if e
		res.send results
app.post '/collections/:collectionName', (req, res, next) ->
	req.collection.insert req.body, (e, results) ->
		return next e if e
		res. send results

app.get '/collections/:collectionName/:id', (req, res, next) ->
	req.collection.findById req.params.id, (e, result) ->
		return next e if e
		res.send result

app.put '/collections/:collectionName/:id', (req, res, next) ->
	req.collection.updateById req.params.id, 
		$set : req.body,
		(e, result) ->
			return next e if e
			res.send( if result is 1 then msg : 'success' else  msg : 'error')

app.del '/collections/:collectionName/:id', (req, res, next) ->
	req.collection.removeById req.params.id, 
		(e, result) ->
			return next e if e
			res.send( if result is 1 then msg : 'success' else  msg : 'error')

app.listen 3000

console.log 'Listening on 3000'