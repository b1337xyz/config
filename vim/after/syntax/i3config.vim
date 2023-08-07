syn match myVariable /^\$\w\+\s\+.*/ contains=i3ConfigVariable,i3ConfigString

" Focus wrapping
syn match i3ConfigFocusWrapping /^\s*\(force_\)\?focus_wrapping\s\+\(yes\|no\|workspace\|force\)\s\?$/ contains=i3ConfigFocusWrappingType,i3ConfigFocusWrappingKeyword
