superagent = require 'superagent'
expect = require 'expect.js'

describe 'unidesc Smartphone survey', ->
  @timeout 1000
  id = null

  regularEnd = (e, res) ->
    #console.log(res.body)
    expect e 
      .to.eql null #ensure that there were no errors
    expect res.body.length
      .to.be.above 0 #ensure that something has been done
    expect res.body[0]._id.length 
      .to.eql 24 
    for obj in res.body
      obj._id

  survey_id = null;
  it 'Criar o questionario', (done) ->
    superagent.post 'http://localhost:3000/survey'
      .send
        title: 'Perfil de uso de smartphones dos alunos do Unidesc'        
      .end (e, res) ->
        survey_id = regularEnd(e, res)[0]
        console.log(survey_id)
        done()

  it 'criar questões da pesquisa de uso smartphones', (done) ->
    superagent.post 'http://localhost:3000/survey_question' 
      .send [           
            type : 1 #single option selection
            title : 'Você possui Smartphone? Qual modelo?' 
            options : [
              'Não possuo'
              'Android'          
              'iPhone'
              'Windows Phone'
            ]
            lastOptionLabel : 'Outro'
            lastOptionCustomAnswearEnabled : false
          , 
            type : 2 #multiple options selection
            title : 'Quais aplicativos você mais usa?' 
            options : [
              'E-mail'
              'Facebook'          
              'Twitter'
              'WhatsApp'
              'Instagram'
              'Youtube'
              'Internet banking'
              'SMS'
              'Calendário / Agenda'
              'Notas / anotações'
              'Jogos'
              'Podcast'
              'Mapas e GPS (Waze, Google Maps, iOS Maps, etc)'
              'Música (Deezer, Rdio, iTunes, Grooveshark, etc)'
            ]
            lastOptionLabel : 'Outro'
            lastOptionCustomAnswearEnabled : true
        ]
      
      .end (e,res) ->
        questions_ids = regularEnd(e, res)
        superagent.get 'http://localhost:3000/survey/' + survey_id
          .end (e, res) ->
            survey = res.body
            survey.questions = []
            survey.questions.push {"question_id" : question_id, "order" : idx} for question_id, idx in questions_ids
            delete survey._id
            survey.client_custom_attributes = []
            survey.client_custom_attributes.push "matricula_id"
            survey.client_custom_attributes.push "numero_matricula"
            survey.client_custom_attributes.push "turma_id"
            superagent.put 'http://localhost:3000/survey/' + survey_id
              .send survey
              .end (e,res) ->
                expect e 
                  .to.eql null #ensure that there were no errors
                expect typeof res.body
                  .to.eql 'object'
                expect res.body.msg
                  .to.eql 'success' 
                done()
