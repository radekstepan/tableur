Chaplin = require 'chaplin'

routes = require 'chaplin/core/routes'

require 'chaplin/lib/assert'

# The application object.
module.exports = class Tableur extends Chaplin.Application

    title: 'tableur'

    data: {}

    initialize: ->
        super

        # Initialize core components
        @initDispatcher
            'controllerPath':   'chaplin/controllers/'
            'controllerSuffix': ''

        # So that nice Controller switching works...
        @layout = new Chaplin.Layout {@title}

        # Register all routes and start routing
        @initRouter routes

        # Freeze the application instance to prevent further changes
        Object.freeze? @