
Hapi = require 'hapi'
Mongoose = require 'mongoose'
_ = require 'lodash'

Resource = require '../src'

Schema = Mongoose.Schema


describe 'testing api', ->

  Thing = {}
  MyRef = {}
  my_ref = {}
  my_ref_id = {}
  server = {}
  id = ''

  before ->
    Mongoose.connect 'mongodb://127.0.0.1:27017/test'

    ref_schema = new Schema {
      name: String
    }

    MyRef = Mongoose.model 'MyRef', ref_schema

    my_ref = new MyRef { name: 'some ref' }
    my_ref.save
    my_ref_id = my_ref._id
    my_ref_resource = new Resource MyRef, '/my_refs'

    schema = new Schema {
      name:       String,
      binary:     Buffer,
      living:     Boolean,
      updated:    { type: Date, default: Date.now }
      age:        { type: Number, min: 18, max: 65 }
      mixed:      Schema.Types.Mixed,
      _someId:    { type: Schema.Types.ObjectId, ref: MyRef },
      array:      [],
      ofString:   [String],
      ofNumber:   [Number],
      ofDates:    [Date],
      ofBuffer:   [Buffer],
      ofBoolean:  [Boolean],
      ofMixed:    [Schema.Types.Mixed],
      ofObjectId: [Schema.Types.ObjectId],
      nested: {
        stuff: { type: String, lowercase: true, trim: true }
      }
    }

    Thing = Mongoose.model 'Thing', schema

    server = new Hapi.createServer 'localhost', 3000, {}

    resource = new Resource Thing, "/things", { refs: { _someId: my_ref_resource } }
    server.route resource.router.routes

  it 'create a thing', (done) ->
    payload = {
      name: 'the test thing'
      binary: new Buffer 0
      living: true
      updated: new Date
      age: 28
      mixed: {anything: {i_want: true}, why: ['because', 'i', 'can']}
      _someId: my_ref_id
      array: []
      ofString: ['another', 'array']
      ofNumber: [1, 2, 3]
      ofDates: [new Date]
      ofBuffer: [new Buffer(1)]
      ofBoolean: [true, false]
      ofMixed: ['this', 'is', 'mixed', true, {}]
      nested: {
        stuff: 'LOWERCASE ME'
      }
    }
    server.inject { method: 'POST', url: '/things', payload: payload }, (res) ->
      id = res.result._id
      res.statusCode.should.equal 200
      done()

  it 'find one thing', (done) ->
    server.inject { method: 'GET', url: '/things/' + id }, (res) ->
      res.statusCode.should.equal 200
      res.result.name.should.equal 'the test thing'
      # should will test against the model, not the actual response object -- need to shallow copy
      shallow = _.clone res.result._doc
      shallow.should.have.property 'resource_uri'
      shallow._someId.should.equal '/my_refs/' + my_ref_id
    done()

  it 'find all things', (done) ->
    server.inject { method: 'GET', url: '/things' }, (res) ->
      res.statusCode.should.equal 200
      # should will test against the model, not the actual response object -- need to shallow copy
      for model in res.result
        shallow = _.clone model._doc
        shallow.should.have.property 'resource_uri'
        shallow._someId.should.equal '/my_refs/' + my_ref_id
    done()

  it 'find things with a filter', (done) ->
    server.inject { method: 'GET', url: '/things?age=28' }, (res) ->
      res.statusCode.should.equal 200
      # should will test against the model, not the actual response object -- need to shallow copy
      for model in res.result
        shallow = _.clone model._doc
        shallow.should.have.property 'resource_uri'
        shallow._someId.should.equal '/my_refs/' + my_ref_id
    done()

  it 'find things with a mongo find filter', (done) ->
    server.inject { method: 'GET', url: '/things?age={"$gt":18,"$lt":45}' }, (res) ->
      res.statusCode.should.equal 200
      # should will test against the model, not the actual response object -- need to shallow copy
      for model in res.result
        shallow = _.clone model._doc
        shallow.should.have.property 'resource_uri'
        shallow._someId.should.equal '/my_refs/' + my_ref_id
    done()

  it 'update a thing', (done) ->
    server.inject { method: 'UPDATE', url: '/things/' + id, payload: { name: 'the updated test thing' } }, (res) ->
      res.statusCode.should.equal 200
      res.result.name.should equal 'the updated test thing'
      # should will test against the model, not the actual response object -- need to shallow copy
      shallow = _.clone res.result._doc
      shallow.should.have.property 'resource_uri'
      shallow._someId.should.equal '/my_refs/' + my_ref_id
    done()

  it 'destroy a thing', (done) ->
    server.inject { method: 'DELETE', url: '/things/' + id }, (res) ->
      res.statusCode.should.equal 200
      # should will test against the model, not the actual response object -- need to shallow copy
      shallow = _.clone res.result._doc
      shallow.should.have.property 'resource_uri'
      shallow._someId.should.equal '/my_refs/' + my_ref_id
    done()
