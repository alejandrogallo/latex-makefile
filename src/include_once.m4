define(`include_once',
  `ifdef(`__included__$1',,`define(`__included__$1')dnl
`#' File: $1
include($1)
')'
)
