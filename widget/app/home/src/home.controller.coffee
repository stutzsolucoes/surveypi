stutzSurveyApp.controller 'HomeController', ['$http', ($http) ->
	home = @
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
		console.log(home.survey)
		return;
	return
]