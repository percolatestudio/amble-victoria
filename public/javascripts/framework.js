/* 
  This file contains our proto-framework for javascript using jQuery
  Requires: jquery.string
*/

(function($){
  // define this for our widgets to live in
  $.fn.fw = {};
  
  // any element e that has data-widget=WIDGET set as an attribute will
  // have e.WIDGET() called.
  // also sets data-widget-attached to true, which is used to make sure that things
  // don't get attached twice
  $.attach_widgets = function() {
  // any element that has data-widget=something
   $('[data-widget]').each(function(){
     var e = $(this);
     if (!e.attr('data-widget-attached')) {
       var fn_name = e.attr('data-widget');

       if (!(fn_name in e.fw)) {
         throw "widget '" + fn_name + "'   is not defined."
       }
       e.fw[fn_name].call(e);
       e.attr('data-widget-attached', true)       
     }
   });
  };
  
  // do a few things that we think are a good idea on all pages:
  //   focus the first element of the last form
  //   hook the loaders up to load on all ajax
  //   make sure attach_widgets gets called whenever an ajax page loads
  function misc_setup() {
    // focus the first input of the last form on the page
    $('form:not(.no-auto-focus):last input[type=text]:first').focus();
    
    //disable the submit button on all forms to prevent 
    //multiple submits(this will only work on non-ajax forms) 
    //legacy form elements can set the class do_not_disable_on_submit to not 
    //have this code applied
    // $('form:not(.do_not_disable_on_submit)').submit(function(){
    //   $(this).find('input[type=image],input[type=submit]').click(function(){
    //     return false;
    //   });
    // });
        
    // hook the spinner up
    $('#loader').bind('ajaxStart', function() {
      $(this).addClass('loading').vertical_center();
    }).bind('ajaxStop', function() {
      $(this).removeClass('loading');
    });
    
    $(window).bind('ajaxComplete', function(event, request, options) {
      var fw_divs = $(request.responseText).filter('.framework');
      var controller = fw_divs.filter('#fw_controller').text();
      var view = fw_divs.filter('#fw_view').text();
      var layouts = fw_divs.filter('.layout').map(function() { $(this).text() });
      
      // TODO: not sure if this is the right order
      hookup('onReady', controller, view, layouts);
      $.attach_widgets();
      hookup('onLoad', controller, view, layouts);
    });
  };
  
  // fire the view specific hookup code -- this code should set up live events 
  // etc that control the specific thing that this page does...
  function page_level_hookup(methodName) {
    var controller = $('meta[name=fw.controller]').attr('content');
    var view = $('meta[name=fw.view]').attr('content');    
    var layouts =  $('meta[name=fw.layout]').map(function() { return $(this).attr('content'); });
    
    hookup(methodName, controller, view, layouts);
  };
  
  function hookup(methodName, controller, view, layouts) {
    //capitalize the first character in a string
    function capitalize_first_chr(str) {
      if ((typeof(str) == 'undefined') || (str.length == 0)) {
        return "";
      }
      
      return str.charAt(0).toUpperCase().concat( str.substr(1) )
    }
    
    hookup_once(controller + capitalize_first_chr(view), methodName); // hookup the view
    
    // now the layout (zero or more)
    layouts.each(function(i, layout) {
      hookup_once('layouts' + capitalize_first_chr(layout), methodName);
    });
  };
  
  function hookup_once(objectName, methodName) {
    if (typeof window[objectName] != 'undefined') { // check for undefined in js
      if (methodName in window[objectName]) {
        eval("window['" + objectName + "']." + methodName + "();");
      }
    }
  };

  //when the dom is ready
  $(document).ready(function() {
    $.attach_widgets();
    misc_setup();
    page_level_hookup('onReady');
  });
  
  //when the page is fully loaded (all frames, images, etc)
  $(window).load(function() {
    page_level_hookup('onLoad');
  });  
  
  // other utility functions that make sense in the framework
  
  // set the default value of an option
  // to this to ensure that a value is set for the widget
  $.fn.fw.REQUIRED = '*** VALUE REQUIRED ***';
  
  // updates options by examining a tag for data-widget-x attributes
  // note that attached is a reserved name
  // pass in the set of default options (all defaults must be defined)
  $.fn.read_options = function(defaults) {
    var that = this;
    var options = {};
    $.each(defaults, function(name, def) {
      // console.log('data-widget-' + name);
      var val = that.attr('data-widget-' + name);
      // console.log(val);
      if (val) {
        options[name] = val;
      } else {
        if (def === $.fn.fw.REQUIRED) {
          throw("Widget argument required: " + name);
        }
        
        options[name] = def;
      }
    });
    
    return options;
  }
}(jQuery));