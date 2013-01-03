Chaplin = require 'chaplin'

module.exports = class CodeView extends Chaplin.View

    container:  '#code'
    autoRender: true

    getTemplateFunction: -> require 'chaplin/templates/code'