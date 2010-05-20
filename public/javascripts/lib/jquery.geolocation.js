/**
 * A jQuery-Geolocation-Plugin
 *
 * @author Thomas Michelbach <thomas@nomoresleep.net>
 * @copyright NoMoreSleep(tm) <http://developer.nomoresleep.net>
 * @version 0.1
 */

(function($){
	
	$.extend($.support,{
		geolocation:function(){
			return $.geolocation.support();
		}
	});

	$.geolocation = {        
		find:function(success, error, options){
			if($.geolocation.support()){
				options = $.extend({highAccuracy: false, track: false, timeout: 10000}, options);
				
				try {
  				($.geolocation.object())[(options.track ? 'watchPosition' : 'getCurrentPosition')](function(location){
  					success(location.coords);
  				}, function(){
  					error();
  				}, {enableHighAccuracy: options.highAccuracy});		
  			} catch(err) {
  			  //error will be thrown if geolocation is disabled
  			  error();
  			}
			}else{
				error();				
			}
		},
		object:function(){
			return navigator.geolocation;
		},
		support:function(){
			return ($.geolocation.object()) ? true : false;
		}
	}
	
})(jQuery);