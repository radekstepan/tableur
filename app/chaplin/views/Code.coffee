Chaplin = require 'chaplin'

module.exports = class CodeView extends Chaplin.View

    container:       '#main'
    containerMethod: 'append'
    autoRender:      true

    getTemplateFunction: -> require 'chaplin/templates/code'

    getTemplateData: -> 'text': @model.get 'code'

    afterRender: ->
        super

        $(@el).attr 'id', 'code'

        @