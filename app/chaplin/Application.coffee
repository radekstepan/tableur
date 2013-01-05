Chaplin = require 'chaplin'

AppView = require 'chaplin/views/App'
CodeView = require 'chaplin/views/Code'
TableView = require 'chaplin/views/Table'

# The application object.
module.exports = class Tableur

    constructor: ->
        # The listing of docs.
        docs = window.Spreadsheets

        # Which doc do we want?
        path = window.location.pathname

        # Grab first doc if none specified.
        if path is '/' then model = docs.at(0)
        else
            # Grab the name of the doc from the URL.
            name = path.split('/').pop() # last part
            model = docs.find( (doc) -> doc.get('name') is name )

        # We better have a model by now.
        assert model, 'Spreadsheet model needs to be defined'

        # Create the app view.
        app = new AppView 'collection': docs, 'model': model

        render = (data, message) ->
            # Clear any content.
            $(app.el).find('#main').html('')

            # Set the content on our skeleton model.
            model.set 'code':  data.code
            model.set 'sheet': data.sheet

            # In full View.
            new TableView
                'model': model
                'height': app.height()
                'codeView': codeView = new CodeView
                    'model': model
                    'height': app.height()

            # Show message.
            codeView.message.apply @, message

        # Fetch the doc.
        $.ajax
            'url': "/api/docs/#{model.get('name')}"
            'dataType': 'json'
            'success': (data) ->
                render data, [ 'Done', 'success' ]
            'statusCode':
                500: (data) ->
                    data = JSON.parse(data.responseText)
                    render data, [ data.message, 'error' ]
