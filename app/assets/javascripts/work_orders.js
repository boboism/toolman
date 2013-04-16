fetch_tool_bom = function() {
  $("form[action='/work_orders/issue'] #work_order_hilt_no").on("keypress", function(e) {
    var code = e.keyCode || e.which;
    if(code != '13') return;
    e.preventDefault();

    var jqxhr = $.getJSON('/tool_boms.json?[search][text]='+$(this).val(), function(data) {
      var tool_bom    = data[0];
      var hilt_no     = tool_bom['hilt_no'];
      var issue_count  = tool_bom['issue_count'];
      $("#issue_count").val(issue_count);
      $("#work_order_work_order_items_attributes_0_serial_no").focus();
    });
  });
}

fetch_tool_bom_item = function() {
  $("form[action='/work_orders/grind'] #work_order_item_serial_no").on("keypress", function(e) {
    var code = e.keyCode || e.which;
    if(code != '13') return;
    e.preventDefault();

    var jqxhr = $.getJSON('/tool_parts.json?[search][grindable]=true&[search][serial_no]='+$(this).val(), function(data) {
      var tool_bom_item     = data[0];
      var model             = tool_bom_item['model'];
      var grinding_machine  = tool_bom_item['grinding_machine'];
      var grinding_man_hour = tool_bom_item['grinding_man_hour'];
      var grinding_mode     = tool_bom_item['grinding_mode'];
      $("#work_order_item_grinding_machine").val(grinding_machine);
      $("#work_order_item_grinding_mode").val(grinding_mode);
      $("#work_order_item_grinding_man_hour").val(grinding_man_hour);

      $("form[action='/work_orders/grind']").submit();
    });
  });
}

fetch_tool_bom_tune_info = function() {
  $("form[action='/work_orders/tune'] #work_order_hilt_no").on("keypress", function(e) {
    var code = e.keyCode || e.which;
    if(code != '13') return;
    e.preventDefault();
    var jqxhr = $.getJSON('/tool_boms.json?[search][text]='+$(this).val(), function(data) {
      var tool_bom          = data[0];
      var hilt_no           = tool_bom['hilt_no'];
      var tunning_machine   = tool_bom['tunning_machine'];
      var tunning_mode      = tool_bom['tunning_mode'];
      var tunning_man_hour  = tool_bom['tunning_man_hour'];
      if(isNaN(tunning_man_hour) || tunning_man_hour < 0) {
        tunning_man_hour = 0;
      }
      tunning_man_hour = parseInt(tunning_man_hour); 
      $("#work_order_tunning_machine").val(tunning_machine);
      $("#work_order_tunning_mode").val(tunning_mode);
      $("#work_order_tunning_man_hour").val(tunning_man_hour);

      $("form[action='/work_orders/tune']").submit(); 
    });
  });
}

focus_on_next_serial_no = function() {
  $("form[action='/work_orders/issue'] input[id^=work_order_work_order_items_attributes]").on("keypress", function(e) {
    var code = e.keyCode || e.which;
    if(code != '13') return;
    e.preventDefault();
    var reg = /work_order_work_order_items_attributes_(\d+)_serial_no/;
    var result = parseInt(reg.exec($(this).attr("id"))[1]);
    if(result < 0 || result > 10) {
      alert('Not available result:'+result);
      return;
    }
    result += 1;
    var issue_count = parseInt($("#issue_count").val());
    if(result < issue_count) {
      $("#work_order_work_order_items_attributes_"+result+"_serial_no").focus();
    } else {
      $("form[action='/work_orders/issue']").submit();
    }
  });
}

auto_submit_receive = function() {
  $("form[action='/work_orders/receive'] #work_order_hilt_no").on("keypress", function(e) {
    var code = e.keyCode || e.which;
    if(code != '13') return;
    e.preventDefault();
    $("form[action='/work_orders/receive']").submit();
  });
}

fill_blade_index_to_label = function() {
  var reg = /work_order_work_order_items_attributes_(\d+)_serial_no/;
  $("form[action='/work_orders/issue'] label.control-label[for^='work_order_work_order_items_attributes_']").each(function(index, elem){
    elem.innerHTML += " #" + (parseInt(reg.exec($(elem).attr("for"))[1])+1);
  });
}

auto_focus_new_issue_form = function() {
  $("form#new_work_order #work_order_hilt_no").focus();
} 

auto_focus_new_grind_form = function() {
  $("form#new_work_order_item #work_order_item_serial_no").focus();
}

$(function() {
  fetch_tool_bom_tune_info();      
  fetch_tool_bom();
  focus_on_next_serial_no();
  auto_submit_receive();
  fetch_tool_bom_item();
  fill_blade_index_to_label();
  auto_focus_new_grind_form();
  auto_focus_new_issue_form();
});
