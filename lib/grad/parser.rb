class Grad::Parser < Parslet::Parser
  rule(:lcurly)  { str("{") }
  rule(:rcurly)  { str("}") }
  rule(:comma)   { str(",") }
  rule(:space)   { match("\s").repeat(1) }
  rule(:newline) { match("\n").repeat(1) }

  rule(:integer)    { match("[0-9]").repeat }
  rule(:identifier) { match("[a-zA-Z0-9]").repeat }

  rule(:key) {
    lcurly >>
    identifier.as(:key) >>
    (space >> identifier.as(:state)).maybe >>
    rcurly
  }

  rule(:input) {
    identifier.as(:command) >> space >> key
  }

  rule(:sleep) {
    identifier.as(:command) >> comma >> space >> integer.as(:ms)
  }

  rule(:line) { input | sleep }
  rule(:doc)  { line >> (newline >> line).repeat }
  root(:doc)
end
