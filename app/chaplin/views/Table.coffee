Chaplin = require 'chaplin'

module.exports = class TableView extends Chaplin.View

    container:       '#main'
    containerMethod: 'append'
    autoRender:      true

    getTemplateFunction: -> require 'chaplin/templates/table'

    getTemplateData: -> console.log @model.get 'sheet'

    afterRender: ->
        super

        $(@el).attr 'id', 'table'

        @