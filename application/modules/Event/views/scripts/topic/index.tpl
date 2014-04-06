<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<style type="text/css">
.event_discussions_options {
	background-color: #fff;
	border: none;
}
ul.event_discussions{
	-moz-border-radius:3px 3px 3px 3px;
	border: 1px solid #D0E2EC;
	padding:0 10px;
}
ul.event_discussions >li{
	border-top: 1px solid #EAEAEA;
}
</style>
<?php 
	$event= $this->event;
	$paginator= $this->paginator;
    $can_post= $this->can_post;
?>
<div class="content">
<?php echo $this->content()->renderWidget('event.profile-featured');?>
<div class="layout_middle">
<div class="headline">
<h2>
  <?php echo $event->__toString()." ".$this->translate("&#187; Discussions") ?>
</h2>

</div>

<div class="event_discussions_options">
  <?php echo $this->htmlLink(array('route' => 'event_profile', 'id' => $event->getIdentity()), $this->translate('Back to Event'), array(
    'class' => 'buttonlink icon_back'
  )) ?>
  <?php if ($can_post) { echo $this->htmlLink(array('route' => 'event_extended', 'controller' => 'topic', 'action' => 'create', 'subject' => $event->getGuid()), $this->translate('Post New Topic'), array(
    'class' => 'buttonlink icon_event_post_new'
  )); }?>
</div>

<?php if( $paginator->count() > 1 ): ?>
  <div>
    <br />
    <?php echo $this->paginationControl($paginator) ?>
    <br />
  </div>
<?php endif; ?>

<ul class="event_discussions">
<?php 
	$i=1;
?>
  <?php foreach( $paginator as $topic ):
      $lastpost = $topic->getLastPost();
      $lastposter = $topic->getLastPoster();
      ?>
	<li <?php if($i == 1)	echo 'class="last_li"'?>>
        	<?php $i++;?>
      <div class="event_discussions_replies">
        <span>
          <?php echo $this->locale()->toNumber($topic->post_count - 1) ?>
        </span>
        <?php echo $this->translate(array('reply', 'replies', $topic->post_count - 1)) ?>
      </div>
      <div class="event_discussions_lastreply">
        <?php echo $this->htmlLink($lastposter->getHref(), $this->itemPhoto($lastposter, 'thumb.icon')) ?>
        <div class="event_discussions_lastreply_info">
          <?php echo $this->htmlLink($lastpost->getHref(), $this->translate('Last Post')) ?> by <?php echo $lastposter->__toString() ?>
          <br />
          <?php echo $this->timestamp(strtotime($topic->modified_date), array('tag' => 'div', 'class' => 'event_discussions_lastreply_info_date')) ?>
        </div>
      </div>
      <div class="event_discussions_info">
        <h3<?php if( $topic->sticky ): ?> class='event_discussions_sticky'<?php endif; ?>>
          <?php echo $this->htmlLink($topic->getHref(), $topic->getTitle()) ?>
        </h3>
        <div class="event_discussions_blurb">
          <?php echo $this->viewMore($topic->getDescriptionTopic()) ?>
        </div>
      </div>
    </li>
  <?php endforeach; ?>
</ul>

<?php if( $paginator->count() > 1 ): ?>
  <div>
    <?php echo $this->paginationControl($paginator) ?>
  </div>
<?php endif; ?>
</div>
</div>