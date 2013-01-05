Chaplin = require 'chaplin'

module.exports = class TableView extends Chaplin.View

    container:       '#main'
    containerMethod: 'append'
    autoRender:      true

    getTemplateFunction: -> require 'chaplin/templates/table'

    afterRender: ->
        super

        $(@el).attr 'id', 'table'

        # Populate with our data.
        for key, value of @model.get 'sheet'
            $(@el).find("td[data-cell=#{key}]").text value

        @

        # Re-render on change.
        @modelBind 'change', @render

        # Monitor doubleclicks on the cells to make them editable.
        @delegate 'dblclick', 'table td', @edit

        @delegate 'click', 'table', @cancel

        # Monitor keyups in contentEditable areas.
        @delegate 'keyup', 'table td.edit', @save

    # Make cell editable.
    edit: (e) ->
        td = $(e.target)
        unless td.hasClass 'edit'
            # Read-only for all cells.
            @read()
            # Make this one editable.
            td.addClass('edit').attr 'contenteditable', true

    # Read-only for all cells.
    read: ->
        # Read-only for all cells.
        $(@el).find('td.edit').each (i, el) ->
            $(el).removeClass('edit').attr 'contenteditable', false

    # Cancel field editing?
    cancel: (e) ->
        unless $(e.target).hasClass 'edit' then @read()

    # Save cell on model.
    save: (e) ->
        td = $(e.target)
        # Get the value.
        sheet = @model.get('sheet')
        sheet[td.attr('data-cell')] = td.text() # do not allow html
        @model.set 'sheet', sheet