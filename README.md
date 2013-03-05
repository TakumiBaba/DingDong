express-station
===============

templates for node.js + express

Initialize
----------
	$ git clone https://github.com/akiroom/express-station
	$ cd express-station
	$ npm install

Start
-----
	$ npm start

Production Evironment
---------------------
**Start**

	$ npm install -g forever
	$ npm start

**Stop**

	$ npm stop

How To Edit
-----------
* `/routes.coffee` defines routes for controllers.
* `/controllers/*.coffee` defines controllers written by Coffee-Script.
* `/views/*.coffee` defines views written by Jade.
* `/assets/css/*.less` defines stylesheets for views written by LESS.
* `/assets/js/*.cofffee` defines scripts for views written by CoffeeScript.
* `/public/**/*` should be used to put static files.

References
----------
* [node.js](http://nodejs.org/)
* [express](http://expressjs.com/)
* [Jade](http://jade-lang.com/)
* [LESS](http://lesscss.org/)
* [CoffeeScript](http://coffeescript.org/)
* [jQuery](http://jquery.com/)
* [Underscore.js](http://underscorejs.org/)

License
-------

**MIT License**

Copyright (c) 2012- akiroom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
