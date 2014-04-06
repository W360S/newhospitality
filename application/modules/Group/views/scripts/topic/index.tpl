<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7244 2010-09-01 01:49:53Z john $
 * @author	   John
 */
?>
<style type="text/css">
.group_discussions_options{
	margin:6px 0px;
	border:none;
	background-color: #fff;
}
ul.group_discussions{
	-moz-border-radius:3px 3px 3px 3px;
	border: 1px solid #D0E2EC;
	padding: 10px;
}
ul.group_discussions > li{
	border-bottom: 1px solid #EAEAEA;
}

</style>
<?php 
	$group= $this->group;
	$can_post= $this->can_post;
	$paginator= $this->paginator;
?>
<div class="content"> 
<?php echo $this->content()->renderWidget('group.profile-featured'); ?> 
<div class="layout_middle">
<div class="headline">
<h2>
  <?php echo $group->__toString() ?>
  <?php echo $this->translate('&#187; Discussions');?>
</h2>
</div>
<div class="group_discussions_options">
  <?php echo $this->htmlLink(array('route' => 'group_profile', 'id' => $group->getIdentity()), $this->translate('Back to Group'), array(
    'class' => 'buttonlink icon_back'
  )) ?>
  <?php 
    if ($can_post) 
    {
      echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'topic', 'action' => 'create', 'subject' => $group->getGuid()), $this->translate('Post New Topic'), array(
    'class' => 'buttonlink icon_group_post_new'
  )) ;
  }
?>
</div>

<?php if( $paginator->count() > 1 ): ?>
  <div>
    <br />
    <?php echo $this->paginationControl($paginator) ?>
    <br />
  </div>
<?php endif; ?>

<ul class="group_discussions">
  <?php foreach( $paginator as $topic ):
      $lastpost = $topic->getLastPost();
      $lastposter = $topic->getLastPoster();
      ?>
    <li>
      <div class="group_discussions_replies">
        <span>
          <?php echo $this->locale()->toNumber($topic->post_count - 1) ?>
        </span>
        <?php echo $this->translate(array('reply', 'replies', $topic->post_count - 1)) ?>
      </div>
      <div class="group_discussions_lastreply">
        <?php echo $this->htmlLink($lastposter->getHref(), $this->itemPhoto($lastposter, 'thumb.icon')) ?>
        <div class="group_discussions_lastreply_info">
          <?php echo $this->htmlLink($lastpost->getHref(), $this->translate('Last Post')) ?> <?php echo $this->translate('by');?> <?php echo $lastposter->__toString() ?>
          <br />
          <?php echo $this->timestamp(strtotime($topic->modified_date), array('tag' => 'div', 'class' => 'group_discussions_lastreply_info_date')) ?>
        </div>
      </div>
      <div class="group_discussions_info">
        <h3<?php if( $topic->sticky ): ?> class='group_discussions_sticky'<?php endif; ?>>
          <?php echo $this->htmlLink($topic->getHref(), $topic->getTitle()) ?>
        </h3>
        <div class="group_discussions_blurb">
          <?php echo $this->viewMore(strip_tags($topic->getDescription())) ?>
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