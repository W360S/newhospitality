<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: create.tpl 7244 2010-09-01 01:49:53Z john $
 * @author	   John
 */
?>

<!--[if IE 7]>
<style>
	.form-elements .form-wrapper{
		padding-bottom: 10px;
	}
	button{
		line-height:15px;
		width:120px;
	}
</style>
<![endif]-->
	
<style type="text/css">
	.wd-content-content-sprite{
		float: left;
		width: 75%;
	}
</style>

<div class="content">
<div class="layout_right">
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
						<?php /*
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
						*/ ?>
					</li>
					<li>
						<a href="/index.php/messages/inbox/"><span class="pt-icon-menu-left pt-icon-menu-02"></span><span class="pt-menu-text">Tin nhắn</span><span class="pt-number"><?php $viewer = Engine_Api::_()->user()->getViewer();$message_count = Engine_Api::_()->messages()->getUnreadMessageCount($viewer); if($message_count>0) echo $message_count; else echo '0';  ?></span></a>
					</li>
					<li>
						<?php /*
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
						*/ ?>
					</li>
					<li>
						<a href="/index.php/community"><span class="pt-icon-menu-left pt-icon-menu-04"></span><span class="pt-menu-text">Album ảnh</span></a>
					</li>
					
				</ul>
        <div class="subcontent">
            <div class="featured-groups-wrapper">
                 <?php 
                 $nav = $this->navigation;
                 $nav1 = $this->navigation();
                 //$pages = $this->paginator;
                 $form= $this->form;
				  echo $this->content()->renderWidget('group.featured'); 
                 //echo $this->content()->renderWidget('group.featured'); ?>
            </div>
        </div>
    </div>
    <!--
    <div class="subsection">
        <?php //echo $this->content()->renderWidget('group.ad'); ?>
    </div>
    -->
</div>
	<div class="wd-content-content-sprite">
		<div class="wd-content-event">
		  <div class="pt-title-event">
								<ul class="pt-menu-event">
									<li class="active">
										<a href="<?php echo $this->baseUrl(); ?>/groups"><?php echo $this->translate('All groups') ?></a>
									</li>									
									<li>
										<a href="<?php echo $this->baseUrl(); ?>/groups/manage"><?php echo $this->translate('My groups') ?></a>
									</li>
								</ul>
								<a href="<?php echo $this->baseUrl(); ?>/groups/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New group') ?></a>
		</div>
		<?php echo $form->render($this) ?>
		</div>
	</div>
</div>