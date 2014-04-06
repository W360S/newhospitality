<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: view.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<style type="text/css">
.global_form > div {
	padding: 9px 0px;
}

ul.event_discussions_thread{
	width: 742px;
}
</style>
<?php 
	$event= $this->event;
	$topic= $this->topic;
	$paginator= $this->paginator;
    $form= $this->form;
?>
<div class="content">
<div class="layout_right">
	<?php //echo $this->formFilter->setAttrib('class', 'filters')->render($this) ?>
    <div class="subsection">
        <h2>Featured events</h2>
        <div class="subcontent">
            <div class="featured-groups-wrapper">
                 <div class="featured-groups">
					<?php $n= count($this->eventFeture); if($n): ?>
					    <ul>
					    <?php $dem = 0;  foreach($this->eventFeture as $item): $dem++;  ?>
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
    						    <h3><a href="<?php echo $this->baseUrl().'/event/'.$item['event_id']; ?>"><?php echo $item['title'];?></a></h3>
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
  <?php echo $event->__toString()." ".$this->translate("&#187; Discussions") ?>
</h2>
</div>

<br />

<h3>
  <?php echo $topic->getTitle() ?>
</h3>

<?php $this->placeholder('eventtopicnavi')->captureStart(); ?>
<div class="event_discussions_thread_options">
  <?php echo $this->htmlLink(array('route' => 'event_extended', 'controller' => 'topic', 'action' => 'index', 'event_id' => $event->getIdentity()), $this->translate('Back to Topics'), array(
    'class' => 'buttonlink icon_back'
  )) ?>
  <?php if( $this->form ): ?>
    <?php echo $this->htmlLink($this->url(array()) . '#reply', $this->translate('Post Reply'), array(
      'class' => 'buttonlink icon_event_post_reply'
    )) ?>
  <?php endif; ?>
  <?php if( $this->can_edit): ?>
    <?php if( !$this->topic->sticky ): ?>
      <?php echo $this->htmlLink(array('action' => 'sticky', 'sticky' => '1', 'reset' => false), $this->translate('Make Sticky'), array(
        'class' => 'buttonlink icon_event_post_stick'
      )) ?>
    <?php else: ?>
      <?php echo $this->htmlLink(array('action' => 'sticky', 'sticky' => '0', 'reset' => false), $this->translate('Remove Sticky'), array(
        'class' => 'buttonlink icon_event_post_unstick'
      )) ?>
    <?php endif; ?>
    <?php if( !$this->topic->closed ): ?>
      <?php echo $this->htmlLink(array('action' => 'close', 'close' => '1', 'reset' => false), $this->translate('Close'), array(
        'class' => 'buttonlink icon_event_post_close'
      )) ?>
    <?php else: ?>
      <?php echo $this->htmlLink(array('action' => 'close', 'close' => '0', 'reset' => false), $this->translate('Open'), array(
        'class' => 'buttonlink icon_event_post_open'
      )) ?>
    <?php endif; ?>
    <?php echo $this->htmlLink(array('action' => 'rename', 'reset' => false), $this->translate('Rename'), array(
      'class' => 'buttonlink smoothbox icon_event_post_rename'
    )) ?>
    <?php echo $this->htmlLink(array('action' => 'delete', 'reset' => false), $this->translate('Delete'), array(
      'class' => 'buttonlink smoothbox icon_event_post_delete'
    )) ?>
  <?php elseif( !$this->can_edit): ?>
    <?php if( $this->topic->closed ): ?>
      <div class="event_discussions_thread_options_closed">
        <?php echo $this->translate('This topic has been closed.')?>
      </div>
    <?php endif; ?>
  <?php endif; ?>
</div>
<?php $this->placeholder('eventtopicnavi')->captureEnd(); ?>



<?php echo $this->placeholder('eventtopicnavi') ?>
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
<style>
.user_photo {clear:both;width:48px;display:block;text-align:center}
</style>
<ul class='event_discussions_thread'>
  <?php foreach( $paginator as $post ): ?>
  <li>
    <div class="event_discussions_thread_photo">
      <?php
        $user = $this->item('user', $post->user_id);
        echo $this->htmlLink($user->getHref(), $user->getTitle(),array('class'=>'user_photo'));
        echo $this->htmlLink($user->getHref(), $this->itemPhoto($user, 'thumb.icon'));
      ?>
    </div>
    <div class="event_discussions_thread_info">
      <div class="event_discussions_thread_details">
        <div class="event_discussions_thread_details_options">
          <?php if( $this->form ): ?>
            <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Quote'), array(
              'class' => 'buttonlink icon_event_post_quote',
              'onclick' => 'quotePost("'.$this->escape($user->getTitle()).'", "'.$this->escape($user->getHref()).'", "'.$this->string()->escapeJavascript(str_replace('&quot;', '&#92;&quot;', $post->body)).'");'
            )) ?>
          <?php endif; ?>
          <?php if( $post->user_id == $this->viewer()->getIdentity() || $event->getOwner()->getIdentity() == $this->viewer()->getIdentity() ): ?>
            <?php echo $this->htmlLink(array('route' => 'event_extended', 'controller' => 'post', 'action' => 'edit', 'post_id' => $post->getIdentity(), 'format' => 'smoothbox'), $this->translate('Edit'), array(
              'class' => 'buttonlink smoothbox icon_event_post_edit'
            )) ?>
            <?php echo $this->htmlLink(array('route' => 'event_extended', 'controller' => 'post', 'action' => 'delete', 'post_id' => $post->getIdentity(), 'format' => 'smoothbox'), $this->translate('Delete'), array(
              'class' => 'buttonlink smoothbox icon_event_post_delete'
            )) ?>
          <?php endif; ?>
        </div>
        <div class="event_discussions_thread_details_date">
          <?php echo $this->timestamp(strtotime($post->creation_date)) ?>
        </div>
      </div>
      <div class="event_discussions_thread_body">
        <?php echo nl2br($this->BBCode($post->body)) ?>
      </div>
    </div>
  </li>
  <?php endforeach; ?>
</ul>


<?php if($paginator->getCurrentItemCount() > 4): ?>

  <?php echo $this->paginationControl(null, null, null, array(
    'params' => array(
      'post_id' => null // Remove post id
    )
  )) ?>
  <?php echo $this->placeholder('eventtopicnavi') ?>

<?php endif; ?>


<?php if( $form ): ?>
  <a name="reply" ></a>
  <?php echo $form->setAttrib('id', 'event_topic_reply')->render($this) ?>
<?php endif; ?>
</div>
</div>