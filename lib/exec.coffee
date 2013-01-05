cs = require 'coffee-script'

module.exports = (code, sheet, cb) ->    
    # Clean up cs, fs, console, require refs.
    # require = console = fs = undefined

    # Get the tokens used in the code.
    tokens = cs.tokens code

    # Find all the references to the cells, recursively.
    cells = []
    (extract = (arr) ->
        isCell = (text) -> (new RegExp(/([A-Z])(\d+)/)).test text
        for item in arr
            if item instanceof Array
                [ obj, name ] = item
                if typeof obj is 'string'
                    if obj is 'IDENTIFIER' and isCell(name) and name not in cells then cells.push name
                else
                    extract item
    ) tokens

    # Prefix the code with definition of these vars.
    valueOf = (cell) ->
        # Not set yet?
        unless sheet[cell] then return "''"

        # Get the value.
        value = sheet[cell]

        # Numbers.
        if not isNaN(parseFloat(value)) and isFinite(value) then value
        # Strings.
        else "'#{value}'"#.replace /<(?:.|\n)*?>/gm, ''

    defs = ( "#{cell} = #{valueOf cell}" for cell in cells )
    code = defs.join('\n') + '\n' + code

    # Add a code collecting the values back.
    gets = ( "global.sheet.#{cell} = #{cell}" for cell in cells )
    code = code + '\n' + gets.join('\n')

    # Make ref to global.
    global.sheet = sheet

    try
        # Compile CS to JS.
        code = cs.compile code
        # Eval... yup.
        eval code
    catch e
        err = e
        if err.name and err.message then err = err.name + ': ' + err.message
        return cb err, null

    cb null, sheet