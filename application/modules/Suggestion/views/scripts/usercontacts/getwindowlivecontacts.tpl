<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: getwindowlivecontacts.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
 if (!$this->errormessage) {
if (!empty($this->addtofriend)) {?>

  <div id='show_sitefriend' style="display:block;">
		
<?php
} 
else { ?>
  <div id='show_sitefriend' style="display:none;">
<?php
}  
$total = count($this->addtofriend);
if ($total > 0) { ?>
  <div class="header">	
			<div class="title">	
				You have <?php echo $total . " Window Live contacts that you can add as your friends on " .  Engine_Api::_()->getApi('settings', 'core')->getSetting('core.general.site.title') . "."; ?>
			</div>
			<div>
				<br /><?php echo $this->translate("Select the contacts to add as friends from the list below.");?>
			</div>		
		</div>
	
<?php }
if (!empty($this->addtofriend)) { ?>
	<div class="member-friend-list">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td width="5%">
					 <input type="checkbox" name="select_all"  id="select_all" onclick="checkedAll();" checked="checked">
				</td>
				<td colspan="2">
					<b><?php echo $this->translate("Select all");?></b>
				</td>
			</tr>
  <?php
  $total_contacts = 0;
  foreach($this->addtofriend as $values) {
		foreach ($values as $value) { 
			$total_contacts++;?>
			<tr>
				<td width="5%">
					<input type="checkbox" name="contactname_"<?php echo $total_contacts;?>  id="contact_<?php echo $total_contacts;?>" value="<?php echo $value['user_id'];?>" checked="checked">
				</td>
				<td width="12%">
					<?php echo $this->itemPhoto($value, 'thumb.icon');?>
				</td>
				<td>
					<b><?php echo $value['displayname'];?></b>
				</td>
			</tr>
<?php	} 
  } ?>
  </table>
		</div>
		<div class="buttons" style="clear:both;">
			<button name="addtofriends"  id="addtofriends" onclick="sendFriendRequests();"><?php echo $this->translate("Add as Friends");?></button> <?php echo $this->translate("or");  ?>
			<button class="disabled" name="skip_addtofriends"  id="skip_addtofriends" onclick="skip_addtofriends();"><?php echo $this->translate("Skip");?></button>
		</div>
	
  <input type="hidden" name="total_contacts"  id="total_contacts" value="<?php echo $total_contacts;?>" >
<?php
}
?>

</div>

<?php 
if (empty($this->addtofriend)) { ?>
  <div id='show_nonsitefriends' style="display:block;">
		
<?php
} else { ?>
  <div id='show_nonsitefriends' style="display:none;">
<?php
}
$total = count($this->addtononfriend);
if ($total > 0) { ?>
		<div class="header">	
			<div class="title">	
				<?php echo $this->translate("You have ");?> <?php echo $total . $this->translate(" Window Live contacts that are not members of ") .  Engine_Api::_()->getApi('settings', 'core')->getSetting('core.general.site.title') . "."; ?>
			</div>
			<div>
				<br /><?php echo $this->translate("Select the contacts to invite from the list below.");?>
			</div>
		</div>
<?php  
	
}
if (!empty($this->addtononfriend)) { ?>
	<div class="member-friend-list">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td width="5%">
					<input type="checkbox" name="nonsiteselect_all"  id="nonsiteselect_all" onclick="nonsitecheckedAll();" checked="checked">
				</td>
				<td colspan="2">
					<b><?php echo $this->translate("Select all");?></b>
				</td>
			</tr>
<?php
  $total_contacts = 0;
  foreach($this->addtononfriend as $values) {
	$total_contacts++;?>
	<tr>
		<td width="5%">
			<input type="checkbox" name="nonsitecontactname_"<?php echo $total_contacts;?>  id="nonsitecontact_<?php echo $total_contacts;?>" checked="checked" value='<?php echo $values['contactMail'];?>'>
		</td>
		<td>
			<b><?php echo $values['contactName'];?></b>
		</td>
		<td>
			<?php echo $values['contactMail']; ?>
		</td>
	</tr>	
	
	<?php
	
  } ?>

  <input type="hidden" name="nonsitetotal_contacts"  id="nonsitetotal_contacts" value="<?php echo $total_contacts;?>"  onclick="nonsiteInviteFriends();">
  </table>
		</div>
		<div class="buttons" style="clear:both;width:90%;" >
			<button name="invitefriends"  id="invitefriends" onclick="inviteFriends();" style="float:left;margin-right:4px;"><?php echo $this->translate("Invite to Join");?></button>
			<form action="" method="post" >	
			<?php echo $this->translate("or");  ?> <button class="disabled" name="skip_invite"  id="skip_invite"  type="submit"><?php echo $this->translate("Skip");?></button>
			</form>
		</div>
 
<?php
} ?>
</div>
<?php
}
else {
	echo "<div>" . $this->translate("All your imported contacts are already members of ")  . Engine_Api::_()->getApi('settings', 'core')->getSetting('core.general.site.title') . ".</div>";
}
?>

