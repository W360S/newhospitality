jQuery(document).ready(function($) {
    console.log("Member Home JS INITING ...");

    var EVENTS_TAB = $('.layout_event_profile_events');
    var ALBUMS_TAB = $('.layout_album_profile_albums');
    var FEEDS_TAB = $('.layout_activity_feed');

    // READY
    EVENTS_TAB.hide();
    ALBUMS_TAB.hide();


    // REGISTER CLICK FUNCTION
    $("#link-newfeed").click(function(e) {
        console.log(e);
        EVENTS_TAB.hide();
        ALBUMS_TAB.hide();
        FEEDS_TAB.show();
    })

    $("#link-events").click(function(e) {
        console.log(e);
        EVENTS_TAB.show();
        ALBUMS_TAB.hide();
        FEEDS_TAB.hide();
    })

    $("#link-albums").click(function(e) {
        console.log(e);
        EVENTS_TAB.hide();
        ALBUMS_TAB.show();
        FEEDS_TAB.hide();
    })

    $("textarea[name=body]").removeAttr("style");

});