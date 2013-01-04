Chaplin = require 'chaplin'

module.exports = class Spreadsheet extends Chaplin.Model

    url: -> [ '/api', 'docs', @get('name') ].join('/')

    initialize: ->
        @set 'nice', @get('name').replace /-|_/g, ' '

        @