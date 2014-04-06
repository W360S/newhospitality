<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: viewfriendsuggestion.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<div class="layout_left">
    <?php 
    $obj = $this->getVars();
    echo $this->content()->renderWidget('user.profile-picture');
    echo $this->content()->renderWidget('user.profile-options');
    echo $this->content()->renderWidget('user.list-online');
    $this->setVars($obj);
    ?>
</div>
<div class="layout_middle">
<div class="subsection content_invite">
    <h2><?php echo $this->translate('All requests'); ?></h2>
    <div class="suggestion-friends" style="border-bottom:none;">
    <div style="padding:10px;">	
    	<ul class='requests'>
          <?php if( $this->requests->getTotalItemCount() > 0 ): ?>
            <?php foreach( $this->requests as $notification ): ?>
              <?php
                $parts = explode('.', $notification->getTypeInfo()->handler);
                echo $this->action($parts[2], $parts[1], $parts[0], array('notification' => $notification));
              ?>
            <?php endforeach; ?>
          <?php else: ?>
            <li>
              <?php echo $this->translate("You have no requests.") ?>
            </li>
          <?php endif; ?>
        </ul>
     </div>
    </div>	  
    <h2><?php echo $this->translate("Find your Friends"); ?></h2>
	<?php if ($this->user_id) { ?>
	<div id="id_show_networkcontacts" style="display:block"  class="suggestion-friends">
		<div class="sub-title">
			<?php echo $this->translate("Search your Webmail account."); ?>			
		</div>
		<div class="webacc-logos">
			 <!--FINDING FRIENDS FROM USER'S GOOGLE CONTACTS LIST.-->
			<a href='javascript:void(0)' onclick="show_contacts_google(1);" ><?php echo $this->htmlImage('application/modules/Suggestion/externals/images/gmail.png', '') ?></a>
			
			<!--FINDING FRIENDS FROM USER'S YAHOO CONTACTS LIST.-->
			<?php $yahoo_apikey = Engine_Api::_()->getApi('settings', 'core')->getSetting('yahoo.apikey');
						$yahoo_secret = Engine_Api::_()->getApi('settings', 'core')->getSetting('yahoo.secretkey');
			 if (!empty($yahoo_apikey) && !empty($yahoo_secret)) {?>
				<a href='javascript:void(0)' onclick="show_contacts_yahoo(1);" ><?php echo $this->htmlImage('application/modules/Suggestion/externals/images/yahoomail.png', '') ?></a>
      <?php } ?>
			
			<!--FINDING FRIENDS FROM USER'S WINDOW LIVE CONTACTS LIST.
			<?php $windowlive_apikey = Engine_Api::_()->getApi('settings', 'core')->getSetting('windowlive.apikey');
						$windowlive_secret = Engine_Api::_()->getApi('settings', 'core')->getSetting('windowlive.secretkey');
			 if (!empty($windowlive_apikey) && !empty($windowlive_secret)) {?>
				<a href='javascript:void(0)' onclick="show_contacts_windowlive(1);" ><?php //echo $this->htmlImage('application/modules/Suggestion/externals/images/windowslive.png', '') ?></a>
			<?php } ?>
			-->
			<!--FINDING FRIENDS FROM USER'S AOL CONTACTS LIST.-->
			<a href='javascript:void(0)' onclick="show_contacts_aol(1);" ><?php echo $this->htmlImage('application/modules/Suggestion/externals/images/aol.png', '') ?></a>
		
  </div>
		<div class="sub-txt">
			<?php echo $this->translate("Click on one of the above services to search your email account."); ?>
			<br />
			<?php echo $this->htmlImage('application/modules/Suggestion/externals/images/lock.gif', '', array('style'=>'float:left;margin-right:5px;')) ?>
			<?php echo Engine_Api::_()->getApi('settings', 'core')->getSetting('core.general.site.title');?>
			<?php echo $this->translate("will not store your account information."); ?>			
		</div>
	</div>
	
	<div id="id_csvcontacts" style="display:none" class="suggestion-friends">
		<div class="header">	
			<div class="title">
				<?php echo $this->htmlImage('application/modules/Suggestion/externals/images/webmail.png', '') ?>
				<?php echo $this->translate("Find People You Email"); ?>				
			</div>	
			<div class="webmail-options">
				<a href="javascript:void(0);" onclick="showhide('id_csvcontacts', 'id_show_networkcontacts')"><?php echo $this->translate("Use your webmail contacts"); ?></a><br>
				<div class="icons">
					<a href="javascript:void(0);" onclick="showhide('id_csvcontacts', 'id_show_networkcontacts')"><?php echo $this->htmlImage('application/modules/Suggestion/externals/images/gmail16.png', '') ?></a>
					<a href="javascript:void(0);" onclick="showhide('id_csvcontacts', 'id_show_networkcontacts')"><?php echo $this->htmlImage('application/modules/Suggestion/externals/images/yahoo16.png', '') ?></a>
					<a href="javascript:void(0);" onclick="showhide('id_csvcontacts', 'id_show_networkcontacts')"><?php echo $this->htmlImage('application/modules/Suggestion/externals/images/windowslive16.png', '') ?></a>
					<a href="javascript:void(0);" onclick="showhide('id_csvcontacts', 'id_show_networkcontacts')"><?php echo $this->htmlImage('application/modules/Suggestion/externals/images/aol16.png', '') ?></a>
				</div>
			</div>
		</div>
		<div class="sub-title">
			<?php echo $this->translate("Search your contacts in your contact file."); ?>			
		</div>
		<div class="upload-contact-file">
			<div class="op-cat"><?php echo $this->translate("Contact file :"); ?></div>
			<div class="op-field">
				<iframe id='ajaxframe' name='ajaxframe' style='display: none;' src='javascript:void(0);' onchange="myform();"></iframe>
				<form method="post" action="<?php echo $this->baseurl . '/suggestion/usercontacts/uploads'?>" name="csvimport" id="csvimport" enctype="multipart/form-data" target="ajaxframe"> 

					<input name="Filedata"  class="inputbox" type="file"  id="Filedata"  size="23" value="" onchange="savefilepath();"><br />
					<span><?php echo $this->translate("Contact file must be of .csv or .txt format"); ?></span><br />
					<button style="margin-top:10px;" id="csvmasssubmit" name="csvmasssubmit" onClick="getcsvcontacts();return false;"><?php echo $this->translate("Find Friends"); ?></button>
				</form>
			</div>	
		</div>
		<div class="help-link">
			<?php echo $this->htmlImage('application/modules/Suggestion/externals/images/support.png', '', array('style'=>'float:left;margin-right:2px;')) ?>
			<a href="javascript:void(0);" onclick="show_services();"><?php echo $this->translate("Supported Services"); ?></a><br>
			<?php echo $this->htmlImage('application/modules/Suggestion/externals/images/help.png', '', array('style'=>'float:left;margin-right:2px;')) ?>
			<a href="javascript:void(0);" onclick="show_createfile();"><?php echo $this->translate("How to create a contact file"); ?></a>
		</div>	
	</div>
<?php } ?>

   <div id="id_success_frequ" style="display:none;">
		<ul class="form-notices" style="float:left;margin:0;"><li  style="width:350px;"><?php echo $this->translate("Your friend request(s) have been successfully sent!"); ?></li></ul>
  </div>
	<div id="id_nonsite_success_mess" style="display:none;">
		<ul class="form-notices" style="float:left;margin:0;"><li style="width:680px;"><?php echo $this->translate("Your invitation(s) were sent successfully. If the persons you invited decide to join, they will automatically receive a friend request from you."); ?></li></ul>
	</div>		
    <br />
	<div class="suggestion-friends" style="display:none;" id="network_friends">
		<div id="show_contacts"> </div>
	</div>		

	<div id="id_csvformate_error_mess" style="display:none;">
		<ul class="form-errors"><li><ul class="errors"><li><?php echo $this->translate("Invalid file format."); ?></li></ul></li></ul>
  </div>
   <br />
	<div class="suggestion-friends" style="display:none;" id="network_friends">
		<div id="show_contacts"> </div>
	</div>		

	
	<div class="suggestion-friends" style="display:none;" id="csv_friends">
		<div id="show_contacts_csv"> </div>
	</div>		
<h2><?php echo $this->translate('Search for People'); ?></h2>
<div class="suggestion-friends" style="border-bottom:none;">	
	<div class="people-search">
	  <form action="<?php echo $this->baseurl . '/members' ; ?>">
	  <input type="text" name="displayname" id="displayname">
		<button type='submit'><?php echo $this->translate("Search"); ?></button>
	  </form>
	 </div>
</div>	  	
<h2><?php echo $this->translate("People You May Know"); ?></h2>
<div id="peo_list_box" style="margin-bottom:0px;">
<?php
// If no record found then show message.
if(isset($this->message))
{
	echo $this->message;
}
else {
	$this->headScript()
	  ->appendFile('application/modules/Suggestion/externals/scripts/core.js');
	
	//MAKE STRING OF CURRENT USER DISPLAY
	$suggestion_viewfriend_users_array = $this->suggestion_viewfriend_user_combind_path;
	$suggestion_count = count($this->suggestion_viewfriend_user_combind_path);
	$suggestion_viewfriend_users_str = implode(",", $suggestion_viewfriend_users_array);
	?>
	<script type="text/javascript">
		var friend_displayed_suggestions = "<?php echo $suggestion_viewfriend_users_str; ?>";
		var suggestion_display_count = "<?php echo $suggestion_count; ?>";		
		var cancelFriSuggestion = function(entity_id, div_id)
		{
		  en4.core.request.send(new Request.HTML({      	
		    url : en4.core.baseUrl + 'suggestion/main/suggestion-disable',
		    data : {
		      format : 'html',
		      entity_id : entity_id,     
		      div_id : div_id,
		      suggestion_display_count : suggestion_display_count,
		      friend_displayed_suggestions : friend_displayed_suggestions
		    }
		  }), {
		    'element' : $(div_id)
		  })
		};
	</script>
	<div class="suggestion_friends">
	<?php
	$div_id = 1;
	$send_request_user_info_array = array();
	foreach( $this->suggestion_viewfriend_users_info as $user_info ): ?>
		<div id="suggestion_friend_<?php echo $div_id; ?>">
			<div class="list" >	
				<div class="user_photo">
					<?php
				 	echo $this->htmlLink($user_info->getHref(), $this->itemPhoto($user_info, 'thumb.icon'), array('class' => 'popularmembers_thumb')); ?>
				</div>
				<div class="user_details">
					<span >
					<?php if(empty($this->signup_user)) {
				echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="cancelFriSuggestion(' . $user_info->user_id . ', \'suggestion_friend_'.$div_id.'\');"></a>';
					} ?>
					</span>
					<p class="name"><?php echo $this->htmlLink($user_info->getHref(), Engine_Api::_()->suggestion()->truncateTitle($user_info->getTitle()), array('title' => $user_info->getTitle())) . '<br>'; ?></p>

					<?php	echo $this->userFriendship($user_info);	?>
					<div style="display:none">
						<form enctype="application/x-www-form-urlencoded" id="ajax-add-friend-<?php echo $user_info->user_id ?>" action="/members/friends/add/user_id/<?php echo $user_info->user_id ?>">

						</form>
					</div>
				</div>
			</div>		
		</div>
		<?php
		$div_id++;
			endforeach;
		}
		?>
	</div>	
</div>
</div>	
<div style="display:none" id="myid">
	<div class="suggestion-help-popup">
		<ul>
			<li>
				<a href='javascript: toggle("id_outlook")'><?php echo $this->translate('Microsoft Outlook'); ?></a>
				<ul style="display:none;" id="id_outlook">
					<li>	
						<?php echo $this->translate('To export a CSV file from Microsoft Outlook:'); ?>						
						<ol>
							<li><?php echo $this->translate('1. Open Outlook'); ?></li>
							<li><?php echo $this->translate("2. Go to File menu and select 'Import and Export'"); ?></li>
							<li><?php echo $this->translate("3. In the wizard window that appears, select 'Export to a file' and click 'Next'"); ?></li>
							<li><?php echo $this->translate("4. Select 'Comma separated values (Windows)' and click 'Next'"); ?></li>
							<li><?php echo $this->translate("5. Select where you want to save the exported CSV file, choose a name for your file (example : mycontacts.csv) and click 'Next'"); ?></li>
							<li><?php echo $this->translate("6. Ensure that the checkbox next to 'Export..' is checked and click 'Finish'."); ?></li>
						</ol>	
					</li>	
				</ul>
			</li>
			<li>
				<a href='javascript: toggle("id_microsoftoutlook")'><?php echo $this->translate('Microsoft Outlook Express'); ?></a>
				<ul style="display:none" id="id_microsoftoutlook">
					<li>
						<?php echo $this->translate('To export a CSV file from Microsoft Outlook Express:'); ?>
						
						<ol>
							<li><?php echo $this->translate('1. Open Outlook Express'); ?></li>
							<li><?php echo $this->translate("2. Go to File menu and select 'Export', and then click 'Address Book'"); ?></li>
							<li><?php echo $this->translate("3. Select 'Text File (Comma Separated Values)', and then click 'Export'"); ?></li>
							<li><?php echo $this->translate("4. Select where you want to save the exported CSV file, choose a name for your file (example : mycontacts.csv) and click 'Next'"); ?></li>
							<li><?php echo $this->translate("5. Select the check boxes for the fields that you want to export (be sure to select the email address field), and then click 'Finish'."); ?></li>
						</ol>	
					</li>	
				</ul>
			</li>
			<li>
		    <a href='javascript: toggle("id_mozila_thunder")'><?php echo $this->translate('Mozilla Thunderbird'); ?></a>
				<ul style="display:none" id="id_mozila_thunder">
					<li>
						<?php echo $this->translate('To export a CSV file from Mozilla Thunderbird:'); ?>
						
						<ol>
							<li><?php echo $this->translate('1. Open Mozilla Thunderbird'); ?></li>
							<li><?php echo $this->translate("2. Go to Tools menu and select 'Address Book'"); ?></li>
							<li><?php echo $this->translate("3. In the 'Address Book' window that opens, select 'Export...' from the Tools menu"); ?></li>
							<li><?php echo $this->translate("4. Select where you want to save the exported file, choose 'Comma Separated (*.CSV)' under the 'Save as type' dropdown list, choose a name for your file (example : mycontacts.csv) and click 'Save'."); ?></li>
						</ol>	
					</li>	
				</ul>
			</li>
			<li>
				<a href='javascript: toggle("id_linkedin")'><?php echo $this->translate('LinkedIn'); ?></a>
				<ul style="display:none" id="id_linkedin">
					<li>
						<?php echo $this->translate('To export a CSV file from LinkedIn:'); ?>
						
						<ol>
							<li><?php echo $this->translate('1. Sign into your LinkedIn account'); ?></li>
							<li><?php echo $this->translate('2. Visit the'); ?> <a href='http://www.linkedin.com/addressBookExport' target="_blank"><?php echo $this->translate('Address Book Export'); ?></a><?php echo $this->translate(' page'); ?></li>
							<li><?php echo $this->translate("3. Select 'Microsoft Outlook (.CSV file)' under the 'Export to' dropdown list and click 'Export'"); ?></li>
							<li><?php echo $this->translate('4. Select where you want to save the exported CSV file, choose a name for your file (example : mycontacts.csv).'); ?></li>
						</ol>
					</li>	
				</ul>
			</li>
			<li>
				<a href='javascript: toggle("id_windowabook")'><?php echo $this->translate('Windows Address Book'); ?></a>
				<ul style="display:none" id="id_windowabook">
					<li>
						<?php echo $this->translate('To export a CSV file from Windows Address Book:'); ?>
					<ol>
							<li><?php echo $this->translate('1. Open Windows Address Book'); ?></li>
							<li><?php echo $this->translate("2. Go to the File menu, select 'Export', and then select 'Other Address Book...'"); ?></li>
							<li><?php echo $this->translate("3. In the 'Address Book Export Tool' dialog that opens, select 'Text File (Comma Separated Values)' and click 'Export'"); ?></li>
							<li><?php echo $this->translate("4. Select where you want to save the exported CSV file, choose a name for your file (example : mycontacts.csv) and click 'Next'"); ?></li>
							<li><?php echo $this->translate("5. Select the check boxes for the fields that you want to export (be sure to select the email address field), and then click 'Finish'."); ?></li>
							<li><?php echo $this->translate("6. Click 'OK' and then click 'Close'"); ?></li>
						</ol>
					</li>	
				</ul>
			</li>	
			<li>
				<a href='javascript: toggle("id_macos")'><?php echo $this->translate('Mac OS X Address Book'); ?></a>
				<ul style="display:none" id="id_macos">
					<li>
					<?php echo $this->translate('To export a CSV file from Mac OS X Address Book:'); ?>
					
						<ol>
							<li><?php echo $this->translate('1. Download the free Mac Address Book exporter from'); ?> <a href='http://www.apple.com/downloads/macosx/productivity_tools/exportaddressbook.html' target="_blank">here</a>.</li>
							<li><?php echo $this->translate('2. Choose to export your Address Book in CSV format.'); ?></li>
							<li><?php echo $this->translate('3. Save your exported address book in CSV format.'); ?></li>
						</ol>	
					</li>	
				</ul>
			</li>	
			<li>
				<a href='javascript: toggle("id_palmdesktop")'><?php echo $this->translate('Palm Desktop'); ?></a>
				<ul style="display:none" id="id_palmdesktop">
					<li>
						<?php echo $this->translate('To export a CSV file from Palm Desktop:'); ?>
						
						<ol>
							<li><?php echo $this->translate('1. Open Palm Desktop'); ?></li>
							<li><?php echo $this->translate("2. Click on the 'Addresses' icon on the lefthand side of the screen to display your contact list"); ?></li>
							<li><?php echo $this->translate("3. Go to the File menu, select 'Export'"); ?></li>
							<li><?php echo $this->translate('4. In the dialog box that opens, do the following:'); ?></li>
							<li><?php echo $this->translate("5. Enter a name for the file you are creating in the 'File name:' field"); ?></li>
							<li><?php echo $this->translate("6. Select 'Comma Separated' in the 'Export Type' pulldown menu"); ?></li>
							<li><?php echo $this->translate("7. Be sure to select the 'All' radio button from the two 'Range:' radio buttons"); ?></li>
							<li><?php echo $this->translate("8. In the second dialog box: 'Specify Export Fields' that opens, leave all of the checkboxes checked, and click 'OK'."); ?></li>
						</ol>
					</li>
				</ul>
			</li>
			<li>
				<a href='javascript: toggle("id_windowmail")'><?php echo $this->translate('Windows Mail'); ?></a>
				<ul style="display:none" id="id_windowmail">
					<li>
						<?php echo $this->translate('To export a CSV file from Windows Mail:'); ?>
						
						<ol>
							<li><?php echo $this->translate('1. Open Windows Mail'); ?>
							<li><?php echo $this->translate('2. Select: Tools | Windows Contacts... from the menu in Windows Mail'); ?>
							<li><?php echo $this->translate("3. Click 'Export' in the toolbar"); ?>
							<li><?php echo $this->translate("4. Make sure CSV (Comma Separated Values) is highlighted, then click 'Export'"); ?>
							<li><?php echo $this->translate("5. Select where you want to save the exported CSV file, choose a name for your file (example : mycontacts.csv) and click 'Next'"); ?>
							<li><?php echo $this->translate("6. Click 'Save' then click 'Next'"); ?>
							<li><?php echo $this->translate('7. Make sure all address book fields you want included are checked'); ?>
							<li><?php echo $this->translate("8. Click 'Finish'"); ?></li>
							<li><?php echo $this->translate("9. Click 'OK' then click 'Close'"); ?></li>
						</ol>	
					</li>	
				</ul>
			</li>	
			<li>
				<a href='javascript: toggle("id_othermail")'><?php echo $this->translate('For Other'); ?></a>
				<ul style="display:none" id="id_othermail">
					<li>
							<?php echo $this->translate('Many email services, email applications, address book management applications allow contacts to be imported to a file. We support .CSV and .TXT types of contact files'); ?>
						
					</li>	
				</ul>
			</li>	
			<script type="text/javascript">
			function toggle(divid){ 
			  $('myid').innerHTML = '';
				var div1 = $(divid);
				if (div1.style.display == 'none') {
					div1.style.display = 'block'
				} else {
					div1.style.display = 'none'
				}
			}
			</script>
		</ul>
		
	</div>	
	<button onclick="parent.Smoothbox.close();"><?php echo $this->translate('Close'); ?></button>
</div>
    <?php
    if(!empty($this->paginator)){
    foreach( $this->paginator as $search_result ): 
	    echo $this->htmlLink($search_result->getHref(), $this->itemPhoto($search_result, 'thumb.icon'), array('class' => 'popularmembers_thumb'));
			echo $this->htmlLink($search_result->getHref(), $search_result->getTitle());
    endforeach; 
    echo $this->paginationControl($this->paginator);
    }
   

if ($this->user_id) { 
  ?>
</div>
<form action="" id="id_myform_temp" name="id_myform_temp">

</form>
<?php } ?>
<?php
$session = new Zend_Session_Namespace();
$this->headScript()
  ->appendFile('application/modules/Suggestion/externals/scripts/usercontacts.js');
?>


<script type="text/javascript">
//RETRIVING THE VALUE FROM SESSION AND CALL THE CORROSPONDING ACTION FOR WHICH SERVICE IS BEING CURRENTLY EXECUTING.
var googleredirect = '<?php echo $session->googleredirect;?>';
var yahooredirect = '<?php echo $session->yahooredirect;?>';
var aolredirect = '<?php echo $session->aolredirect;?>';
var windowliveredirect = '<?php echo $session->windowlivemsnredirect;?>';
if (googleredirect == 1) { 
  show_contacts_google (0);
}
else if (yahooredirect == 1) {
	show_contacts_yahoo (0);
}
else if (aolredirect == 1) {
	show_contacts_aol (0);
}
else if (windowliveredirect == 1 ) {
  show_contacts_windowlive (0);
}

function show_services() {
	 var supported_services = '<div class="suggestion-mail-supported"> <h2><?php echo $this->string()->escapeJavascript($this->translate("Supported Services")) ?></h2><img src="application/modules/Suggestion/externals/images/outlook.png" alt="" /> <?php echo $this->string()->escapeJavascript($this->translate(" Microsoft Outlook ")) ?> <br /><img src="application/modules/Suggestion/externals/images/outlookexpress.gif" alt="" /><?php echo $this->string()->escapeJavascript($this->translate(" Microsoft Outlook Express ")) ?><br /><img src="application/modules/Suggestion/externals/images/thunderbird.png" alt="" /><?php echo $this->string()->escapeJavascript($this->translate(" Mozilla Thunderbird ")) ?> <br / ><img src="application/modules/Suggestion/externals/images/linkedin.png" alt="" /> <?php echo $this->string()->escapeJavascript($this->translate(" LinkedIn ")) ?> <br /><img src="application/modules/Suggestion/externals/images/windowslive16.png" alt="" /> <?php echo $this->string()->escapeJavascript($this->translate(" Windows Address Book ")) ?> <br /><img src="application/modules/Suggestion/externals/images/addressbook.png" alt="" /> <?php echo $this->string()->escapeJavascript($this->translate(" Mac OS X Address Book ")) ?><br /><img src="application/modules/Suggestion/externals/images/palm.gif" width="16" alt="" /><?php echo $this->string()->escapeJavascript($this->translate(" Palm Desktop ")) ?><br /><img src="application/modules/Suggestion/externals/images/windowslive16.png" alt="" /> <?php echo $this->string()->escapeJavascript($this->translate(" Windows Mail ")) ?> <br /><img src="application/modules/Suggestion/externals/images/plus.png" alt="" /> <?php echo $this->string()->escapeJavascript($this->translate(" Other ")) ?><br /><br /><button onclick="javascript:close_popup();"><?php echo $this->string()->escapeJavascript($this->translate("Close")) ?></button></div>';
	Smoothbox.open( supported_services);
 }

 function show_createfile() {
  if ($('myid').innerHTML != '') {
		var howToCreateFile = $('myid').innerHTML;
	}
	Smoothbox.open(howToCreateFile);
	
 }

function close_popup () {
 Smoothbox.close();

}
</script>
<?php $ajaxloaderimg = $this->baseUrl() ."/externals/smoothbox/ajax-loader.gif" ; ?>
<script type="text/javascript">
function openUrl(url){
    Smoothbox.open(url);
}
function sendAjaxAddfriend(id, isAjax, object){
	var form_id = '#ajax-add-friend-' + id;
	var form = jQuery(form_id);
	var url = form.attr("action");

	var parentObject = jQuery(object);
	//var parentObject = jQuery(object).parent();
	jQuery.ajax( {
		type: "POST",
		url: url,
		data: form.serialize(),
		beforeSend: function ( xhr ) {
		    //xhr.overrideMimeType("text/plain; charset=x-user-defined");
		    //console.log("sending");
		    parentObject.html('<img src="<?php echo $ajaxloaderimg ?>"/>');		
		},
		success: function( response ) {
			//console.log( response );

			parentObject.parent().parent().remove();
			//cancelFriSuggestion(id, parentObject.parent().parent().parent().attr('id'));

			var count = jQuery("div.suggestion_friends").children().length;
			if(count == 0){
				jQuery("div.suggestion_friends").parent().remove();
			}
			//console.log("sent");
		}
	});
}
</script>
