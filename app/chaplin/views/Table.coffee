Chaplin = require 'chaplin'

module.exports = class TableView extends Chaplin.View

    container:       '#main'
    containerMethod: 'append'
    autoRender:      true

    getTemplateFunction: -> require 'chaplin/templates/table'

    afterRender: ->
        super

        $(@el).attr 'id', 'table'

        # Init jqxGrid.
        @jqx()

        # Re-render when new calculation comes in.
        Chaplin.mediator.subscribe 'message', (text, type) =>
            if type is 'success' then @render()

        @

    # Render the jqxGrid.
    jqx: ->
        # Convert Model into a jqx localData object.
        @localData = localData = []
        for key, value of @model.get('sheet')
            [ column, row ] = (key.match /([A-Z])(\d+)/)[1...]
            localData[row] ?= {}
            localData[row][column] = value

        datafields = [] ; columns = []

        # Render the columns.
        for i in [0...26] # A-Z
            text = String.fromCharCode(65 + i) # column by letter
            
            # Fixed row number column.
            if i is 0
                columns.push
                    'pinned': true
                    'exportable': false
                    'text': ''
                    'columntype': 'number'
                    'cellclassname': 'jqx-grid-row-header'
                    'cellsrenderer': (row, column, value) -> "<div>#{value}</div>"
            
            datafields.push 'name': text
            
            # Normal cell column.
            columns.push
                'text': text
                'datafield': text
                'width': 90
                'renderer': (value) -> "<div>#{value}</div>"
        
        source =
            'localdata': localData
            'datatype': 'array'
            'unboundmode': true
            'totalrecords': 100 # 0-99
            'datafields': datafields
            # On row update, update the underlying Model.
            'updaterow': (row, data) =>
                for column, value of data
                    # Is cell non-empty?
                    if value.length isnt 0
                        # Has it changed from last time?
                        if not @localData[row][column] or @localData[row][column] isnt value
                            # Update the localData for next time (if we do not re-render or something).
                            @localData[row][column] = value
                            # Update the Spreadsheet.
                            sheet = @model.get('sheet')
                            sheet[column + row] = value
                            @model.set 'sheet', sheet

        # initialize jqxGrid
        $('#table div').jqxGrid
            'width': $('#table').outerWidth()
            'height': @options.height
            'source': new $.jqx.dataAdapter source
            'editable': true
            'columnsresize': true
            'selectionmode': "singlecell"
            'theme': ''
            'columns': columns