stutzSurveyApp.controller 'HomeController', ['$http', ($http) ->
	home = @
	@ajaxStatus = 0
	$http.get stutzSurveyApp.apiURL + '/opened_survey/53e2ee0d4a83eb980fea5603'
	.success (data, status, headers, config) ->
		home.survey = data
		for question in home.survey.questions 
			question.answear = []
			question.answear.push {"option" : option, checked : false} for option in question.options
			
	.error (data, status, headers, config) ->
		home.survey = null
		console.log status
	@submitSurvey = () ->
		answear = {}
		answear.survey_id = home.survey._id	
		answear.questions = []
		answear.questions.push {"question_id": question._id, "answear" : question.answear} for question in home.survey.questions
		home.ajaxStatus = 1
		$http.post stutzSurveyApp.apiURL + '/opened_survey/answear',
			answear
		.success (data, status, headers, config, statusText ) ->
			home.ajaxStatus = 0
		.error (data, status, headers, config, statusText ) ->
			home.ajaxStatus = -1
		return;
	return
]