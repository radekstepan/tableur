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
                    'vendor/js/backbone-0.9.2.js',
                    'vendor/js/jqx/jqxcore.js',
                    'vendor/js/jqx/jqxdata.js',
                    'vendor/js/jqx/jqxbuttons.js',
                    'vendor/js/jqx/jqxscrollbar.js',
                    'vendor/js/jqx/jqxgrid.js',
                    'vendor/js/jqx/jqxgrid.edit.js',
                    'vendor/js/jqx/jqxgrid.selection.js',
                    'vendor/js/jqx/jqxgrid.columnsresize.js',
                    'vendor/js/codemirror/codemirror.js',
                    'vendor/js/codemirror/coffeescript.js'
                ]

        stylesheets:
            joinTo:
                'css/app.css': /^app\/styles/
                'css/vendor.css': /^vendor\/css/
            order:
                before: [
                    'vendor/css/foundation3.css', # Foundation 3
                    'vendor/css/jqx.css', # jqx
                    'vendor/css/codemirror.css' # CodeMirror
                ]
                after: [
                    'app/styles/app.styl', # app style
                    'app/styles/codemirror.css' # CodeMirror style
                ]

        templates:
            joinTo: 'js/app.js'

    server:
        path: 'server.coffee'
        port: 7431
        run: yes