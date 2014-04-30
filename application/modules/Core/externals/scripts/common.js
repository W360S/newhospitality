;jQuery.noConflict();
jQuery(document).ready(function($){
    console.log("PT MENU LEFT IS INITING");
    var member_home_url = "<?php echo $this->baseUrl() ?>/members/home";
    var message_inbox_url = "<?php echo $this->baseUrl() ?>/messages/inbox";
    var events_index_url = "<?php echo $this->baseUrl() ?>/events";
    var album_index_url = "<?php echo $this->baseUrl() ?>/albums";
    if(document.URL.indexOf(member_home_url) != -1){
        $("#link-newfeed").addClass("pt-active");
    }
    if(document.URL.indexOf(message_inbox_url) != -1){
        $("#link-message").addClass("pt-active");
    }
    if(document.URL.indexOf(events_index_url) != -1){
        $("#link-events").addClass("pt-active");
    }
    if(document.URL.indexOf(album_index_url) != -1){
        $("#link-albums").addClass("pt-active");
    }
});
jQuery(document).ready(function($) {

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


    

    $("a.pt-editing").click(function() {
        $('.pt-toggle-layout').toggleClass('pt-editing-block');
        return false;
    });
    $('a.pt-editing').bind('click', function(e) {
        event.stopPropagation();
        $(document).bind('click', function() {
            $('.pt-toggle-layout').removeClass('pt-editing-block');
        });
    });


});