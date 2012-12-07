
async = require 'async'
jade = require 'jade'
fs = require 'fs'
path = require 'path'
identify = require 'identify'
typogr = require 'typogr'

{TemplatePlugin} = require './../templates'

class JadeTemplate extends TemplatePlugin

  constructor: (@fn) ->

  render: (locals, callback) ->
    try
      rendered = @fn locals
      rendered = typogr.typogrify rendered
      identified = identify rendered,
        block_elements: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p']
        anchor: true
      callback null, new Buffer identified
    catch error
      callback error

JadeTemplate.fromFile = (filename, base, callback) ->
  fullpath = path.join base, filename
  async.waterfall [
    (callback) ->
      fs.readFile fullpath, callback
    (buffer, callback) =>
      try
        rv = jade.compile buffer.toString(),
          filename: fullpath
          pretty: true
        callback null, new this rv
      catch error
        callback error
  ], callback

module.exports = JadeTemplate

