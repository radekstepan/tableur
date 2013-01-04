Chaplin = require 'chaplin'

module.exports = class TableView extends Chaplin.View

    container:       '#main'
    containerMethod: 'append'
    autoRender:      true

    getTemplateFunction: -> require 'chaplin/templates/table'

    afterRender: ->
        super

        console.log @model.get 'sheet'

        $(@el).attr 'id', 'table'

        # Populate with our data.
        for key, value of @model.get 'sheet'
            $(@el).find("td[data-cell=#{key}]").html value

        @