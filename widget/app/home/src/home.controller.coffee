stutzSurveyApp.controller 'HomeController', ['$http', ($http) ->
	home = @
	@ajaxStatus = 0
	@answear = { customAttributes : {} }
	$http.get stutzSurveyApp.apiURL + '/opened_survey/53e84dee8e332be419f63148'
	.success (data, status, headers, config) ->
		home.survey = data
		for surveyQuestion in home.survey.questions 
			surveyQuestion.question.answear = []
			surveyQuestion.question.answear.push {"option" : option, checked : false} for option in surveyQuestion.question.options
			
	.error (data, status, headers, config) ->
		home.survey = null
		console.log status
	@submitSurvey = () ->
		home.answear.survey_id = home.survey._id	
		home.answear.questions = []
		home.answear.questions.push {"question_id": surveyQuestion.question._id, "answear" : surveyQuestion.question.answear} for surveyQuestion in home.survey.questions
		home.ajaxStatus = 1
		$http.post stutzSurveyApp.apiURL + '/opened_survey/answear',
			home.answear
		.success (data, status, headers, config, statusText ) ->
			home.ajaxStatus = 0
		.error (data, status, headers, config, statusText ) ->
			home.ajaxStatus = -1
		return;
	return
]