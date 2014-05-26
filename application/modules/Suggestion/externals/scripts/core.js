
/* $Id: core.js 2010-08-17 9:40:21Z SocialEngineAddOns Copyright 2009-2010 BigStep Technologies Pvt. Ltd. $ */

en4.suggestion = {
};

en4.suggestion.mixs = {
};

en4.suggestion.friends = {
}
// call when click on "x" from any widget.
var display_sugg = '';

var mixInfo = function(mix_id, mix_widget_div_id, fun_name, page_name)
{
    switch (page_name)
    {
        // When this function call from "Video Widget" then assign number of suggestion which are displayed in "Video Widget".
        case 'video':
            var display_suggestion = video_suggestion_display;
            break;
            // When this function call from "Mix Widget" then assign number of suggestion which are displayed in "Mix Widget".
        case 'mix':
            var display_suggestion = mix_suggestion_display;
            break;
            // When this function call from "Album Widget" then assign number of suggestion which are displayed in "Album Widget".
        case 'album':
            var display_suggestion = album_suggestion_display;
            break;
            // When this function call from "Group Widget" then assign number of suggestion which are displayed in "Group Widget".
        case 'group':
            var display_suggestion = group_suggestion_display;
            break;
            // When this function call from "Event Widget" then assign number of suggestion which are displayed in "Event Widget".
        case 'event':
            var display_suggestion = event_suggestion_display;
            break;
            // When this function call from "Friend Widget" then assign number of suggestion which are displayed in "Friend Widget".
        case 'friend':
            var display_suggestion = friend_suggestion_display;
            break;
            // When this function call from "Blog Widget" then assign number of suggestion which are displayed in "Blog Widget".
        case 'blog':
            var display_suggestion = blog_suggestion_display;
            break;
            // When this function call from "Classified Widget" then assign number of suggestion which are displayed in "Classified Widget".
        case 'classified':
            var display_suggestion = classified_suggestion_display;
            break;
            // When this function call from "Music Widget" then assign number of suggestion which are displayed in "Music Widget".
        case 'music':
            var display_suggestion = music_suggestion_display;
            break;
            // When this function call from "Poll Widget" then assign number of suggestion which are displayed in "Poll Widget".
        case 'poll':
            var display_suggestion = poll_suggestion_display;
            break;
            // When this function call from "Forum Widget" then assign number of suggestion which are displayed in "Forum Widget".
        case 'forum':
            var display_suggestion = forum_suggestion_display;
            break;
            // When this function call from "Explore Friend Widget" then assign number of suggestion which are displayed in "Explore Friend Widget".
        case 'new':
            var display_suggestion = explore_suggestion_display;
            break;
    }
    en4.core.request.send(new Request.HTML({
        url: en4.core.baseUrl + 'suggestion/main/mix-info',
        data: {
            format: 'html',
            sugg_id: mix_id,
            widget_div_id: mix_widget_div_id,
            fun_name: fun_name,
            display_suggestion: display_suggestion,
            displayed_sugg: display_sugg,
            page_name: page_name
        }
    }), {
        'element': $(mix_widget_div_id)
    });
};

// close the popup.
var cancelPopup = function()
{
    parent.Smoothbox.close();
};

var url = '';

window.addEvent('domready', function() {
    if (typeof action_module != 'undefined') {
        url = en4.core.baseUrl + 'suggestion/index/' + action_module;
        $(action_module + '_members_search_inputd').addEvent('blur', function() {
            if (memberSearch != '') {
                $(action_module + '_members_search_inputd').value = memberSearch;
            }
            else {
                $(action_module + '_members_search_inputd').value = translate_suggestion['Search Members'];
            }


        });

        $(action_module + '_members_search_inputd').addEvent('focus', function() {
            if (memberSearch != '') {
                $(action_module + '_members_search_inputd').value = memberSearch;
            }
            else {
                $(action_module + '_members_search_inputd').value = '';
            }
            if (show_selected == 1 && friends_count > 0) {
                show_selected = 0;
                paginateMembers(1);
            }
        });
    }
});

//UPDATING THE CURRENT FRIEND PAGE.
function update_html(select_checkbox) {
    //alert(suggestion_string_temp);
    suggestion_string_temp = select_checkbox;
    if (suggestion_string_temp != '') {
        var suggestion_string_2 = suggestion_string_temp.split(',');

        if (suggestion_string_2.length > 0) {
            for (i = 0; i < suggestion_string_2.length; i++) {
                var checkbox_info = suggestion_string_2[i].split('-');
                if ($(checkbox_info[0])) {
                    $(checkbox_info[0]).checked = true;
                    //$(checkbox_info[0] + '_div').className = "suggestion_pop_friend select_friend";
                    friends_count--;
                    moduleSelect(checkbox_info[0], checkbox_info[1], checkbox_info[2]);
                }
                else {
                    if (checkbox_info[2]) {
                        suggestion_string += ',' + checkbox_info[0] + '-' + checkbox_info[1] + '-' + checkbox_info[2];
                    }

                }
            }
        }
        return false;
    }
}

//GETTING THE SEARCHED FRIENDS.
function  show_searched_friends(request, event) {

    if (typeof event != 'undefined' && event.keyCode == 13) {
        return false;
    }
    if (request == 0) {
        show_selected = 0;
        $('show_all').className = 'selected';
        $('selected_friends').className = '';
    }
    else {
        $('show_all').className = '';
        $('selected_friends').className = 'selected';

    }

    var current_search = trim($(action_module + '_members_search_inputd').value);

    if (show_selected == 1) {
        current_search = '';
        memberSearch = '';
        $(action_module + '_members_search_inputd').value = translate_suggestion['Search Members'];
    }
    // if( e.key != 'enter' ) return;

    new Request({
        url: url,
        method: "get",
        data: {
            'format': 'html',
            'task': 'ajax',
            'searchs': current_search,
            'selected_checkbox': suggestion_string,
            'show_selected': show_selected,
            'action_id': action_session_id
        },
        onSuccess: function(responseHTML)
        {

            $('main_box').set('html', responseHTML);
            var select_checkbox = $('checkbox_user').get('value');
            suggestion_string = '';
            //target.innerHTML = responseHTML;
            //$('main_box').innerHTML = responseHTML;
            update_html(select_checkbox);

        }
    }).send();

    /*
     en4.core.request.send(new Request.HTML({
     url : url,
     method: 'get',
     data : {
     'format' : 'html',
     'task': 'ajax',
     'searchs' : current_search,
     'selected_checkbox': suggestion_string,
     'show_selected': show_selected,
     'action_id': action_session_id
     },
     onSuccess : function(responseTree, responseElements, responseHTML, responseJavaScript)
     {
     
     $('main_box').set('html', responseHTML);
     //target.innerHTML = responseHTML;
     //$('main_box').innerHTML = responseHTML;
     update_html();
     
     }
     }));
     */
    return false;
}

//PAGINATING FRIENDS PAGE.
function paginateMembers(page) {

    if (show_selected == 1) {
        $('show_all').className = '';
        $('selected_friends').className = 'selected';
    }
    else {
        $('show_all').className = 'selected';
        $('selected_friends').className = '';
    }


    var request = new Request({
        url: url,
        method: 'get',
        data: {
            'format': 'html',
            'task': 'ajax',
            'searchs': memberSearch,
            'selected_checkbox': suggestion_string,
            'page': page,
            'action_id': action_session_id,
            'show_selected': show_selected
        },
        onSuccess: function(responseHTML)
        {
            $('main_box').set('html', responseHTML);
            //$('main_box').innerHTML = responseHTML;
            var select_checkbox = $('checkbox_user').get('value');
            suggestion_string = '';
            update_html(select_checkbox);
        }
    });
    request.send();
    return false;
}


function moduleSelect(check_name, friend_id, friend_title)
{
    var user_string;
    if ($(check_name).checked)
    {
        friends_count++;
        suggestion_string += ',' + check_name + '-' + friend_id + '-' + friend_title;
        //$(check_name + '_div').className = "suggestion_pop_friend select_friend";

    }
    else

    {
        friends_count--
        suggestion_string = suggestion_string.replace(',' + check_name + '-' + friend_id + '-' + friend_title, "");
        //$(check_name + '_div').className = "suggestion_pop_friend";
    }
    //$('selected_friends').innerHTML = translate_suggestion['Selected'] +  ' (' + friends_count + ')';

    $('selected_friends').set('html', translate_suggestion['Selected'] + ' (' + friends_count + ')');
}

var show_all = function() {

    memberSearch = '';
    $(action_module + '_members_search_inputd').value = translate_suggestion['Search Members'];
    if (show_selected == 1) {
        show_selected = 0;
        paginateMembers(1);
    }
    else {
        paginateMembers(memberPage);
    }

}

var selected_friends = function() {

    if (friends_count > 0) {
        memberSearch = '';
        show_selected = 1;
        show_searched_friends(1);
    }
    else if (show_selected == 1) {
        show_all();
    }
}


//SUBMIT THE FORM IF USER HAS SELECTED ATLEAST ONE FRIEND. 
function doCheckAll()
{

    var suggestion_string_1 = suggestion_string.split(',');
    if (suggestion_string_1.length == 1)
    {
        //$('check_error').innerHTML = '<ul class="form-errors"><li><ul class="errors"><li>' + translate_suggestion['Please select at-least one entry above to send suggestion to.'] + '</li></ul></li></ul>';
        $('check_error').set('html', '<ul class="form-errors"><li><ul class="errors"><li>' + translate_suggestion['Please select at-least one entry above to send suggestion to.'] + '</li></ul></li></ul>');
    }
    else
    {
        $('hidden_checkbox').set('html', "");

        //$('hidden_checkbox').innerHTML = "";
        var hidden_checkbox = '';
        for ($i = 1; $i < suggestion_string_1.length; $i++) {
            var checked_id_temp = suggestion_string_1[$i].split('-');
            if ($(checked_id_temp[0])) {
                //$(checked_id_temp[0]).checked = false;
            }
            else {
                hidden_checkbox = hidden_checkbox + '<input type="hidden" name="check_' + checked_id_temp[1] + '"  value="' + checked_id_temp[1] + '"/>';
            }

        }
        $('hidden_checkbox').set('html', hidden_checkbox);
        //$('hidden_checkbox').innerHTML = hidden_checkbox;	
        console.log(suggestion_string_1.length);
        document.suggestion.submit();
    }
}


function trim(str, chars) {
    return ltrim(rtrim(str, chars), chars);
}

function ltrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
}

function rtrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
}
