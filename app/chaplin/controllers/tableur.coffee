Chaplin = require 'chaplin'
AppView = require 'chaplin/views/App'
CodeView = require 'chaplin/views/Code'
TableView = require 'chaplin/views/Table'

module.exports = class TableurController extends Chaplin.Controller

    docs: window.Spreadsheets

    historyURL: (params) -> ''

    doc: (params) ->
        # Grab first doc if none specified.
        if params.path.length is 0 then params.doc is @docs.at(0).name

        model = @docs.filter( (doc) -> doc.name is params.doc ).pop()

        # Create the app view.
        app = new AppView 'collection': @docs, 'model': model

        # Fetch the doc.
        $.ajax
            'url': "api/docs/#{model.get('name')}"
            'dataType': 'json'
            'success': (data) ->
                # Clear any content.
                $(app.el).find('#main').html('')

                new CodeView 'text': data.code
                new TableView()
            'statusCode':
                400: (data) ->
                    console.log JSON.parse(data.responseText).message