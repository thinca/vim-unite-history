" unite source: history
" Version: 0.1.2
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\   'action_table': {},
\ }

function! s:source.gather_candidates(args, context)  " {{{2
  return map(filter(map(reverse(range(1, histnr(self.type))),
  \                     '[v:val, histget(self.type, v:val)]'),
  \                 'v:val[1] != ""'), '{
  \   "word" : v:val[1],
  \   "kind" : "command",
  \   "action__command": v:val[1],
  \   "action__type": self.type,
  \   "action__index": v:val[0],
  \ }')
endfunction


let s:action_table = {
\   'delete': {
\     'description': 'delete from history',
\     'is_selectable': 1,
\   },
\ }

function! s:action_table.delete.func(candidates)  " {{{2
  call map(a:candidates, 'histdel(v:val.action__type, v:val.action__index)')
endfunction

let s:source.action_table.command = s:action_table



function! unite#sources#history#define()
  return map([{'name': 'command', 'type': ':'},
  \           {'name': 'search', 'type': '/'}],
  \      'extend(copy(s:source),
  \       extend(v:val, {"name": "history/" . v:val.name,
  \      "description": "candidates from history of " . v:val.name}))')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
