<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: poll.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

$this->headScript()->appendFile('application/modules/Suggestion/externals/scripts/core.js');

//MAKE STRING OF CURRENT USER DISPLAY
$suggestion_viewfriend_users_array = $this->poll_combind_path;
$suggestion_message = count($this->poll_combind_path);
$suggestion_viewfriend_users_str = implode(",", $suggestion_viewfriend_users_array);
?>

<script type="text/javascript">
	var poll_displayed_suggestions = "<?php echo $suggestion_viewfriend_users_str; ?>";
	var poll_sugg_message = "<?php echo $suggestion_message; ?>";
	var action_session_id = "<?php echo $this->poll_id;  ?>";
 
	var suggestion_string = '';
	var show_selected = '<?php echo $this->show_selected;?>';
	var friends_count = '<?php echo $this->friends_count;?>';
	var suggestion_string_temp = '<?php echo $this->selected_checkbox;?>';
	var memberSearch = '<?php echo $this->search ?>';
	var memberPage = <?php echo sprintf('%d', $this->members->getCurrentPageNumber()) ?>;
	var action_module = 'poll';
	
	// Note : In the poll suggestions popup, the baseurl variable of JS does not get set, because default.tpl is not called for this. Thus, we set it explicitly.
	en4.core.setBaseUrl('<?php echo $this->url(array(), 'default', true) ?>');
	
	en4.suggestion.polls = {
	
	pollUser : function(poll_div_id)
	{
	  var request = new Request.JSON({   	  	
	    url : en4.core.baseUrl + 'suggestion/main/suggestion-poll',
	    data : {
	      format : 'json',    
	      poll_div_id : poll_div_id,
	      session_poll_id : action_session_id,
	      poll_dis_sugg : poll_displayed_suggestions	      
	    }
	  });
	  request.send();
	  return request;
	}
};
	function selectAll(){
	   $$('input[type=checkbox]').set('checked', $('selectAll').get('checked', false)); 
	}
</script>
  
<?php 
if (!$this->search_true) {?>
	<div class="suggestion_popup">
		<?php $poll_displayname = Engine_Api::_()->getItem('poll', $this->poll_id)->title;  ?>
	  <h4><?php echo $this->translate("Select friends of yours who might be interested in ") . '<u>' . $poll_displayname . '</u>'; ?></h4>
		<p><?php echo $this->translate("Selected friends will get a suggestion from you to vote on this poll."); ?></p>
		<div class="suggestion_member_search_box">
            <label style="float: left;"><?php echo $this->translate("Select All")?>:</label>
            <input style="width: 33px;" type="checkbox" onClick="selectAll();" id="selectAll" />
            <label style="float: left; padding-right: 10px;"><?php echo $this->translate("Or")?>:</label>
			<div class="poll_members_search" style="float:left;">
	      <input id="poll_members_search_inputd" type="text" value="<?php echo $this->translate("Search Members"); ?>" onkeyup="show_searched_friends(0, event);">
	    </div>
	    <div class="link">
	    	<a href="javascript:void(0);" onClick='javascript:show_all();' class="selected" id="show_all"><?php echo $this->translate('All'); ?></a>
				<a href="javascript:void(0);" id="selected_friends" onclick="javascript:selected_friends();" class=""><?php echo $this->translate('Selected'); ?>(0) </a>
			</div>
	 	</div>	
<?php } ?>

<?php if (!$this->search_true) {?>
	<div id="main_box">
<?php } ?>
	<form name="suggestion" method="POST" class="suggestion_form_popup" >
		<input type="hidden" name="poll" value="<?php echo $this->poll_id;  ?>" />
        <input type="hidden" id="checkbox_user" name="checkbox_user" value="<?php echo $this->selected_checkbox;?>" />
		<div id="hidden_checkbox"> </div>
		<div class="suggestion_popup_box">	
			<?php $div_id = 1;
			$send_request_user_info_array = array();
		if (!empty($this->poll_combind_path)) {
			foreach( $this->suggest_user as $user_info ): ?>
				<div id="suggestion_friend_<?php echo $div_id; ?>" style="float:left;">
					<div class="suggestion_pop_friend " id="check_<?php echo $user_info->user_id; ?>_div">
						<input type="checkbox" onclick="moduleSelect('check_<?php echo $user_info->user_id; ?>', '<?php echo $user_info->user_id; ?>', '<?php echo $user_info->getTitle(); ?>')" name="check_<?php echo $user_info->user_id; ?>" value="<?php echo $user_info->user_id; ?>" id="check_<?php echo $user_info->user_id; ?>" />
						<div class="popup_member_photo">
							<?php echo $this->itemPhoto($user_info, 'thumb.icon'); ?>
						</div>						
						<div class="title">
							
							<b><?php	echo $user_info->getTitle(); ?></b>
						</div>
						<div style="clear:both;"></div>
					</div>
				</div>	
			<?php $div_id++; endforeach;	} else {?>
			 <center><div class='tip' style="margin:10px 0 0 140px;"><span><?php echo $this->translate('No friends were found to match your search criteria.'); ?></span></div></center>
			<?php } ?>	
		</div>
		<?php if( $this->members->count() > 1 ): ?>
	    <div class="pagination">
	      <?php if( $this->members->getCurrentPageNumber() > 1 ): ?>
	        <div id="user_poll_members_previous" class="paginator_previous" style="font-weight:bold;">
	          <?php echo $this->htmlLink('javascript:void(0);', $this->translate("&laquo; Prev"), array(
	            'onclick' => 'paginateMembers(memberPage - 1);'
	            
	          )); ?>
	        </div>
	      <?php endif; ?>
	      <?php if( $this->members->getCurrentPageNumber() < $this->members->count() ): ?>
	        <div id="user_poll_members_next" class="paginator_next" style="font-weight:bold;">
	          <?php echo $this->htmlLink('javascript:void(0);', $this->translate("Next &raquo;") , array(
	            'onclick' => 'paginateMembers(memberPage + 1);'	         
	          )); ?>
	        </div>
	      <?php endif; ?>
	    </div>
	  <?php endif; ?>
		<div class="popup_btm">
		<div id="check_error"></div>
			<button type='button' style="margin:10px 0 0 15px;" onClick='javascript:doCheckAll();'><?php echo $this->translate("Send Suggestions"); ?></button>
			 <?php echo $this->translate("or"); ?>  
			<a href="javascript:void(0);" onclick="cancelPopup();"><?php echo $this->translate("Cancel"); ?></a>
		</div>	
	</form>
<?php if (!$this->search_true) {?>
</div>
</div>
<?php } ?>