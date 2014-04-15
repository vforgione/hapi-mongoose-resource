
_ = require 'lodash'


Resource = require '../lib/resource'

Hapi = require 'hapi'
Mongoose = require 'mongoose'


Mongoose.connect 'mongodb://127.0.0.1:27017/test'
server = new Hapi.createServer 'localhost', 3000, {}


FunctionalTestSchema = new Mongoose.Schema { name: String, height: Number, hungry: Boolean }
FunctionalTestModel = Mongoose.model 'FunctionalTestModel', FunctionalTestSchema


payloads = [
  { name: 'alpha', height: 10, hungry: false }
  { name: 'beta', height: 11, hungry: true }
  { name: 'gamma', height: 7, hungry: true }
  { name: 'delta', height: 14, hungry: false }
  { name: 'epsilon', height: 10, hungry: false }
]


describe 'handler [functional tests]', ->

  handler = {}
  ids = []

  before ->
    resource = new Resource FunctionalTestModel, '/functional-test-models'
    handler = resource.handler
    server.route resource.router.routes

  after ->
    server.stop

  describe 'create', ->

    responses = []

    before ->
      for payload in payloads
        server.inject { method: 'POST', url: '/functional-test-models', payload: payload }, (res) ->
          responses.push res
          ids.push res.result._id

    it 'should post and return status 200', (done) ->
      for res in responses
        res.statusCode.should.equal 200
      done()

    it 'should return a full document', (done) ->
      expected_keys = ['resource_uri', 'name', 'height', 'hungry']
      for res in responses
        for key in expected_keys
          res.result._doc.should.have.property key
      done()

  describe 'find', ->

    response = {}

    it 'response returns a 200 status code', (done) ->
      server.inject { method: 'GET', url: '/functional-test-models' }, (res) ->
        response = res
        res.statusCode.should.equal 200
        done()

    it 'response has a meta property', (done) ->
      response.result.should.have.property 'meta'
      done()

    it 'response has an objects property', (done) ->
      response.result.should.have.property 'objects'
      done()

    describe 'response.meta', ->

      it 'should have keys ["page_size", "total_count", "previous", "next"]', (done) ->
        expected_keys = ['page_size', 'total_count', 'previous', 'next']
        for key in expected_keys
          response.result.meta.should.have.property key
        done()

  describe 'find with pagination', ->

    response = {}

    it 'response returns a 200 status code', (done) ->
      server.inject { method: 'GET', url: '/functional-test-models?limit=2' }, (res) ->
        response = res
        res.statusCode.should.equal 200
        done()

    it 'response.meta.previous should be null', (done) ->
      (response.result.meta.previous == null).should.equal true
      done()

    it 'response.meta.next should be /functional-test-models?skip=2&limit=2', (done) ->
      response.result.meta.next.should.equal '/functional-test-models?skip=2&limit=2'
      done()

  describe 'find with simple filter', ->

    response = {}

    it 'response returns a 200 status code', (done) ->
      server.inject { method: 'GET', url: '/functional-test-models?height=10' }, (res) ->
        response = res
        res.statusCode.should.equal 200
        done()

    it 'response.objects should be populated with objects', (done) ->
      for doc in response.result.objects
        _.isObject(doc).should.equal true
      done()

  describe 'find with mongodb filter', ->

    response = {}

    it 'response returns a 200 status code', (done) ->
      server.inject { method: 'GET', url: '/functional-test-models?name={"$in":["alpha","gamma"]}' }, (res) ->
        response = res
        res.statusCode.should.equal 200
        done()

    it 'response.objects should be populated with objects', (done) ->
      for doc in response.result.objects
        (_.isObject doc).should.equal true
      done()

  describe 'find_one', ->

    payload = { name: 'zeta', height: 7 }
    response = {}

    it 'response returns a 200 status code', (done) ->
      server.inject { method: 'POST', url: '/functional-test-models', payload: payload }, (res) ->
        doc = res.result
        server.inject { method: 'GET', url: '/functional-test-models/' + doc._id }, (res2) ->
          response = res2.result
          res2.statusCode.should.equal 200
          done()

    it 'response to query should include the payload', (done) ->
      for key, value of payload
        response[key].should.equal value
      done()

  describe 'update', ->

    original = { name: 'eta', height: 10, hungry: true }
    updated = { name: 'eta', height: 9, hungry: false }
    response = {}
    id = 0

    it 'response returns a 200 status code', (done) ->
      server.inject { method: 'POST', url: '/functional-test-models', payload: original }, (res) ->
        doc = res.result
        id = doc._id
        server.inject { method: 'UPDATE', url: '/functional-test-models/' + id, payload: updated }, (res2) ->
          response = res2.result
          res2.statusCode.should.equal 200
          done()

    it 'response should include the update payload and maintain original id', (done) ->
      for key, value of updated
        response[key].should.equal value
      String(response['_id']).should.equal String(id)
      done()

  describe 'delete', ->

    payload = { name: 'theta', height: 5 }
    id = 0
    response = {}

    it 'response returns a 200 status code', (done) ->
      server.inject { method: 'POST', url: '/functional-test-models', payload: payload }, (res) ->
        id = res.result._id
        server.inject { method: 'DELETE', url: '/functional-test-models/' + id }, (res2) ->
          response = res2.result
          res2.statusCode.should.equal 200
          done()

    it 'a "find_one" following should return a 404 status code', (done) ->
      server.inject { method: 'GET', url: '/functional-test-models/' + id }, (res) ->
        res.statusCode.should.equal 404
      done()
