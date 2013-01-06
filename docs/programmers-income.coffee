# Currency multipliers.
currencies = {}
for key in [1...6] when H[key] and I[key]
  currencies[H[key]] = I[key]

# Convert amount into USD.
toDollars = (text) ->
  return 0 unless text # empties
  [ amount, currency ] = text.split(' ')
  amount * currencies[currency]

# Main runner.
calc = (col) ->
  # Salary in monthly USD.
  salary = toDollars(col[2]) / 12
  # Get child edu cost in USD.
  edu = toDollars(col[3])
  # Get personal and child expenses in USD.
  exp = toDollars(I[7]) + toDollars(I[8])
  # Adjust expenses by living costs.
  exp = exp * col[1]
  # Extra costs incurred?
  extra = toDollars(col[4])
  # Show result.
  col[6] = Math.floor salary - edu - exp - extra
  # Is it sustainable?
  if col[6] < 0 then col[7] = 'Not enough!'
  # Add the currency.
  col[6] = col[6] + ' USD'

# Run the calc on these columns.
( calc(col) for col in [ B, C, D, E, F ] )