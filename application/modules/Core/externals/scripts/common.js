;
jQuery.noConflict();

jQuery(document).ready(function($) {
    var member_home_url = "/members/home";
    var message_inbox_url = "/messages";
    var events_index_url = "/events";
    var album_index_url = "/albums";
    var groups_index_url = "/group";
    //    var groups_index_url = "/groups";

    console.log('/application/modules/Core/externals/scripts/common.js');

    if (document.URL.indexOf(member_home_url) != -1) {
        $("#link-newfeed").addClass("pt-active");
        console.log("is home page");
    }
    if (document.URL.indexOf(message_inbox_url) != -1) {
        $("#link-message").addClass("pt-active");
    }
    if (document.URL.indexOf(events_index_url) != -1) {
        $("#link-events").addClass("pt-active");
    }
    if (document.URL.indexOf(album_index_url) != -1) {
        $("#link-albums").addClass("pt-active");
    }
    if (document.URL.indexOf(groups_index_url) != -1) {
        $("#link-groups").addClass("pt-active");
    }
});

jQuery(document).ready(function($) {

    $(".pt-login a").fancybox({});

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

function isMemberHomePage() {
    return document.URL.indexOf("/members/home");
}

function isExpertPage() {
    return document.URL.indexOf("/expert");
}

function isLibraryPage() {
    return document.URL.indexOf("/library");
}


function isJobPage() {
    return (document.URL.indexOf("/resumes") != -1) || (document.URL.indexOf("/recruiter") != -1) || (document.URL.indexOf("/profile_company") != -1);
}

jQuery(document).ready(function($) {
    $(".head-menu-item").each(function(e) {

        if (isJobPage()) {
            $(".head-menu-item-job").addClass("pt-active");
        }

        if (isMemberHomePage() != -1) {
            $(".head-menu-item-member-home").addClass("pt-active");
        }

        if (isExpertPage() != -1) {
            $(".head-menu-item-expert").addClass("pt-active");
        }

        if (isLibraryPage() != -1) {
            $(".head-menu-item-library").addClass("pt-active");
        }

    });
});