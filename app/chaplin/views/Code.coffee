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

    # Show a message.
    message: (text, type="alert") ->
        $(@el).find('#message').text(text).attr 'class', type

    # Clear message.
    clear: ->
        $(@el).find('#message').text('').attr 'class', ''

    # Save the model.
    exec: ->
        @model.save 'code', $(@el).find('textarea').val(),
            'success': (model, response, options) =>
                @message 'Ready', 'success'
            'error': (model, xhr, options) =>
                @message JSON.parse(xhr.responseText).message