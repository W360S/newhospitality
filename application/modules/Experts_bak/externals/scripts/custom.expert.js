window.addEvent('domready', function(){
	jQuery('.select_sort input[type="text"]').each(function(){
        var defaultVal = jQuery(this).val();
        jQuery(this).focus(function(){
            if (jQuery(this).val() == defaultVal){
                jQuery(this).val('');
            }
        }).blur(function(){
            if (jQuery.trim(jQuery(this).val()) == ''){
                jQuery(this).val(defaultVal);
            }
        });
    });
    jQuery('.select_sort .panel .content,.panel_form .content').hide();
    /*
    jQuery('.select_sort .panel .trigger,.panel_form .trigger').bind('click', function(){
        jQuery(this).siblings('.content').slideToggle();
    });
    */  
});
