window.addEvent('domready', function(){
	
    jQuery('.select_sort .panel .content,.panel_form .content').hide();
    
    jQuery('.select_sort .panel .trigger,.panel_form .trigger').bind('click', function(){
        jQuery(this).siblings('.content').slideToggle();
    });
      
});
