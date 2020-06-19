// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require codemirror
//= require codemirror/modes/javascript
//= require codemirror/modes/css
//= require codemirror/modes/ruby
//= require codemirror/modes/xml
//= require codemirror/modes/htmlmixed

//= require codemirror/addons/fold/foldcode
//= require codemirror/addons/fold/brace-fold
//= require codemirror/addons/fold/comment-fold
//= require codemirror/addons/fold/foldgutter
//= require codemirror/addons/fold/indent-fold
//= require codemirror/addons/fold/markdown-fold
//= require codemirror/addons/fold/xml-fold

//= require codemirror/addons/scroll/annotatescrollbar
//= require codemirror/addons/search/search
//= require codemirror/addons/search/matchesonscrollbar
//= require codemirror/addons/search/searchcursor
//= require codemirror/addons/search/match-highlighter

//= require codemirror/addons/hint/show-hint
//= require codemirror/addons/hint/javascript-hint
//= require codemirror/addons/hint/css-hint
//= require codemirror/addons/hint/xml-hint
//= require codemirror/addons/hint/html-hint
//= require codemirror/addons/hint/anyword-hint

//= require codemirror/addons/dialog/dialog

//= require codemirror/addons/edit/matchbrackets
//= require codemirror/addons/edit/closebrackets

//= require codemirror/addons/comment/comment

//= require codemirror/addons/wrap/hardwrap

//= require codemirror/keymaps/sublime

//= require jquery-ui/tabs


var codeFoldOptions = {
    tabSize: 2,
    autoCloseBrackets: true,
    matchBrackets: true,
    showCursorWhenSelecting: true,
    keyMap: "sublime",
    highlightSelectionMatches: {showToken: /\w/, annotateScrollbar: true},
    extraKeys: {"Ctrl-Space": "autocomplete", "Ctrl-Q": function(cm){ cm.foldCode(cm.getCursor()); }},
    foldGutter: true,
    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
    foldOptions:{
      widget: '↤↦'
    }
  };
