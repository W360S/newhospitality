<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: index.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

$this->headScript()->appendFile('application/modules/Suggestion/externals/scripts/core.js');
  
$forum_display_array = array_keys($this->forum_display);
$suggestion_msg = count($forum_display_array);
$forum_sugg_str =  implode(",", $forum_display_array);
?>


<script type="text/javascript">
	var forum_suggestion_display = "<?php echo $suggestion_msg; ?>";
	display_sugg += ',' + '<?php echo $forum_sugg_str; ?>';
</script>

<div class="suggestion_right_block">
	<?php $div_id = 1;
		foreach ($this->forum_info as $forum_dis):
		$forum_name =  Engine_Api::_()->getItem('forum_forum', $forum_dis->forum_id); ?>
		<div id="forum_<?php echo $div_id; ?>">
			<div class="suggestion_list">
				<div class="item_photo">
				<?php $photo_obj = Engine_Api::_()->getItem('user', $forum_dis->user_id); ?>
					<?php echo $this->htmlLink($forum_dis->getHref(), $this->itemPhoto($photo_obj->getOwner(), 'thumb.icon')); ?>
				</div>		
				<div class="item_details">
				<?php if(empty($this->signup_user)) {
				echo	'<a style="margin-top:5px;" class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="mixInfo(' . $forum_dis->topic_id . ', \'forum_'.$div_id.'\', \'forum\', \'forum\');"></a>';
					} ?>			
					<b><?php	echo $this->htmlLink($forum_dis->getHref(),  Engine_Api::_()->suggestion()->truncateTitle($forum_dis->getTitle()), array('title' => $forum_dis->getTitle()));?></b>
					<div class="item_members">
						<?php echo  $this->translate(' in ') . $this->htmlLink($forum_name->getHref(), Engine_Api::_()->suggestion()->truncateTitle($forum_name->getTitle()), array('title' => $forum_name->getTitle())); ?>
						<div>
						<?php
						echo $this->translate(array('%s Reply', '%s Replies', $forum_dis->post_count), $this->locale()->toNumber($forum_dis->post_count)) . ' | ' . $this->translate(array('%s View', '%s Views', $forum_dis->view_count), $this->locale()->toNumber($forum_dis->view_count)) . '<br/>';
						$category_title = Engine_Api::_()->getItem('forum_category', $forum_name->category_id)->title;
						echo $this->translate('Category : ') . $category_title;					
						$div_id++;
						?>		
						</div>
						<?php echo $this->htmlLink($forum_dis->getHref(), $this->translate('View Forum Topic'), array('class' => 'buttonlink notification_type_forum_suggestion')); ?>
						</div>					
					</div>
				</div>
			</div>
		<?php endforeach; ?>
	<div style="clear:both"></div>
</div>