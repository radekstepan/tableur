Chaplin = require 'chaplin'

module.exports = class TableView extends Chaplin.View

    container:       '#main'
    containerMethod: 'append'
    autoRender:      true

    getTemplateFunction: -> require 'chaplin/templates/table'

    initialize: ->
        # Re-render when new calculation comes in.
        Chaplin.mediator.subscribe 'message', (text, type) =>
            if type is 'success' then @jqxUpdate()

    afterRender: ->
        super

        $(@el).attr 'id', 'table'

        # Render jqxGrid.
        @jqxRender()

        @

    # Convert Model to jqx localData.
    modelToJqx: ->
        localData = []
        for key, value of @model.get('sheet')
            [ column, row ] = (key.match /([A-Z])(\d+)/)[1...]
            localData[row] ?= {}
            localData[row][column] = value
        localData

    # Update the jqxGrid.
    jqxUpdate: ->
        # Convert Model into a jqx localData object.
        @localData = @modelToJqx()

        # Better have this.
        assert @source, 'Do not have source for jqxGrid'

        @source.localdata = @localData
        # Bind to the new source.
        $('#table #jqx').jqxGrid 'source': @source

    # Render the jqxGrid.
    jqxRender: ->
        # Convert Model into a jqx localData object.
        @localData = @modelToJqx()

        # Render the columns.
        datafields = [] ; columns = []
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
            
            # Column.
            columns.push
                'text': text
                'datafield': text
                'width': 90
                'renderer': (value) -> "<div>#{value}</div>"

        @source =
            'localdata': @localData
            'datatype': 'array'
            'unboundmode': true
            'totalrecords': 100 # 0-99
            'datafields': datafields
            # On row update, update the underlying Model.
            'updaterow': (row, data) =>
                # Get the previous state.
                sheet = @model.get('sheet')

                for column, value of data
                    # Is cell non-empty?
                    if value.length isnt 0
                        # Has it changed from last time?
                        if not @localData[row][column] or @localData[row][column] isnt value
                            # Update the localData for next time (if we do not re-render or something).
                            @localData[row][column] = value
                            # Update the Spreadsheet.
                            sheet[column + row] = value
                    else
                        # Maybe we were clearing a previously set cell.
                        if @localData[row][column]
                            # Update the localData for next time (if we do not re-render or something).
                            delete @localData[row][column]
                            delete sheet[column + row]

                # One set.
                @model.set 'sheet', sheet

        # Make into dataAdapter.
        dataAdapter = new $.jqx.dataAdapter @source,
            downloadComplete: (data, status, xhr) ->
                # console.log 'downloadComplete', data, status, xhr
            loadComplete: (data) ->
                # console.log 'loadComplete', data
            loadError: (xhr, status, error) ->
                # console.log 'loadError', xhr, status, error

        # Initialize jqxGrid.
        $('#table #jqx').jqxGrid
            'width': $('#table').outerWidth()
            'height': @options.height
            'source': dataAdapter
            'editable': true
            'columnsresize': true
            'selectionmode': "singlecell"
            'theme': ''
            'columns': columns