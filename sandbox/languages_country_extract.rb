# In order to decode language_table.txt

reg_exps = [
  /(\w+)\s+-?((\w|\s|')+)?\s+(\w+)\s+((\w+|-)+)/,
  /(\w+)\s+((\w|\s|')+)\s+(\w+)/,
  /(\w+)\s+((\w|\s|')+)/
  /(\w+)/,

  /(\w+)\s+-?((\w|\s|')+)?\s+(\w+)\s+((\w+|-)+)\s+:?\s+((\w|\s|')+)/,
  /(\w+)\s+((\w|\s|')+)\s+(\w+)\s+:?\s+((\w|\s|')+)/,
  /(\w+)\s+((\w|\s|')+)\s+:?\s+((\w|\s|')+)/
  /(\w+)\s+:?\s+((\w|\s|')+)/
]

# Find regexp the best matches line. Discard any matching of a single char.