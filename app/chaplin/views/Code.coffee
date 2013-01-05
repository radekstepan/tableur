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

    dispose: ->
        # Kill timeout.
        clearTimeout(@time)

        # Continue...
        super

    # Show a message.
    message: (text, type="alert") =>
        clearTimeout(@time) # stop any previous timeout first
        $(@el).find('#message').text(text).attr 'class', type # set message
        @time = setTimeout @clear, 2000 # set it to clear in a while

    # Clear message.
    clear: =>
        $(@el).find('#message').text('').attr 'class', ''

    # Save the model.
    save: ->
        @model.set 'code', $(@el).find('textarea').val()