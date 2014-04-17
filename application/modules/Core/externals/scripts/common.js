;jQuery(document).ready(function($) {

    /* Fancybox */
    $(".pt-login a").fancybox({});

    /* Click - Menu */

    // MESSAGE
    $(".pt-info-user li a.pt-message").click(function() {
        $('.pt-info-user li a.pt-message span').css('display', 'none');
        $('.pt-toggle-message').toggleClass('pt-toggle-active');
        $('.pt-info-user li a.pt-message').addClass('pt-message-active');
        $('.pt-toggle-request,.pt-toggle-jewel,.pt-toggle-name').removeClass('pt-toggle-active');

    });
    /* $('.pt-info-user li a.pt-message').bind('click',function(e){event.stopPropagation();$(document).bind('click',function(){$('.pt-toggle-message').removeClass('pt-toggle-active');});}); */

    // REQUEST
    $(".pt-info-user li a.pt-request").click(function() {
        $('.pt-info-user li a.pt-request').addClass('pt-request-active');
        $('.pt-info-user li a.pt-request span').css('display', 'none');
        $('.pt-toggle-request').toggleClass('pt-toggle-active');
        $('.pt-toggle-message,.pt-toggle-jewel,.pt-toggle-name').removeClass('pt-toggle-active');

    });
    /* $('.pt-info-user li a.pt-request').bind('click',function(e){event.stopPropagation();$(document).bind('click',function(){$('.pt-toggle-request').removeClass('pt-toggle-active');});}); */

    // NOTITICATIONS
    $(".pt-info-user li a.pt-jewel").click(function() {
        // $('.pt-info-user li a.pt-jewel span').css('display', 'none');
        $('.pt-toggle-jewel').toggleClass('pt-toggle-active');
        $('.pt-info-user li a.pt-jewel').addClass('pt-jewel-active');
        $('.pt-toggle-message,.pt-toggle-request,.pt-toggle-name').removeClass('pt-toggle-active');

    });
    /* $('.pt-info-user li a.pt-jewel').bind('click',function(e){event.stopPropagation();$(document).bind('click',function(){$('.pt-toggle-jewel').removeClass('pt-toggle-active');});}); */

    $(".pt-info-user li a.pt-name").click(function() {
        $('.pt-toggle-name').toggleClass('pt-toggle-active');
        $('.pt-toggle-message,.pt-toggle-request,.pt-toggle-jewel').removeClass('pt-toggle-active');
    });
    $('.pt-info-user li a.pt-name').bind('click', function(e) {
        event.stopPropagation();
        $(document).bind('click', function() {
            $('.pt-toggle-name').removeClass('pt-toggle-active');
        });
    });
    /* Click - Menu - End */

    // FRIEND REQUEST CLASSY SCROLL
    //$('.wd-scrollbars-heder').ClassyScroll();


    jQuery('.pt-list-event').masonry({
        itemSelector : 'li',
        columnWidth: 1
    });








});