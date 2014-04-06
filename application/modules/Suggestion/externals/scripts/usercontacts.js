
/* $Id: usercontacts.js 2010-08-17 9:40:21Z SocialEngineAddOns Copyright 2009-2010 BigStep Technologies Pvt. Ltd. $ */

//THIS FUNCTION IS USED TO SHOW THE ALL GOOGLE CONTACTS IN PARSING MODE.DEFAULT WE ARE SHOWING ONLY THOSE CONTACTS WHICH ARE SITE MEMBERS BUT NOT USER'S FRIENDS.
function show_contacts_google(id) {
  $('id_nonsite_success_mess').style.display = 'none';
	$('id_success_frequ').style.display = 'none';
	if (id == 1) {
		var child_window = window.open (en4.core.baseUrl + 'suggestion/usercontacts/getgooglecontacts' ,'mywindow','width=500,height=500');
	}
	if (window.opener!= null) {
		if (id == 0) {
			var href = window.location.href;
			var token = getQuerystring('token', href);
			window.opener.get_contacts_google(token);
			close();
		}
	}
}
//CALLING THIS FUNCTION FROM CHILD WINDOW BEFORE CLOSING THE CHILD WINDOW.WHICH GETS THE GOOGLE CONTACTS.
function get_contacts_google(token) {
	Smoothbox.open("<div style='height:30px;'><center><b>" + translate_suggestion['Importing Contacts'] + "</b><br /><img src='application/modules/Suggestion/externals/images/loadings.gif' alt='' /></center></div>");
	var postData = {
		'token' : token,
		'task' : 'get_googlecontacts'
	};
	
	en4.core.request.send(new Request( {
		url : en4.core.baseUrl + 'suggestion/usercontacts/getgooglecontacts',
		method : 'post',
		data : postData,
		onSuccess : function(responseObject)
		{ 
			Smoothbox.close();
			$('network_friends').style.display = 'block'; 
			$('show_contacts').innerHTML = responseObject;
		}
	}));
}

  
//THIS FUNCTION IS USED TO SHOW THE ALL YAHOO CONTACTS IN PARSING MODE.DEFAULT WE ARE SHOWING ONLY THOSE CONTACTS WHICH ARE SITE MEMBERS BUT NOT USER'S FRIENDS.
function show_contacts_yahoo(id) {
	$('id_nonsite_success_mess').style.display = 'none';
	$('id_success_frequ').style.display = 'none';
	if (id == 1) { 
		var child_window = window.open (en4.core.baseUrl + 'suggestion/usercontacts/getyahoocontacts' ,'mywindow','width=500,height=500');
	}
	
	if (window.opener!= null) {
		if (id == 0) {
		var href = window.location.href;
		var oauth_verifier = getQuerystring('oauth_verifier', href);
		window.opener.get_contacts_yahoo(oauth_verifier);
		close();
		}
	}
}
//CALLING THIS FUNCTION FROM CHILD WINDOW BEFORE CLOSING THE CHILD WINDOW.WHICH GETS ALL YAHOO CONTACTS.
function get_contacts_yahoo(oauth_verifier) {
	Smoothbox.open("<div style='height:30px;'><center><b>" + translate_suggestion['Importing Contacts'] + "</b><br /><img src='application/modules/Suggestion/externals/images/loadings.gif' alt='' /></center></div>");
	var postData = {
		'oauth_verifier' : oauth_verifier,
		'task' : 'get_yahoocontact'
	};

	en4.core.request.send(new Request({
		url : en4.core.baseUrl + 'suggestion/usercontacts/getyahoocontacts',
		method : 'post',
		data : postData,
		onSuccess : function(responseObject)
		{ 
			Smoothbox.close();
			$('network_friends').style.display = 'block';
			$('show_contacts').innerHTML = responseObject;
		}
	}));
}
  
  
//THIS FUNCTION IS USED TO SHOW THE ALL WINDOW LIVE CONTACTS IN PARSING MODE.DEFAULT WE ARE SHOWING ONLY THOSE CONTACTS WHICH ARE SITE MEMBERS BUT NOT USER'S FRIENDS.
function show_contacts_windowlive(id) {
	$('id_nonsite_success_mess').style.display = 'none';
	$('id_success_frequ').style.display = 'none';
	if (id == 1) { 
		var child_window = window.open (en4.core.baseUrl + 'suggestion/usercontacts/getwindowlivecontacts' ,'mywindow','width=900,height=900');
	}
	
	if (window.opener!= null) {
		if (id == 0) {
			window.opener.get_contacts_windowlive();
			close();
		}
	}
}
 
//CALLING THIS FUNCTION FROM CHILD WINDOW BEFORE CLOSING THE CHILD WINDOW.WHICH GETS ALL WINDOW LIVE CONTACTS.
function get_contacts_windowlive() {
	Smoothbox.open("<div style='height:30px;'><center><b>" + translate_suggestion['Importing Contacts'] + "</b><br /><img src='application/modules/Suggestion/externals/images/loadings.gif' alt='' /></center></div>");
	var postData = {
		'task' : 'get_windowcontact'
	};

	en4.core.request.send(new Request({
		url : en4.core.baseUrl + 'suggestion/usercontacts/getwindowlivecontacts',
		method : 'post',
		data : postData,
		onSuccess : function(responseObject)
		{ 
			Smoothbox.close();
			$('network_friends').style.display = 'block';
			$('show_contacts').innerHTML = responseObject;
		}
	}));
}

//THIS FUNCTION IS USED TO SHOW THE ALL AOL CONTACTS IN PARSING MODE.DEFAULT WE ARE SHOWING ONLY THOSE CONTACTS WHICH ARE SITE MEMBERS BUT NOT USER'S FRIENDS.
function show_contacts_aol(id) {
	$('id_nonsite_success_mess').style.display = 'none';
	$('id_success_frequ').style.display = 'none';
	if (id == 1) {
		var child_window = window.open (en4.core.baseUrl + 'suggestion/usercontacts/aollogin' ,'mywindow','width=500,height=500');
	}
	if (window.opener!= null) {
		if (id == 0) {
			window.opener.get_contacts_aol();
			close();
		}
	}
}
//CALLING THIS FUNCTION FROM CHILD WINDOW BEFORE CLOSING THE CHILD WINDOW.WHICH GETS THE AOL CONTACTS.
function get_contacts_aol() {
	Smoothbox.open("<div style='height:30px;'><center><b>" + translate_suggestion['Importing Contacts'] + "</b><br /><img src='application/modules/Suggestion/externals/images/loadings.gif' alt='' /></center></div>");
	var postData = {
		'task' : 'get_aolcontacts'
	};
	
	en4.core.request.send(new Request( {
		url : en4.core.baseUrl + 'suggestion/usercontacts/getaolcontacts',
		method : 'post',
		data : postData,
		onSuccess : function(responseObject)
		{ 
			Smoothbox.close();
			$('network_friends').style.display = 'block';
			$('show_contacts').innerHTML = responseObject;
		}
	}));
}

//RETURNING THE QUERY STRING .
function getQuerystring(key, href) {
	key = key.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
	var regex = new RegExp("[\\?&]"+key+"=([^&#]*)");
	var qs = regex.exec(href);
	if(qs == null)
		return '';
	else
		return qs[1];
}

//THIS FUNCTION IS USED TO SET AND UNSET ALL CHECKBOX IN CASE OF ADD FRIENDS.
function checkedAll () {
	if ($('select_all').checked)
		checked = true;
	else
		checked = false;
	var total_contacts = $('total_contacts').value;

	for (var i =1; i <= total_contacts; i++) 
	{
		$('contact_' + i).checked = checked;
	}
}

//SENDING USER SELECTED USERS TO ADD AS A FRIEND REQUEST.
function sendFriendRequests() {
	var sitemembers = new Array ();
	var checked = false;
	var total_contacts = $('total_contacts').value;
	for (var i =1; i <= total_contacts; i++) 
	{
		if ($('contact_' + i).checked) {
			checked = true;
			sitemembers [i] = $('contact_' + i).value;
		}
	}
	if (checked) {
		Smoothbox.open("<div style='height:30px;'><center><b>" + translate_suggestion['Sending Request'] + "</b><br /><img src='application/modules/Suggestion/externals/images/loadings.gif' alt='' /></center></div>");
		var postData = {
			'sitemembers' : sitemembers,
			'task' : 'friend_requests'
		};
		
		en4.core.request.send(new Request({
			url : en4.core.baseUrl + 'suggestion/index/addtofriend',
			method : 'post',
			data : postData,
			onSuccess : function(responseObject)
			{ 
				Smoothbox.close();
         
				$('id_success_frequ').style.display = 'block';
				$('show_sitefriend').style.display = 'none';
				$('show_nonsitefriends').style.display = 'block';
			}
		}));
	}
	else {
		alert("Please select at least one friend to add");
	}
}

//THIS FUNCTION IS USED TO SET AND UNSET ALL CHECKBOX IN CASE OF INVITE FRIENDS.
function nonsitecheckedAll() {
	if ($('nonsiteselect_all').checked)
		checked = true;
	else
		checked = false;
	var total_contacts = $('nonsitetotal_contacts').value;
	for (var i =1; i <= total_contacts; i++) 
	{
		$('nonsitecontact_' + i).checked = checked;
	}
}

//THIS FUNCTION IS USED TO HIDE THE ADD FRINEDS LIST AND SHOWING THE NONSITE MEMBERS LIST.
function skip_addtofriends() {
  if ($('nonsitetotal_contacts')) {
		var total_contacts = $('nonsitetotal_contacts').value;
		for (var i =1; i <= total_contacts; i++) 
		{
			$('nonsitecontact_' + i).checked = true;
		}
		$('show_sitefriend').style.display = 'none';
		$('show_nonsitefriends').style.display = 'block';
	}
	else {
   document.id_myform_temp.submit();
	}
}

//WHEN USER CLICKED ON THE SKIP BUTTON OF NONSITE MEMBERS LIST.
function skipinvites () {
	document.id_myform_temp.submit();
}

function inviteFriends() {
 	var nonsitemembers = new Array ();
	var checked = false;
	var total_checked = 0;
	var total_contacts = $('nonsitetotal_contacts').value;
	for (var i =1; i <= total_contacts; i++) 
	{
		if ($('nonsitecontact_' + i).checked) {
			total_checked++; 
			checked = true;
			nonsitemembers [i] = $('nonsitecontact_' + i).value;
		}
	}
	if (checked) {  
    Smoothbox.open("<div style='height:30px;'><center><b>" + translate_suggestion['Sending Request'] + "</b><br /><img src='application/modules/Suggestion/externals/images/loadings.gif' alt='' /></center></div>");
		var postData = {
			'nonsitemembers' : nonsitemembers,
			'task' : 'join_network'
		};
		
		en4.core.request.send(new Request({
			url : en4.core.baseUrl + 'suggestion/index/invitetosite',
			method : 'post',
			data : postData,
			onSuccess : function(responseObject)
			{ 
       $('id_success_frequ').style.display = 'none';
				Smoothbox.close();
				$('id_nonsite_success_mess').style.display = 'block';
				$('show_nonsitefriends').innerHTML = '';
			}
		}));
	}
	else {
		alert("Please select at least one friend to invite");
	}
}

var fileext = false;

//HERE WE ARE UPLOADING THE FILE ON SELECTING FILE FROM BROWSE BUTTON.
function savefilepath() {
	$('id_nonsite_success_mess').style.display = 'none';
	$('id_success_frequ').style.display = 'none';	
	$('id_csvformate_error_mess').style.display = 'none';	
	$('show_contacts_csv').style.display = 'none';	
	$('id_csvformate_error_mess').style.display = 'none';	
	$('show_contacts_csv').style.display = 'none';			
	var filename = $('Filedata').value;
  if (checkext(trim(filename)) == true) { 
		fileext = true;
		Smoothbox.open("<div style='height:30px;'><center><b>" + translate_suggestion['Uploading file'] + "</b><br /><img src='application/modules/Suggestion/externals/images/loadings.gif' alt='' /></center></div>");
		window.setTimeout("document.csvimport.submit()",1);
	}
	else {
			fileext = false;
	}
}

//GETTING ALL CSV FILE CONTACTS.
function getcsvcontacts() {
	var filename = $('Filedata').value;
	if (fileext) {
		Smoothbox.open("<div style='height:30px;'><center><b>" + translate_suggestion['Importing Contacts'] + "</b><br /><img src='application/modules/Suggestion/externals/images/loadings.gif' alt='' /></center></div>");
		var postData = {
			'task' : 'join_network',
			'filename': filename
		};
			
		en4.core.request.send(new Request({
			url : en4.core.baseUrl + 'suggestion/usercontacts/getcsvcontacts',
			method : 'post',
			data : postData,
			onSuccess : function(responseObject)
			{ 
				$('Filedata').value = '';
				fileext = false;
				Smoothbox.close();
				$('id_csvformate_error_mess').style.display = 'none';	
				$('csv_friends').style.display = 'block';
				$('show_contacts_csv').style.display = 'block';	
				$('show_contacts_csv').innerHTML = responseObject;
			}

		}));
	}
	else {
		$('id_success_frequ').style.display = 'none';
		$('id_nonsite_success_mess').style.display = 'none';
		$('csv_friends').style.display = 'none';
		$('id_csvformate_error_mess').style.display = 'block';	
// 		$('show_contacts_csv').innerHTML = '<ul class="form-errors"><li><ul class="errors"><li>Invalid file format.</li></ul></li></ul>';
	}
}

function checkext(fis)
{
	var s,ext ;
    s=fis.length;
    ext=fis.substring(s-4,s);
	if((ext.toUpperCase()=='.CSV' || ext.toUpperCase()=='.TXT'))
	 {
		 return true;
	}
	else
	return false;
	
}

function showhide(hide_div, show_div) {
	 if ($('show_contacts')) {
		$('show_contacts').innerHTML = '';
	}
	if ($('show_contacts_csv')) {
		$('show_contacts_csv').innerHTML = '';
   }
	$(hide_div).style.display = 'none';
	$(show_div).style.display = 'block';
	$('network_friends').style.display = 'none';
	$('id_nonsite_success_mess').style.display = 'none';
	$('id_success_frequ').style.display = 'none';
	$('csv_friends').style.display = 'none';
	$('id_csvformate_error_mess').style.display = 'none';
}

/**



*  Javascript trim, ltrim, rtrim
*  http://www.webtoolkit.info/
*
**/
 
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