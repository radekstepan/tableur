Chaplin = require 'chaplin'

module.exports = class TableView extends Chaplin.View

    container:  '#table'
    autoRender: true

    getTemplateFunction: -> require 'chaplin/templates/table'