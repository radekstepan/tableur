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

    # Execute the code over the sheet messaging to the air.
    exec: ->
        @model.save {},
            'success': (model, response, options) =>
                Chaplin.mediator.publish 'message', 'Ready', 'success'
            'error': (model, xhr, options) =>
                Chaplin.mediator.publish 'message', JSON.parse(xhr.responseText).message, 'error'