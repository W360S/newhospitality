<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: manage.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<style type="text/css">
.subcontent .filter .select_sort {
	font-weight:bold;
	padding-left:12px;
}
.events_browse li.last_li{border-top:none;}
ul.paginationControl li {
    border-top-width:0px !important; 
}
</style>
<?php 
 
 $pages = $this->paginator;  
 $form= $this->formFilter;
 $view= $this->view;
 $text= $this->text;
 $category_id= $this->category_id;
 $formValues= $this->formValues;
?>
<div class="content"> 
<div class="layout_right" style="float:left;width:19%">
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
			</div>
		<div class="featured-groups" >
            <h2><?php echo $this->translate('Featured Group'); ?></h2>
            <div class="featured-groups-wrapper">
                <?php //echo $this->content()->renderWidget('event.feature'); ?>
                <?php  echo $this->content()->renderWidget('group.featured');?>
            </div>			   
        </div>
    <!--
    <div class="subsection">
        <?php //echo $this->content()->renderWidget('event.ad'); ?>
    </div>
    -->
</div>
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
		<div >
			<script type="text/javascript">
			  var tabContainerSwitch = function(element) {
			    if( element.tagName.toLowerCase() == 'a' ) {
			      element = element.getParent('li');
			    }
			    var myContainer = element.getParent('.tabs_parent').getParent();
			    myContainer.getChildren('div:not(.tabs_alt)').setStyle('display', 'none');
			    myContainer.getElements('ul; li').removeClass('active');
			    element.get('class').split(' ').each(function(className){
			      className = className.trim();
			      if( className.match(/^tab_[0-9]+$/) ) {
			        myContainer.getChildren('div.' + className).setStyle('display', null);
			        element.addClass('active');
			        
			       
			        //alert(jQuery('#main_tabs').find("li.more_tab").attr('class').split(' '));
			        var st= $$('.tab_pulldown_contents_wrapper').getParent();
			        st.removeClass('tab_open');
			        //alert(st);
			      }
			    });
			    
			    //jQuery('#main_tabs').find("li.more_tab").removeClass("tab_open").addClass("tab_closed");
			  }
			  
			</script>
			<style>
			.tab_1{
				 background: none repeat scroll 0 0 #FFFFFF;
			    border-color: #CCCCCC #CCCCCC -moz-use-text-color;
			    border-style: solid solid none;
			    border-width: 1px 1px medium;
			    color: #000000;
			    padding: 11px;
			    font-size:14px;
			    text-transform: uppercase;
			}
			.tab_1.active{
				 background: none repeat scroll 0 0 #4FC1E9;
			    border: 1px solid #4FC1E9;
			    color: #FFFFFF;
			    padding: 11px;
			}
			.tab_2{
				 background: none repeat scroll 0 0 #FFFFFF;
			    border-color: #CCCCCC #CCCCCC -moz-use-text-color;
			    border-style: solid solid none;
			    border-width: 1px 1px medium;
			    color: #000000;
			    padding: 11px;
			    font-size:14px;
			      text-transform: uppercase;
			}
			.tab_2.active{
				 background: none repeat scroll 0 0 #4FC1E9;
			    border: 1px solid #4FC1E9;
			    color: #FFFFFF;
			    padding: 11px;
			}
			
			.tab_1.active > a {    
			    border:none;
			    color: #fff;
			    outline: medium none;
			    padding: 5px 7px;
			    text-decoration: none;
			}
			.tab_2.active > a { 
				border:none;
			    color: #fff;
			    outline: medium none;
			    padding: 5px 7px;
			    text-decoration: none;
			}
			.tab_1 > a {    
			    border:none;
			    border-style: none;
			}
			.tab_2 > a { 
				border:none;
			    border-style: none;
			}
			.tabs_alt > ul > li > a{
				border-style: none;
			}
			.tabs_alt > ul > li > a:hover{
				border-style: none;
			}
			.tab_2.current{
				 background: none repeat scroll 0 0 #4FC1E9;
			    margin-top:-6px;
			    color: #FFFFFF;
			    padding: 30px 21px;
			    font-size:12px;
			    text-transform: none;
			}
			.tab_1.current{
				 background: none repeat scroll 0 0 #4FC1E9;
			    margin-top:-6px;
			    color: #FFFFFF;
			    padding: 30px 21px;
			    font-size:12px;
			    text-transform: none;
			}
			
			ul.list_category li a {
			    color: #FFFFFF;
			    line-height: 17px;
			}
			
			.subcontent .filter .select_sort {
			    color: #FFFFFF;
			    float: right;
			}
			.filter .input input {
			    padding: 2px;
			    width: 114px;
			}
			input, select {
			    padding: 9px 4%;
			}
			.pt-content-searching ul li .wd-adap-select {
			    margin: 0;
			    width: 100%;
			}
			.button:hover{
				background:#48CFAD;
			}
			ul.events_browse .events_info {
    overflow: hidden;
    padding-left: 10px;
    width: 78%;
}
			</style>
			<div class="tabs_alt tabs_parent">
			  <ul class="item" id="main_tabs">
			                        <li class="tab_1 active"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Search') ?></a></li>
			                        <li class="tab_2"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Categories') ?></a></li>                             
			      
			  </ul>
			</div>
			
			<div class=" tab_2 current" style="display: none;">
			<?php echo $this->content()->renderWidget('event.my-categories'); ?>
			</div>
			<div class="tab_1 current" >
			<?php  echo $this->content()->renderWidget('event.search-my-events');?>
			</div>
		</div>
		
		<?php 
			//$liclass = 'last_li';
			$i=1;
		?>
		<?php if( count($pages) > 0 ): ?>
		    <ul class='events_browse'>
		      <?php if( $pages->count() > 1 ): ?>
		          <?php echo $this->paginationControl($pages, null, null, array(
		            'query' => $formValues
		          )); ?>
		      <?php endif; ?>  
		    
		      <?php foreach( $pages as $event ): ?>
		        <li <?php if($i == 1)	echo 'class="last_li"'?>>
		          <div class="events_photo">
		             <?php if($event->photo_id): ?>
		                <?php echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.normal')) ?>
		            <?php else: ?>
		                <a href="<?php echo $event->getHref(); ?>"><img src="<?php echo $this->baseUrl(); ?>/application/modules/Event/externals/images/nophoto_event_thumb_normal.png"></a>
		            <?php endif; ?>          
		            
		          </div>
		          <div class="events_options">
		            <?php if( $this->viewer() && $event->isOwner($this->viewer()) ): ?>
		              <?php echo $this->htmlLink(array('route' => 'event_specific', 'action' => 'edit', 'controller'=>'event', 'event_id' => $event->getIdentity()), $this->translate('Edit Event'), array(
		                'class' => 'buttonlink icon_event_edit'
		              )) ?>
		            <?php endif; ?>
		            <?php if( $this->viewer() && !$event->membership()->isMember($this->viewer(), null) ): ?>
		              <?php echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'join', 'event_id' => $event->getIdentity()), $this->translate('Join Event'), array(
		                'class' => 'buttonlink smoothbox icon_event_join'
		              )) ?>
		              <?php elseif( $this->viewer() && $event->isOwner($this->viewer()) ): ?>
		                <?php echo $this->htmlLink(array('route' => 'event_specific', 'action' => 'delete', 'event_id' => $event->getIdentity()), $this->translate('Delete Event'), array(
		                  'class' => 'buttonlink REMsmoothbox icon_event_delete'
		                )) ?>
		            <?php elseif( $this->viewer() && $event->membership()->isMember($this->viewer()) ): ?>
		              <?php echo $this->htmlLink(array('route' => 'event_extended', 'controller'=>'member', 'action' => 'leave', 'event_id' => $event->getIdentity()), $this->translate('Leave Event'), array(
		                'class' => 'buttonlink smoothbox icon_event_leave'
		              )) ?>
		            <?php endif; ?>
		          </div>
		          <div class="events_info">
		            <div class="events_title">
		              <h3><?php echo $this->htmlLink($event->getHref(), $event->getTitle()) ?></h3>
		            </div>            	    	    
		            <div class="events_members">
		              <?php echo $this->translate(array('%s member', '%s members', $event->membership()->getMemberCount()),$this->locale()->toNumber($event->membership()->getMemberCount())) ?>
		              <?php echo $this->translate('led by');?> <?php echo $this->htmlLink($event->getOwner()->getHref(), $event->getOwner()->getTitle()) ?>
		            </div>
		            <div class="events_desc">
		              <?php echo $this->viewMore($event->getDescription()) ?>
		            </div>
		          </div>          
		        </li>
		        <?php $i++;?>
		      <?php endforeach; ?>
		      
		      <?php if( $pages->count() > 1 ): ?>
		          <?php echo $this->paginationControl($pages, null, null, array(
		            'query' => $formValues
		          )); ?>
		      <?php endif; ?>
		    </ul>
		
		<?php else: ?>
		  <div class="tip">
		    <span>
		       <?php echo $this->translate('Tip: %1$sClick here%2$s to create a event or %3$sbrowse%2$s for events to join!', "<a href='".$this->url(array('action' => 'create'), 'event_general', true)."'>", '</a>', "<a href='".$this->url(array(), 'event_upcoming', true)."'>"); ?>
		    </span>
		  </div>
		<?php endif; ?>
</div>

</div> 
</div>