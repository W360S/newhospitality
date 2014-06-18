jQuery(document).ready(function(jQuery) {	
	
	/* Fancybox */
	jQuery(".pt-login a").fancybox({});
	
	jQuery(".pt-adherence").fancybox({});
	jQuery(".pt-message-boss").fancybox({});
	
	
	jQuery(document).ready(function(){
		jQuery('.pt-how').hover(function(){
			jQuery(this).find('.pt-info-content').stop().animate({'height':'201px'},200);
		}, function(){
			jQuery(this).find('.pt-info-content').stop().animate({'height':'51px'},200);
		});
	});
	
	
	/* Click - Menu */
	
	jQuery(".pt-info-user li a.pt-message").click(function () {
	  jQuery('.pt-info-user li a.pt-message span').css('display', 'none');
	  jQuery('.pt-toggle-message').toggleClass('pt-toggle-active');
	  jQuery('.pt-info-user li a.pt-message').addClass('pt-message-active');
	  jQuery('.pt-toggle-request,.pt-toggle-jewel,.pt-toggle-name').removeClass('pt-toggle-active');
	  
	});
	/* jQuery('.pt-info-user li a.pt-message').bind('click',function(e){event.stopPropagation();jQuery(document).bind('click',function(){jQuery('.pt-toggle-message').removeClass('pt-toggle-active');});}); */

	
	jQuery(".pt-info-user li a.pt-request").click(function () {
	jQuery('.pt-info-user li a.pt-request').addClass('pt-request-active');
	  jQuery('.pt-info-user li a.pt-request span').css('display', 'none');
	  jQuery('.pt-toggle-request').toggleClass('pt-toggle-active');
	  jQuery('.pt-toggle-message,.pt-toggle-jewel,.pt-toggle-name').removeClass('pt-toggle-active');
	  
	});
	/* jQuery('.pt-info-user li a.pt-request').bind('click',function(e){event.stopPropagation();jQuery(document).bind('click',function(){jQuery('.pt-toggle-request').removeClass('pt-toggle-active');});}); */
	
	jQuery(".pt-info-user li a.pt-jewel").click(function () {
	  jQuery('.pt-info-user li a.pt-jewel span').css('display', 'none');
	  jQuery('.pt-toggle-jewel').toggleClass('pt-toggle-active');
	  jQuery('.pt-info-user li a.pt-jewel').addClass('pt-jewel-active');
	  jQuery('.pt-toggle-message,.pt-toggle-request,.pt-toggle-name').removeClass('pt-toggle-active');
	  
	});
	/* jQuery('.pt-info-user li a.pt-jewel').bind('click',function(e){event.stopPropagation();jQuery(document).bind('click',function(){jQuery('.pt-toggle-jewel').removeClass('pt-toggle-active');});}); */
	
	jQuery(".pt-info-user li a.pt-name").click(function () {
	  jQuery('.pt-toggle-name').toggleClass('pt-toggle-active');
	  jQuery('.pt-toggle-message,.pt-toggle-request,.pt-toggle-jewel').removeClass('pt-toggle-active');
	});
	jQuery('.pt-info-user li a.pt-name').bind('click',function(e){event.stopPropagation();jQuery(document).bind('click',function(){jQuery('.pt-toggle-name').removeClass('pt-toggle-active');});});
	/* Click - Menu - End */
	
	jQuery("a.pt-editing").click(function () {
	  jQuery('.pt-toggle-layout').toggleClass('pt-editing-block');
	  return false;
	});
	jQuery('a.pt-editing').bind('click',function(e){event.stopPropagation();jQuery(document).bind('click',function(){jQuery('.pt-toggle-layout').removeClass('pt-editing-block');});});
	
	
	
	
	jQuery(".pt-textarea").click(function () {
	  jQuery('.pt-submit-comment').css( "display", "block" ).fadeIn( 1000 );
	  return false;
	});
	jQuery(".pt-textarea").click(function () {
	  jQuery('.pt-list-click').css( "display", "block" ).fadeIn( 1000 );
	  return false;
	});
	
	/* Select */
	if (!jQuery.browser.opera) {
        jQuery('select').each(function(){
            var title = jQuery(this).attr('title');
			if(!title){title = '';} 
            if( jQuery('option:selected', this).val() != ''  ) title = jQuery('option:selected',this).text();
            jQuery(this)
			.css({'z-index':10,'opacity':0,'-khtml-appearance':'none'})
			.after('<span class="wd-adap-text-select">' + title + '</span>')
			.change(function(){
				val = jQuery('option:selected',this).text();
				jQuery(this).next().text(val);
			})
        });
    };
	
	
	
	
	/*----- Scroll -----*/
	jQuery('.wd-scrollbars-heder').ClassyScroll();
	
	/*----- Scroll -----*/
	jQuery( ".pt-event-tabs" ).tabs();
	jQuery( ".pt-event-detail-tabs" ).tabs();
	
	
	jQuery('.pt-list-event').masonry({
			itemSelector : 'li',
			columnWidth: 1
		});
    jQuery( ".datepicker" ).datepicker();
	
	
	/*----- hoi Dap -----*/
	jQuery("a.pt-editing").click(function(){
		jQuery(this).next(".pt-toggle-layout-01").stop('true').slideToggle(0);
		return false;
	});
	jQuery('a.pt-editing').bind('click',function(e){event.stopPropagation();
		jQuery(document).bind('click',function(){
			jQuery('.pt-toggle-layout-01').slideUp(0);
		});
		return false;
	});
	
	
	
	/*----- Thu Vien -----*/
	jQuery('#wd-foo').carouFredSel({
		auto: false,
		responsive: true,
		width: '100%',    
		scroll: 1,
		prev: '#wd-prev',
		next: '#wd-next',
		pagination: false,
		mousewheel: true,
		items: {
		height: 'auto',
		width: '218',
		visible: {
		min: 1,
		max: 6
		}
		},
		swipe: {
		onMouse: true,
		onTouch: true
		}
	});
	
});