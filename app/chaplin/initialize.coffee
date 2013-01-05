# Simple assertion class.
class AssertException

    constructor: (@message) ->

    toString: -> "AssertException: #{@message}"

# Set the assertion on the window object.
@.assert = (exp, message) -> throw new AssertException(message) unless exp

Tableur = require 'chaplin/Application'
Spreadsheets = require 'chaplin/models/Spreadsheets'

$ ->
    $.getJSON '/api/docs', (data) ->
        window.Spreadsheets = new Spreadsheets data
        window.App = new Tableur()