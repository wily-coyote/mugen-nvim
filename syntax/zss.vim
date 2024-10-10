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

syn case ignore
syn match zssVariable /\$[a-zA-Z\.\_][a-zA-Z0-9\.\_]\{}/ 
syn match zssIdentifierFunction /[a-zA-Z\.\_][a-zA-Z0-9\.\_]\{}/ 
syn match zssIdentifierParameter /[a-zA-Z\.\_][a-zA-Z0-9\.\_]\{}/ contained
syn match zssFunction /[a-zA-Z\.\_][a-zA-Z0-9\.\_]\{}\_s\{-}{/ contains=zssIdentifierFunction
syn region zssSection start="\[" end="\]" contains=zssNumber,zssComment
syn cluster zssExpression contains=zssNumber,zssIdentifierFunction,zssVariable,zssString
"syn match zssParameter /\([a-zA-Z\.][a-zA-Z0-9\.]\{}\s\{}:\)\_.\{-}[\;\}]/ transparent contains=zssIdentifierParameter,@zssExpression
syn match zssParameter /\([a-zA-Z\.][a-zA-Z0-9\.]\{}\s\{}:\)/ transparent contains=zssIdentifierParameter
syn match zssNumber /[0-9]\?\.[0-9]\+\|[0-9]\+/
syn keyword zssStatement if else switch case default call let
syn keyword zssModifier ignorehitpause persistent
syn keyword zssOperator "!" "~" "-" "**" "*" "/" "%" "+" "-" ">" ">=" "<" "<=" "\=" "!=" ":=" "&" "^" "\|" "&&" "^^" "\|\|"
syn region zssString start=+"+ skip=+\\"+  end=+"+
syn region zssComment start="#" end="$"
hi link zssSection Statement
hi link zssStatement Statement
hi link zssModifier Function
hi link zssNumber Number
hi link zssString String
hi link zssIdentifierParameter String
hi link zssIdentifierFunction Function
hi link zssComment Comment
hi link zssOperator Operator
hi link zssVariable Identifier
