cs = require 'coffee-script'

# Error catcher.
catcher = (e, cb) ->
    err = e
    if err.name and err.message then err = err.name + ': ' + err.message
    return cb err, null

module.exports = (code, sheet, cb) ->
    # Early bath?
    if code.length is 0 then return cb null, sheet

    # Get the tokens used in the code.
    tokens = cs.tokens code

    # Find all the references to the cells and stop badies getting in.
    badies = [ 'require', 'global' ]
    columns = []
    extract = (arr) ->
        isCell = (text) -> (new RegExp(/^[A-Z]{1}$/)).test text # A-Z single letters
        for item in arr
            if item instanceof Array
                [ obj, name ] = item
                if typeof obj is 'string'
                    if obj is 'IDENTIFIER'
                        if name in badies then throw "Error: Illegal IDENTIFIER `#{name}` found"
                        if isCell(name) and name not in columns then columns.push name
                else
                    extract item

    try
        extract tokens
    catch e
        return catcher e, cb

    # First create array vars for the columns in use.
    defs = ( column + ' = []' for i, column of columns )

    # Prefix the code with definition of these vars from existing spreadsheet.
    valueOf = (cell) ->
        # Numbers.
        if not isNaN(parseFloat(value)) and isFinite(value) then value
        # Strings.
        else "'#{value}'"#.replace /<(?:.|\n)*?>/gm, ''

    # Traverse our sheet.
    for cell, value of sheet
        # Which cell is it?
        [ column, row ] = cell.match(/([A-Z])(\d+)/)[1...]
        # Is it one of our columns we are using in the code?
        if column in columns
            # Push it on the defs list.
            defs.push "#{column}[#{row}] = #{valueOf value}"

    # Actually add it to the code.
    code = [ '# Cell definitions follow.', defs.join('\n'), '# Code follows.', code ].join('\n')

    # Add a code collecting the values back.
    gets = ( "global.scooper.#{column} = #{column}" for column in columns )
    code = [ code, '# Getters follow.', gets.join('\n') ].join('\n')

    # Make ref to global object fetching the values.
    global.scooper = {}

    try
        # Compile CS to JS.
        code = cs.compile code
        # Eval... yup.
        eval code
    catch e
        return catcher e, cb

    # All went well, set the sheet values back after computation.
    for column, data of global.scooper
        # Maybe the user has reassigned the Array to something else?
        if data instanceof Array
            for row, value of data when value # some cells are undefined
                sheet[column + row] = value

    cb null, sheet