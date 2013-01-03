cs = require 'coffee-script'

# User code.
code = """
A[2] = 5
B[3] = "oh my"
# tricky now
C[0] = 1
"""

# Compile CS to JS wo/ closure.
code = cs.compile code, 'bare': 'on'

# Our environment.
(env = (cb) ->
    # Override require.
    require = -> throw 'Error: require is not allowed'
    # Clean up cs, fs, console refs.
    cs = undefined ; fs = undefined ; console = undefined
    
    # Link them all here for easy access.
    sheet = {}

    # Create columns [A-Z] should be enough.
    for i in [65...91]
        v = String.fromCharCode(i)
        sheet[v] = @[v] = []

    # Eval.
    try
        eval code
        cb null, sheet        
    catch e
        err = e
        if err.name and err.message then err = err.name + ': ' + err.message
        cb err, null
) (err, spreadsheet) ->
    if err then console.log err
    else console.log spreadsheet