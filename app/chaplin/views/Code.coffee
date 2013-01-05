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

        # Listen to messages, we show them.
        Chaplin.mediator.subscribe 'message', @message

        # Init CodeMirror.
        editor = CodeMirror.fromTextArea $(@el).find('textarea')[0],
            'theme': 'tableur'

        # Save to Model on change.
        editor.on 'change', (ed, chn) => @model.set 'code', ed.getValue()

        # Adjust textarea height.
        $(@el).find('.CodeMirror').css 'height', @options.height

        @

    dispose: ->
        # Kill timeout.
        clearTimeout(@time)

        # Continue...
        super

    # Show a message.
    message: (text, type="alert") =>
        clearTimeout(@time) # stop any previous timeout first
        $(@el).find('#message').text(text).attr('class', type).css('opacity', 1) # set message
        @time = setTimeout @clear, 4000 # set it to clear in a while

    # Clear message.
    clear: =>
        (msg = $(@el).find('#message')).animate
            'opacity': 0
        ,
            'queue': false
            'duration': 450
            'complete': ->
                msg.text('').attr('class', '')