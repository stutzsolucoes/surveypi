express = require 'express' 
mongoskin = require 'mongoskin'
bodyParser = require 'body-parser'
superagent = require 'superagent'
async = require 'async'

app = express()
app.use bodyParser()

app.use (req, res, next) ->
	res.setHeader 'Access-Control-Allow-Origin','*';
	res.setHeader 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()

#db = mongoskin.db 'mongodb://stutz:Str4igh0Thr0ugh@200.150.207.77:27017/stutz_survey_api',  safe : true 
db = mongoskin.db 'mongodb://localhost:27017/stutz_survey_api',  safe : true 

app.param 'collectionName', (req, res, next, collectionName) ->
  req.collection = db.collection collectionName
  next()
  #check the credentials
  #res.status 500
  #next(new Error('invalid credentials'));

##
# begin of Survey API specific services
##
getQuestions = (questionIds, questionsRetrieved) ->
	async.map questionIds, (questionId, callback) ->
		superagent.get 'http://localhost:3000/survey_question/'+questionId 
		.end (e, res) ->
			return callback(e,null) if e isnt null
			callback(null, res.body) #returns the processed item
	,
	(err, results) ->
		questionsRetrieved(results) #this callback is invoked when all the items on the array passed to the map functiona are completed


app.get '/opened_survey/:id', (req, res, next) ->
	superagent.get 'http://localhost:3000/survey/'+req.params.id 
		.end (e, response) ->
			return res.send [] if not response.body.questions?
			survey = response.body
			questionIds = survey.questions
			survey.questions = []
			getQuestions questionIds, (questionsReceived) ->
				survey.questions = questionsReceived
				res.send(survey)

app.post '/opened_survey/answear', (req, res, next) ->
	collection = db.collection 'survey_answear'
	collection.insert req.body, (e, results) ->
		return next e if e
		res. send results

 
##
# end of Survey API specific services
##


app.get '/', (req, res) ->
	res.status 503
	res.send 'invalid request'

##
# begin of CRUD services
##
#list all collection elements
app.get '/:collectionName', (req, res, next) ->
	req.collection.find {}, 
		limit : 10
		sort : [['_id', -1]]
	.toArray (e, results) ->
		return next e if e
		res.send results

#filters a collection elements
#req.body is the filter
app.get '/:collectionName', (req, res, next) ->
	req.collection.find req.body, 
		limit : 100
		sort : [['_id', -1]]
	.toArray (e, results) ->
		return next e if e
		res.send results		

#create a collection element
app.post '/:collectionName', (req, res, next) ->
	req.collection.insert req.body, (e, results) ->
		return next e if e
		res. send results

#get a collection element by id
app.get '/:collectionName/:id', (req, res, next) ->
	req.collection.findById req.params.id, (e, result) ->
		return next e if e
		res.send result

#updates a collection element using id
app.put '/:collectionName/:id', (req, res, next) ->
	req.collection.updateById req.params.id, 
		$set : req.body,
		(e, result) ->
			return next e if e
			res.send( if result is 1 then msg : 'success' else  msg : 'error')

#removes a collection element by id
app.del '/:collectionName/:id', (req, res, next) ->
	req.collection.removeById req.params.id, 
		(e, result) ->
			return next e if e
			res.send( if result is 1 then msg : 'success' else  msg : 'error')
##
# end of CRUD services
##

app.listen 3000

console.log 'Listening on 3000'