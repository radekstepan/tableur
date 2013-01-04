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

        @delegate 'keyup', 'textarea', @exec

        @

    exec: ->
        # Save.
        @model.save 'code', $(@el).find('textarea').val(),
            'success': (model, response, options) =>
                console.log 'success'
            'error': (model, xhr, options) =>
                console.log 'error'