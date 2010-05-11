// utility shared between views

(function($){
  // captures the click event for the element and loads the given url into the
  // replaceSel selector
  // NOTE: Uses live events, so must be used with a selector in the same
  // way as live events
  $.fn.targetContent = function(replaceSel) {
    return $(this.selector).live('click', function(ev) {
      ev.preventDefault();  
      
      // work around browser inconsitencies to ensure we
      // have the absolute href
      var href = '';
      if ($.support.hrefNormalized) {
        href = this.href;
      } else {
        href = this.getAttribute('href', 4);
      }
      
      $.loadContent(replaceSel, href);
    });
  };
    
  $.loadContent = function(replaceSel, href) {
    // set the spinner in motion in the content area
    $(replaceSel).html("<div id='contentSpinner'></div>")
    
    // go grab the html for the content area
    $(replaceSel).load(href, function() {
      // for the moment, this is a hack. 
      // TODO: 1. store the pk classes as a pk attribute on the element (perhaps pk already does this)
      //       2. check if $(replaceSel).pk is a contentView inside a scrollView
      //       3. if so do this magic
      // [on the other hand, maybe we do need to do this every time?]
      
      window.amble.pk.content.size = 
        new PKSize(window.innerWidth, window.amble.pk.content.layer.scrollHeight);
    });
  };  
}(jQuery));