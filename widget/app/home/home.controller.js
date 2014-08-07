// Generated by CoffeeScript 1.7.1
(function() {
  stutzSurveyApp.controller('HomeController', [
    '$http', function($http) {
      var home;
      home = this;
      $http.get(stutzSurveyApp.apiURL + '/opened_survey/53e2ee0d4a83eb980fea5603').success(function(data, status, headers, config) {
        var option, question, _i, _len, _ref, _results;
        home.survey = data;
        _ref = home.survey.questions;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          question = _ref[_i];
          question.answear = [];
          _results.push((function() {
            var _j, _len1, _ref1, _results1;
            _ref1 = question.options;
            _results1 = [];
            for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
              option = _ref1[_j];
              _results1.push(question.answear.push({
                "option": option,
                checked: false
              }));
            }
            return _results1;
          })());
        }
        return _results;
      }).error(function(data, status, headers, config) {
        home.survey = null;
        return console.log(status);
      });
      this.submitSurvey = function() {
        console.log(home.survey);
      };
    }
  ]);

}).call(this);