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

        # Setup toolbar.
        @setToolbar()

        # Render jqxGrid.
        @jqxRender()

        @

    # Setup toolbar actions.
    setToolbar: ->
        # Get all the toolbar actions.
        $(@el).find('#toolbar a.action').each (i, el) =>
            # Which action is it?
            action = $(el).attr('data-action')
            # Set event.
            $(el).click (e) =>
                # Do we have a cell selected?
                if @selectedCell
                    # Get current spreadsheet.
                    sheet = @model.get 'sheet'
                    # Store new sheet here.
                    neuf = {}
                    # Everything with letter `row` and above need to shift by one.
                    for cell, value of sheet
                        # Get cell's column, row.
                        [ column, row ] = (cell.match /([A-Z])(\d+)/)[1...]
                        # Enforce int on row.
                        row = parseInt row
                        
                        # Shift based on action.
                        switch action
                            when 'row-above'
                                if row >= @selectedCell.row then cell = column + (row + 1)
                            when 'row-below'
                                if row > @selectedCell.row then cell = column + (row + 1)
                            when 'column-left'
                                column = column.charCodeAt(0) - 65
                                if column >= @selectedCell.column then cell = String.fromCharCode(column + 66) + row
                            when 'column-right'
                                column = column.charCodeAt(0) - 65
                                if column > @selectedCell.column then cell = String.fromCharCode(column + 66) + row

                        # Save into new.
                        neuf[cell] = value

                    # Set the new model.
                    @model.set 'sheet', neuf
                    # Update the grid.
                    @jqxUpdate()

    # Convert Model to jqx localData.
    modelToJqx: ->
        # For jqx to work, we need to at least init all rows, cannot be unset.
        localData = ( {} for i in [0...50] )

        # Actually insert Model data.
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
            'updaterow': @updateRow

        # Make into dataAdapter.
        dataAdapter = new $.jqx.dataAdapter @source,
            downloadComplete: (data, status, xhr) ->
                # console.log 'downloadComplete', data, status, xhr
            loadComplete: (data) ->
                # console.log 'loadComplete', data
            loadError: (xhr, status, error) ->
                # console.log 'loadError', xhr, status, error

        # Initialize jqxGrid.
        grid = $('#table #jqx').jqxGrid
            'width': $('#table').width()
            'height': @options.height - 29
            'source': dataAdapter
            'editable': true
            'columnsresize': true
            'selectionmode': "singlecell"
            'theme': ''
            'columns': columns

        # Capture these events.
        grid.on 'cellselect', @selectCell

    # Update jqx row in Model.
    updateRow: (row, data) =>
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

        # One set event.
        @model.set 'sheet', sheet

    # Event on selecting a cell.
    selectCell: (event) =>
        @selectedCell =
            'column': event.args.datafield.charCodeAt(0) - 65 # column in index form too
            'row': event.args.rowindex