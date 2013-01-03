Tableur = require 'chaplin/core/Application'
Spreadsheets = require 'chaplin/models/Spreadsheets'

$ ->
    $.getJSON 'api/spreadsheets', (data) ->
        window.Spreadsheets = new Spreadsheets data
    
        window.App = new Tableur()
        window.App.initialize()