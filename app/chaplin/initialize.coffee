Tableur = require 'chaplin/Application'
Spreadsheets = require 'chaplin/models/Spreadsheets'

$ ->
    $.getJSON '/api/docs', (data) ->
        window.Spreadsheets = new Spreadsheets data
        window.App = new Tableur()