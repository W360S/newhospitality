<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: create.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<style type="text/css">
.global_form > div {
	padding: 0 0 9px 0px;
}
#event_create_form .form-wrapper{
	*padding-top: 5px;
}
#event_create_form button{
	*padding:3px 0px;
}
table#description_tbl{
    width: 443px !important;
} 
</style>
<?php
$this->headScript()
  ->appendFile($this->baseUrl() . '/externals/calendar/calendar.compat.js');
$this->headLink()
  ->appendStylesheet($this->baseUrl() . '/externals/calendar/styles.css');
?>

<div class="content">
<div class="layout_right" style="float:left;width:19%">
	<?php //echo $this->formFilter->setAttrib('class', 'filters')->render($this) ?>
    <div class="wd-content-left">
        <div class="pt-boss">
					<?php
						//$user_id=$event->user_id;
						//$member2 = Engine_Api::_()->user()->getUser($user_id);
						echo $this->htmlLink(Engine_Api::_()->user()->getViewer()->getHref(), $this->itemPhoto(Engine_Api::_()->user()->getViewer(), 'thumb.icon'), array('class' => 'pt-avatar'));
						?>
					<div class="pt-how-info-boss">
						<h3><?php echo Engine_Api::_()->user()->getViewer(); ?></h3>
						<p><a href="<?php echo Engine_Api::_()->user()->getViewer()->getHref(); ?>">Trang cá nhân</a></p>
					</div>
				</div>
				<ul class="pt-menu-left">
					<li>
						<h3>Bảng điều khiển</h3>
					</li>
					<li>
						<a href="/index.php/news" class="pt-active" ><span class="pt-icon-menu-left pt-icon-menu-01"></span><span class="pt-menu-text">Bảng tin</span><span class="pt-number"><?php
							$table = Engine_Api::_()->getItemTable('news_new');
	//Zend_Debug::dump($table->info('name'), 'table');exit();
	//$groupTable = Engine_Api::_()->getDbtable('news', 'news');
	
	$select = $table->select()
		  ->from($table)
		  ->order('created DESC')
		  ->limit(24);
    $result = $table->fetchAll($select);
    //Zend_Debug::dump($result);exit(); 
    if(count($result)) echo count($result); else echo '0';
						?></span></a>
					</li>
					<li>
						<a href="/index.php/messages/inbox/"><span class="pt-icon-menu-left pt-icon-menu-02"></span><span class="pt-menu-text">Tin nhắn</span><span class="pt-number"><?php $viewer = Engine_Api::_()->user()->getViewer();$message_count = Engine_Api::_()->messages()->getUnreadMessageCount($viewer); if($message_count>0) echo $message_count; else echo '0';  ?></span></a>
					</li>
					<li>
						<a href="/index.php/events"><span class="pt-icon-menu-left pt-icon-menu-03"></span><span class="pt-menu-text">Sự kiện</span><span class="pt-number"><?php 
						$table = Engine_Api::_()->getItemTable('event');
        //Zend_Debug::dump($table->info('name'), 'table');exit();
        $groupTable = Engine_Api::_()->getDbtable('events', 'event');
        $eventTableName = $groupTable->info('name');
        
        $select = $groupTable->select()
                ->from($groupTable->info('name'))
                ->where("`{$eventTableName}`.`endtime` > FROM_UNIXTIME(?)", time())
                // ->where("`{$eventTableName}`.`starttime` < FROM_UNIXTIME(?)", time() + (86400 * 14))
                ->order("endtime DESC")
                ->order("pinned DESC")
                ->limit(1000);
		//echo $select;
        $result = $select->query()->fetchAll();
        echo count($result);
						?></span></a>
					</li>
					<li>
						<a href="/index.php/community"><span class="pt-icon-menu-left pt-icon-menu-04"></span><span class="pt-menu-text">Album ảnh</span></a>
					</li>
					
				</ul>
		<div class="featured-groups" >
            <h2><?php //echo $this->translate('Featured Group'); ?></h2>
            <div class="featured-groups-wrapper">
                <?php  //echo $this->content()->renderWidget('group.featured');?>
            </div>			   
        </div>
        <div class="subcontent">
            <div class="featured-groups-wrapper">
                 <?php 
                 
                 $nav = $this->navigation;
                 $nav1 = $this->navigation();
                 $pages = $this->paginator;  
                 $form= $this->form;
                 echo $this->content()->renderWidget('group.featured'); ?>
            </div>
        </div>
    </div>
    <!--
    <div class="subsection">
        <?php //echo $this->content()->renderWidget('event.ad'); ?>
    </div>
    -->
</div>
<style>
	.global_form > div {
    padding: 0 0 9px !important;
    width: 100%;
}
.global_form > div > div {
    background: none repeat scroll 0 0 #FFFFFF;
    padding: 12px;
    width: 100%;
    border:none;
}
</style>
<div class="wd-content-content-sprite"> 
<div class="wd-content-event">
  <div class="pt-title-event">
						<ul class="pt-menu-event">
							<li class="active">
								<a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX; ?>/events"><?php echo $this->translate('Upcoming Events') ?></a>
							</li>
							<li>
								<a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX; ?>/events/past"><?php echo $this->translate('Past Events') ?></a>
							</li>
							<li>
								<a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX; ?>/events/manage"><?php echo $this->translate('My Events') ?></a>
							</li>
						</ul>
						<a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX; ?>/events/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New Event') ?></a>
</div>
<?php
echo $form->render();?>
</div>


</div>
</div>