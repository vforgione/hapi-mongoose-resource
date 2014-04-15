# hapi-mongoose-resource
> resourceful mongoose objects for the hapi framework

* easily create handlers for your mongoose models
* automatically generate routes for your handlers
* resourceful use of references for api responses


## installation
__npm__

```
$ npm install hapi-mongoose-handler
```

__clone into project__

```
$ cd /path/to/your/vendor/sources/
$ git clone https://github.com/vforgione/hapi-mongoose-resource.git
$ cd hapi-mongoose-resource
$ npm install
$ coffee -o ./lib -c ./src
```

that last coffee compile shouldn't be necessary, but do it just in case i forget to do it before committing.


## documentation
all api documentation can be found on the projects github page:
[http://vforgione.github.io/hapi-mongoose-resource](http://vforgione.github.io/hapi-mongoose-resource).


## issues and feature requests
open tickets on the project's issues tab:
[https://github.com/vforgione/hapi-mongoose-resource/issues](https://github.com/vforgione/hapi-mongoose-resource/issues).
i'll try to get to them as soon as i can.


## pull requests
if you really took the time to fork this and make some improvements, by all means send me a pull request:
[https://github.com/vforgione/hapi-mongoose-resource/pulls](https://github.com/vforgione/hapi-mongoose-resource/pulls).

please test things out first before issuing a request.


## tests
the tests are written for mocha (hence the `mocha.opts` file). compile the coffee script, fire up mongo, and run `npm test`.
this will invoke the `Makefile`, which will run the tests.


## examples
there is an `examples` directory in the project - it's simple but it covers things pretty well: rolling a hapi server,
setting up schemas and models, creating resources, adding routes.

i also included a few sample payloads in a comment at the bottom of `examples/app.coffee`. however you issue them,
it will give a shallow jumping-off point.

to get it going:

```
$ cd /path/to/resource/tests
$ coffee -c ./
$ node app.js
```

and take it from there.


## why
__tl;dr__ i missed [tastypie](https://github.com/toastdriven/django-tastypie).

i am a python developer, thoroughly. however, i am beginning to embrace node. i've done a number of api projects with
python and tastypie, and it's a great combination. i wanted to emulate its ease of use and ubiquity.

i also have done some cursory test-drives with other node frameworks, but i found [hapi](https://github.com/spumko/hapi)
to be the best fit for me.

given these two points, i went in search of a solid resource plugin for hapi. i was disappointed.
[hapi-mongoose-handler](https://github.com/craveprogramminginc/hapi-mongoose-handler) got me close to where i wanted to be,
but it just wasn't the end-all-be-all. (sidebar: it is pretty damned solid and much of my handler code was inspired
by hmh). i wanted something to take away the redundancy of creating router configs. i also wanted easy linking between
referenced docs. i also wanted the minty-freshest hapi version to be supported.

right now, the project isn't super verbose. i will add to it in the future, i just wanted a jumping-off point.
