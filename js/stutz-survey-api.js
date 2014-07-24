// Generated by CoffeeScript 1.7.1
(function() {
  var app, bodyParser, db, express, mongoskin;

  express = require('express');

  mongoskin = require('mongoskin');

  bodyParser = require('body-parser');

  app = express();

  app.use(bodyParser());

  db = mongoskin.db('mongodb://@localhost:27017/stutz_survey_api', {
    safe: true
  });

  app.param('collectionName', function(req, res, next, collectionName) {
    req.collection = db.collection(collectionName);
    return next();
  });

  app.get('/', function(req, res) {
    return res.send('invalid collection');
  });

  app.get('/collections/:collectionName', function(req, res, next) {
    return req.collection.find({}, {
      limit: 10,
      sort: [['_id', -1]]
    }).toArray(function(e, results) {
      if (e) {
        return next(e);
      }
      return res.send(results);
    });
  });

  app.post('/collections/:collectionName', function(req, res, next) {
    return req.collection.insert(req.body, function(e, results) {
      if (e) {
        return next(e);
      }
      return res.send(results);
    });
  });

  app.get('/collections/:collectionName/:id', function(req, res, next) {
    return req.collection.findById(req.params.id, function(e, result) {
      if (e) {
        return next(e);
      }
      return res.send(result);
    });
  });

  app.put('/collections/:collectionName/:id', function(req, res, next) {
    return req.collection.updateById(req.params.id, {
      $set: req.body
    }, function(e, result) {
      if (e) {
        return next(e);
      }
      return res.send(result === 1 ? {
        msg: 'success'
      } : {
        msg: 'error'
      });
    });
  });

  app.del('/collections/:collectionName/:id', function(req, res, next) {
    return req.collection.removeById(req.params.id, function(e, result) {
      if (e) {
        return next(e);
      }
      return res.send(result === 1 ? {
        msg: 'success'
      } : {
        msg: 'error'
      });
    });
  });

  app.listen(3000);

  console.log('Listening on 3000');

}).call(this);