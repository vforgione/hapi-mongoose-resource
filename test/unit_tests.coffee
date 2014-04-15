
Resource = require '../lib/resource'

Mongoose = require 'mongoose'


UnitTestSchema = new Mongoose.Schema { name: String }
UnitTestModel = Mongoose.model 'UnitTestModel', UnitTestSchema


describe 'resource [unit tests]', ->

  resource = {}

  beforeEach ->
    resource = new Resource UnitTestModel, '/unit-test-models'

  it 'has a model property', (done) ->
    resource.should.have.property 'model'
    done()

  it 'has a path property', (done) ->
    resource.should.have.property 'path'
    done()

  it 'has an options property', (done) ->
    resource.should.have.property 'options'
    done()

  it 'has a handler property', (done) ->
    resource.should.have.property 'handler'
    done()

  it 'has a router property', (done) ->
    resource.should.have.property 'router'
    done()

  describe 'options', ->

    it 'has a resource_key property', (done) ->
      resource.options.should.have.property 'resource_key'
      done()

    it 'has a page_size property', (done) ->
      resource.options.should.have.property 'page_size'
      done()

    it 'has an omit property', (done) ->
      resource.options.should.have.property 'omit'
      done()

    it 'has a rename property', (done) ->
      resource.options.should.have.property 'rename'
      done()


describe 'router [unit tests]', ->

  router = {}

  beforeEach ->
    resource = new Resource UnitTestModel, '/unit-test-models'
    router = resource.router

  it 'has a path property', (done) ->
    router.should.have.property 'path'
    done()

  it 'has a single_path property', (done) ->
    router.should.have.property 'single_path'
    done()

  it 'has a routes property', (done) ->
    router.should.have.property 'routes'
    done()

  it 'has an options property', (done) ->
    router.should.have.property 'options'
    done()


describe 'handler [unit tests]', ->

  handler = {}

  beforeEach ->
    resource = new Resource UnitTestModel, '/unit-test-models'
    handler = resource.handler

  it 'has a model property', (done) ->
    handler.should.have.property 'model'
    done()

  it 'has a path property', (done) ->
    handler.should.have.property 'path'
    done()

  it 'has an options property', (done) ->
    handler.should.have.property 'options'
    done()
