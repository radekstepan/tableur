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
        new AppView 'collection': @docs, 'model': model

        new CodeView()
        new TableView()