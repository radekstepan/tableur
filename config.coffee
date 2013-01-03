exports.config =
    files:
        javascripts:
            joinTo:
                'js/app.js': /^app\/chaplin/
                'js/vendor.js': /^vendor\/js/
            order:
                before: [
                    'vendor/js/jquery-1.7.2.js',
                    'vendor/js/underscore-1.3.3.js',
                    'vendor/scripts/backbone-0.9.2.js'
                ]

        stylesheets:
            joinTo:
                'css/app.css': /^app\/styles/
                'css/vendor.css': /^vendor\/css/
            order:
                before: [
                    'vendor/css/foundation3.css' # Foundation 3
                ]
                after: [
                    'app/styles/app.styl' # app style
                ]

        templates:
            joinTo: 'js/app.js'

    server:
        path: 'server.coffee'
        port: 7431
        run: yes