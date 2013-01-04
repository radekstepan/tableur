module.exports = (code, sheet, cb) ->
    # Clean up cs, fs, console, require refs.
    # require = console = fs = undefined

    # Create columns [A-Z] should be enough.
    for i in [65...91]
        v = String.fromCharCode(i)
        # Rows 0 to 49.
        for j in [0...50]
            # Get the value.
            if sheet[v + j] then @[v + j] = sheet[v + j]
            # Go empty.
            else sheet[v + j] = @[v + j] = ''

    # Eval... yup.
    try
        eval code

        # It worked, so remove all 'empty' cells.
        ( delete sheet[key] for key, value of sheet when value.length is 0 )

        cb null, sheet
    catch e
        err = e
        if err.name and err.message then err = err.name + ': ' + err.message
        cb err, null