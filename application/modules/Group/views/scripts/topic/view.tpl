<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: view.tpl 7244 2010-09-01 01:49:53Z john $
 * @author		 John
 */
?>
<?php 
	$group= $this->group;
	$paginators= $this->paginator; 
	$topic= $this->topic;
	$form= $this->form;
	$placeholder= $this->placeholder('grouptopicnavi');
	$viewer= $this->viewer();
?>
<div class="content">
<div class="layout_right">
	<?php //echo $this->formFilter->setAttrib('class', 'filters')->render($this) ?>
    <div class="subsection">
        <h2>Featured groups</h2>
        <div class="subcontent">
            <div class="featured-groups-wrapper">
            	<div class="featured-groups">
					<?php $n= count($this->group1); if($n): ?>
					    <ul>
					    <?php $dem = 0;  foreach($this->group1 as $item): $dem++;  ?>
					    <?php  if((($dem-1) %8 == 0) && (($dem - 1) > 1)): ?>
					    </ul>
					    <ul>
					    <?php endif; ?>
    						<li>
					            <?php if(!empty($item['img_url'])): ?>
					                <img alt="Image" width="57" height="40" src="<?php echo $this->baseUrl(); ?>/<?php echo $item['img_url']; ?>">
					            <?php else: ?>
					                <img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/Core/externals/images/img-57x40.gif">
					            <?php endif; ?>
    						    <h3><a href="<?php echo $this->baseUrl().'/group/'.$item['group_id']; ?>"><?php echo $item['title'];?></a></h3>
    						    <div><?php  echo $this->translate(array('<strong>%s</strong> member', '<strong>%s</strong> members', $item['member_count']),$this->locale()->toNumber($item['member_count'])) ?></div>
    						</li>
					    <?php endforeach; ?>
					    </ul>
					<?php endif; ?>    
					</div>
                 
                 
            </div>
        </div>
    </div>
</div>
  
<div class="layout_middle"> 
<div class="headline">
<h2>
  <?php echo $group->__toString() ?>
  <?php echo $this->translate('&#187; Discussions');?>
</h2>
</div>

<h3>
  <?php echo $topic->getTitle() ?>
</h3>

<?php $placeholder->captureStart(); ?>
<div class="group_discussions_thread_options">
  <?php echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'topic', 'action' => 'index', 'group_id' => $group->getIdentity()), $this->translate('Back to Topics'), array(
    'class' => 'buttonlink icon_back'
  )) ?>
  <?php if($form ): ?>
    <?php echo $this->htmlLink($this->url(array()) . '#reply', $this->translate('Post Reply'), array(
      'class' => 'buttonlink icon_group_post_reply'
    )) ?>
  <?php endif; ?>
  <?php if( $group->isOwner($viewer) ): ?>
    <?php if( !$topic->sticky ): ?>
      <?php echo $this->htmlLink(array('action' => 'sticky', 'sticky' => '1', 'reset' => false), $this->translate('Make Sticky'), array(
        'class' => 'buttonlink icon_group_post_stick'
      )) ?>
    <?php else: ?>
      <?php echo $this->htmlLink(array('action' => 'sticky', 'sticky' => '0', 'reset' => false), $this->translate('Remove Sticky'), array(
        'class' => 'buttonlink icon_group_post_unstick'
      )) ?>
    <?php endif; ?>
    <?php if( !$topic->closed ): ?>
      <?php echo $this->htmlLink(array('action' => 'close', 'close' => '1', 'reset' => false), $this->translate('Close'), array(
        'class' => 'buttonlink icon_group_post_close'
      )) ?>
    <?php else: ?>
      <?php echo $this->htmlLink(array('action' => 'close', 'close' => '0', 'reset' => false), $this->translate('Open'), array(
        'class' => 'buttonlink icon_group_post_open'
      )) ?>
    <?php endif; ?>
    <?php echo $this->htmlLink(array('action' => 'rename', 'reset' => false), $this->translate('Rename'), array(
      'class' => 'buttonlink smoothbox icon_group_post_rename'
    )) ?>
    <?php echo $this->htmlLink(array('action' => 'delete', 'reset' => false), $this->translate('Delete'), array(
      'class' => 'buttonlink smoothbox icon_group_post_delete'
    )) ?>
  <?php elseif( $group->isOwner($viewer) == false): ?>
    <?php if( $topic->closed ): ?>
      <div class="group_discussions_thread_options_closed">
        <?php echo $this->translate('This topic has been closed.');?>
      </div>
    <?php endif; ?>
  <?php endif; ?>
</div>
<?php $placeholder->captureEnd(); ?>



<?php echo $placeholder ?>
<?php echo $this->paginationControl(null, null, null, array(
  'params' => array(
    'post_id' => null // Remove post id
  )
)) ?>


<script type="text/javascript">
  var quotePost = function(user, href, body)
  {
    $("body").value = '[blockquote]' + '[b][url=' + href + ']' + user + '[/url] said:[/b]\n' + body + '[/blockquote]\n\n';
    $("body").focus();
    $("body").scrollTo(0, $("body").getScrollSize().y);
  }
</script>



<ul class='group_discussions_thread'>
  <?php foreach( $paginators as $post ): ?>
  <li>
    <div class="group_discussions_thread_photo">
      <?php
        $user = $this->item('user', $post->user_id);
        echo $this->htmlLink($user->getHref(), $user->getTitle());
        echo $this->htmlLink($user->getHref(), $this->itemPhoto($user, 'thumb.icon'));
      ?>
    </div>
    <div class="group_discussions_thread_info">
      <div class="group_discussions_thread_details">
        <div class="group_discussions_thread_details_options">
          <?php if( $form ): ?>
            <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Quote'), array(
              'class' => 'buttonlink icon_group_post_quote',
              'onclick' => 'quotePost("'.$this->escape($user->getTitle()).'", "'.$this->escape($user->getHref()).'", "'.$this->string()->escapeJavascript(str_replace('&quot;', '&#92;&quot;', $post->body)).'");'
            )) ?>
          <?php endif; ?>
          <?php if( $post->user_id == $viewer->getIdentity() || $group->getOwner()->getIdentity() == $viewer->getIdentity() ): ?>
            <?php echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'post', 'action' => 'edit', 'post_id' => $post->getIdentity(), 'format' => 'smoothbox'), $this->translate('Edit'), array(
              'class' => 'buttonlink smoothbox icon_group_post_edit'
            )) ?>
            <?php echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'post', 'action' => 'delete', 'post_id' => $post->getIdentity(), 'format' => 'smoothbox'), $this->translate('Delete'), array(
              'class' => 'buttonlink smoothbox icon_group_post_delete'
            )) ?>
          <?php endif; ?>
        </div>
        <div class="group_discussions_thread_details_date">
          <?php echo $this->translate('Posted');?> <?php echo $this->timestamp(strtotime($post->creation_date)) ?>
        </div>
      </div>
      <div class="group_discussions_thread_body">
        <?php echo nl2br($this->BBCode($post->body)) ?>
      </div>
    </div>
  </li>
  <?php endforeach; ?>
</ul>


<?php if($paginators->getCurrentItemCount() > 4): ?>

  <?php echo $this->paginationControl(null, null, null, array(
    'params' => array(
      'post_id' => null // Remove post id
    )
  )) ?>
  <?php echo $placeholder ?>

<?php endif; ?>


<?php if($form ): ?>
  <a name="reply" />
  <?php echo $form->setAttrib('id', 'group_topic_reply')->render($this) ?>
<?php endif; ?>
</div>            
</div>