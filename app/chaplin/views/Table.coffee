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
            $(@el).find("td[data-cell=#{key}]").html value

        @

        # Re-render on change.
        @modelBind 'change', @render

        # Monitor doubleclicks on the cells to make them editable.
        @delegate 'dblclick', 'table td', @edit

        # Monitor keyups in contentEditable areas.
        @delegate 'keyup', 'table td.edit', @save

    # Make cell editable.
    edit: (e) ->
        td = $(e.target)
        unless td.hasClass 'edit'
            # Read-only for all cells.
            $(@el).find('td.edit').each (i, el) ->
                $(el).removeClass('edit').attr 'contenteditable', false
            # Make this one editable.
            td.addClass('edit').attr 'contenteditable', true

    # Save cell on model.
    save: (e) ->
        td = $(e.target)
        # Get the value.
        sheet = @model.get('sheet')
        sheet[td.attr('data-cell')] = td.text()
        @model.set 'sheet', sheet