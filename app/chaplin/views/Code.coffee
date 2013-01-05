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

        # Save.
        @delegate 'keyup', 'textarea', @save

        # Listen to messages, we show them.
        Chaplin.mediator.subscribe 'message', @message

        # Adjust textarea height.
        $(@el).css 'height', @options.height

        @

    # Show a message.
    message: (text, type="alert") =>
        $(@el).find('#message').text(text).attr 'class', type

    # Clear message.
    clear: ->
        $(@el).find('#message').text('').attr 'class', ''

    # Save the model.
    save: ->
        @model.set 'code', $(@el).find('textarea').val()