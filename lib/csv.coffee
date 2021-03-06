# Escape on enforced string or empty value.
escape = (text) ->
    if text then '"' + new String(text).replace(/\"/g, '""') + '"'
    else '""'

exports.save = (data, delimiter = ',') ->
    # Make into a grid.
    sheet = []
    for key, value of data
        [ column, row ] = (key.match /([A-Z])(\d+)/)[1...] # char, not string!
        # Skip undefined or empty values.
        if value and value.length isnt 0
            sheet[row] ?= [] # init maybe?
            sheet[parseInt row][column.charCodeAt(0) - 65] = value # save the value

    # Stringify.
    for i, row of sheet
        row = ( escape(column) for column in row )
        sheet[i] = row

    # Join the lines.
    sheet.join "\n"

exports.read = (data, delimiter = ',') ->
    # Early bath?
    if data.length is 0 then return {}

    # Create a regular expression to parse the CSV values.
    objPattern = new RegExp(
        (
            # Delimiters.
            "(\\" + delimiter + "|\\r?\\n|\\r|^)" +

            # Quoted fields.
            "(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +

            # Standard fields.
            "([^\"\\" + delimiter + "\\r\\n]*))"
        ), "gi")
    
    # Hold the spreadsheet here.
    sheet = {}
    
    # Hold matches here.
    matches = null
    
    # Where are we in the file?
    row = 0 ; column = 0

    # Keep looping over the regular expression matches.
    while matches = objPattern.exec data
        # Get the delimiter that was found.
        [ foundDelimiter, quoted, value ] = matches[1...]
        
        # A new row if we reach an unknown delimiter.
        if foundDelimiter and (foundDelimiter isnt delimiter)
            row++ ; column = 0
        
        # Unescape any double quotes if we found a quoted value.
        if quoted then value = quoted.replace(new RegExp("\"\"", "g"), "\"")

        # Add it, no checking whether we can work it.
        if value and value.length isnt 0
            sheet[String.fromCharCode(65 + column++) + row] = value
        else
            # We can have empty cells, move index then.
            column++

    # Return the parsed data.
    sheet