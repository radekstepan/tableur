cs = require 'coffee-script'

module.exports = (code, sheet, cb) ->    
    # Clean up cs, fs, console, require refs.
    # require = console = fs = undefined

    # Get the tokens used in the code.
    tokens = cs.tokens code

    # Find all the references to the cells, recursively.
    cells = []
    (extract = (arr) ->
        for item in arr
            if item instanceof Array
                if typeof item[0] is 'string'
                    if item[0] is 'IDENTIFIER' and item[1] not in cells then cells.push item[1]
                else
                    extract item
    ) tokens

    # Prefix the code with definition of these vars.
    valueOf = (cell) ->
        # Not set yet?
        unless sheet[cell] then return "''"

        # Get the value.
        value = sheet[cell]

        # Working with floats, integers and strings coming from CSV.
        isFloat = (n) -> n is +n and n isnt (n | 0)
        isInteger = (n) -> n is +n and n is (n | 0)
        
        if isFloat(value) or isInteger(value) then value
        else "'#{value}'"

    defs = ( "#{cell} = #{valueOf cell}" for cell in cells )
    code = defs.join('\n') + '\n' + code

    # Add a code collecting the values back.
    gets = ( "global.sheet.#{cell} = #{cell}" for cell in cells )
    code = code + '\n' + gets.join('\n')

    # Make ref to global.
    global.sheet = sheet

    try
        # Compile CS to JS.
        code = cs.compile code, 'bare': 'on'
        # Eval... yup.
        eval code
        cb null, sheet
    catch e
        err = e
        if err.name and err.message then err = err.name + ': ' + err.message
        cb err, null