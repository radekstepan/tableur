Chaplin = require 'chaplin'

module.exports = class AppView extends Chaplin.View

    container:       'body'
    containerMethod: 'html'
    autoRender:      true

    getTemplateFunction: -> require 'chaplin/templates/body'

    getTemplateData: -> 'docs': @collection.toJSON(), 'active': @model.toJSON()

    afterRender: ->
        super

        @delegate 'click', '#execute', @exec

        @

    # Determine the height of the viewport we can fill with content.
    height: ->
        x = $(window).height() -
        $('header').outerHeight() -
        parseInt($('#main').css('padding-top')) -
        parseInt($('#main').css('padding-bottom'))

    # Execute the code over the sheet messaging to the air.
    exec: ->
        @model.save {},
            'success': (model, response, options) =>
                Chaplin.mediator.publish 'message', 'Done', 'success'
            'error': (model, xhr, options) =>
                Chaplin.mediator.publish 'message', JSON.parse(xhr.responseText).message, 'error'