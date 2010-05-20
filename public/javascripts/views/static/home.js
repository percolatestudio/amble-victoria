(function($){
  staticHome = {
    onReady: function() {
      $('#mobile_head').click(function() {$('#mobile_sociable').get(0).scrollIntoView();});
      $('#sociable_head').click(function() {$('#mobile_sociable').get(0).scrollIntoView();});
      $('#discover_head').click(function() {$('#discover').get(0).scrollIntoView();});  
      $('#victorian_head').click(function() {$('#victorian').get(0).scrollIntoView();});
    }
  }
}(jQuery));