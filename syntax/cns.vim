"    mugen-nvim: Provides syntax highlighting to Neovim for M.U.G.E.N
"    Copyright (C) 2023 wily-coyote
"
"    This program is free software: you can redistribute it and/or modify
"    it under the terms of the GNU General Public License as published by
"    the Free Software Foundation, either version 3 of the License, or
"    (at your option) any later version.
"
"    This program is distributed in the hope that it will be useful,
"    but WITHOUT ANY WARRANTY; without even the implied warranty of
"    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"    GNU General Public License for more details.
"
"    You should have received a copy of the GNU General Public License
"    along with this program.  If not, see <https://www.gnu.org/licenses/>.

" CNS-related highlighting
syn match cnsNumber /[0-9]\{-}\.[0-9]\+\|[0-9]\+/
syn region cnsString start=+"+	end=+"+
syn keyword cnsOperator ! ~ - ** * / % + - > >= < <= = != := & ^ | "&&" ^^ "||"
syn match cnsIdentifier /[a-zA-Z][a-zA-Z0-9]*/
" INI-related highlighting
syn region cnsComment start=";"	end="$"
syn region cnsSection start="^\s\{-}\["	end="\]" contains=cnsNumber
syn match cnsKey /^\s*[a-zA-Z][a-zA-Z0-9._\-]*/
hi link cnsComment Comment
hi link cnsSection Statement
hi link cnsNumber Number
hi link cnsString String
hi link cnsKey String
hi link cnsOperator Operator
hi link cnsIdentifier Function
