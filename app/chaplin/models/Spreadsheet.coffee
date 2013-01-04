Chaplin = require 'chaplin'

module.exports = class Spreadsheet extends Chaplin.Model

    initialize: ->
        @set 'nice', @get('name').replace /-|_/g, ' '

        @