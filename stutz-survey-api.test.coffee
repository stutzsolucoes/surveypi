superagent = require 'superagent'
expect = require 'expect.js'

describe 'stutz survey api', ->
  it 'post object', (done) ->
    superagent.post 'http://localhost:3000/surveys/test' 
      .send 
        name: 'Stutz'
        email: 'stutz@stutzsolucoes.com.br'
      
      .end (e,res) ->
        #console.log(res.body)
        expect e 
          .to.eql null
        expect res.body.length
          .to.eql 1
        expect res.body[0]._id.length 
          .to.eql 24 
        id = res.body[0]._id
        done()

  it 'retrieves an object', (done) ->
    superagent.get 'http://localhost:3000/surveys/test/'+id 
      .end (e, res) ->
        #console.log(res.body)
        expect e 
          .to.eql null
        expect typeof res.body
          .to.eql 'object'
        expect res.body._id.length
          .to.eql 24        
        expect res.body._id
          .to.eql id         
        done()
      
  it 'retrieves a collection', (done) ->
    superagent.get 'http://localhost:3000/surveys/test'
      .end (e, res) ->
        #console.log(res.body)
        expect e
          .to.eql null 
        expect res.body.length
          .to.be.above 0
        expect res.body.map (item) ->
            item._id
          .to.contain id
        done()

  it 'updates an object', (done) ->
    superagent.put 'http://localhost:3000/surveys/test/'+id
      .send
        name: 'New Stutz'
        email: 'new@stutzsolucoes.com.br'
      .end (e,res) ->
        expect e 
          .to.eql null
        expect typeof res.body
          .to.eql 'object'
        expect res.body.msg
          .to.eql 'success'  
        done()

  it 'checks an updated object', (done) ->
    superagent.get 'http://localhost:3000/surveys/test/'+id 
      .end (e,res) ->
        expect e 
          .to.eql null
        expect typeof res.body
          .to.eql 'object'
        expect res.body._id.length
          .to.eql 24        
        expect res.body._id
          .to.eql id         
        expect res.body.name
          .to.eql 'New Stutz'         

  it 'removes an object', (done) ->
    superagent.del 'http://localhost:3000/surveys/test/'
      .end (e,res) ->
        expect e 
          .to.eql null
        expect typeof res.body
          .to.eql 'object'
        expect res.body.msg
          .to.eql 'success'  
        done()



