// a jquery plugin to simulate placeholders for inputs which do not natively support 
// placeholding. Different from the usual approach (and our default.js) in that we
// don't fill in the input with the placeholding value (too many issues involving
// submitting, and autofill). Instead, we put a div in front of an empty input, and
// show/hide it as appropriate. 

// nicely checks if the input/textarea supports placeholding natively, so separate 
// the usage over different tags. Eg
//     $("input[placeholder]").icyte_placeholder();
//     $("textarea[placeholder]").icyte_placeholder();

(function($) {
  $.fn.placeholder = function() {
    // first check if its supported by the browser
    if ((this.length == 0) || (!!("placeholder" in $('<'+this.get(0).nodeName+'>').get(0)))) return;
    if ($('body').hasClass('l_mobile')) return;
    
    // this code assumes that the parent of the field is a div
    // and the correct styles exist
    
    // first insert a sibling to hold the placeholder
    this.each(function() {
      $(this).after(
        $('<div class="placeholder">'+$(this).attr('placeholder')+'</div>')
          .bind('click', this, function(e) {
             e.data.focus(); // <- focus the input
          })
      );
    });
    
    this.bind('focus drop change', hidePlaceholder)
        .blur(function() {
          // put the placeholder text in the parent div, if we are empty
          var e = $(this);
          // show if we have no value
          if (!e.val()) {
            e.siblings('.placeholder').show();
          } else {
            e.siblings('.placeholder').hide();
          }
        }).blur();
    
    return this;
  };
  
  function hidePlaceholder() {
    $(this).siblings('.placeholder').hide();
  }
  
  // set it up
  $(function() {
   $('input[placeholder]').placeholder(); 
  });
}(jQuery));