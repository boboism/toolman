// open first diagram in index page while using search button
open_first_diagram_on_load = function() {
  var reg = new RegExp("text%5D=$");
  var reg1 = new RegExp("text%5D=");
  if(window.location.search.substr(1).match(reg1) && !window.location.search.substr(1).match(reg)) {
    $(".my-table tbody tr:first .btn:first").trigger('click');
  }
}

// fix ie browser can not focus while using html5 autofocus properties
focus_input = function() {
  $(".container .search-query").focus();
}

$(function() {
  focus_input();
});
