

<div class="generic_layout_container layout_left">
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

			</li>
			<li>
				<a href="/index.php/messages/inbox/"><span class="pt-icon-menu-left pt-icon-menu-02"></span><span class="pt-menu-text">Tin nhắn</span><span class="pt-number"><?php $viewer = Engine_Api::_()->user()->getViewer();$message_count = Engine_Api::_()->messages()->getUnreadMessageCount($viewer); if($message_count>0) echo $message_count; else echo '0';  ?></span></a>
			</li>
			<li>
				
			</li>
			<li>
				<a href="/index.php/community"><span class="pt-icon-menu-left pt-icon-menu-04"></span><span class="pt-menu-text">Album ảnh</span></a>
			</li>
			
		</ul>
        <div class="subcontent">
            <div class="featured-groups-wrapper">
            <h2>Featured Group</h2>
                 <?php 
                     $nav = $this->navigation()->menu()->setContainer($this->navigation)->render();
                     $pages = $this->paginator;  
                     $form= $this->formFilter;
                     $formValues= $this->formValues;
                     //echo $this->content()->renderWidget('group.featured');
                     echo $this->content()->renderWidget('group.featured');
                 ?>
            </div>
        </div>
    </div>
</div>

<div class="generic_layout_container layout_middle">    
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
			<a href="<?php echo $this->baseUrl(); ?>/groups/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New groups') ?></a>
		</div>
		
	</div>
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

    <div class="tabs_alt tabs_parent">
      <ul class="item" id="main_tabs">
                            <li class="tab_1 active"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Search') ?></a></li>
                            <li class="tab_2"><a onclick="tabContainerSwitch($(this))" href="javascript:void(0);"><?php echo $this->translate('Categories') ?></a></li>                             
          
      </ul>
    </div>

    <div class=" tab_2 current" style="display: none;">
        <?php echo $this->content()->renderWidget('group.categories'); ?>
    </div>
    <div class="tab_1 current" >
        <?php  echo $this->content()->renderWidget('group.search');?>
    </div>

   <div class="groups-list">
        <?php $i=1 ;?>
        <?php if( count($pages) > 0 ): ?>
        <ul class="groups_browse">
            <?php foreach( $pages as $group ): ?>
            <li <?php if($i==1) echo "class='first-group'"; $i++;?>>
                <div class="groups_photo">
                    <?php echo $this->htmlLink($group->getHref(), $this->itemPhoto($group, 'thumb.normal')) ?>
                </div>
                 <div class="groups_options">
                    <?php /*
                    <?php if( $this->viewer()->getIdentity() ): ?>
                        <?php if( $group->isOwner($this->viewer()) ): ?>
                            <?php echo $this->htmlLink(array('route' => 'group_specific', 'action' => 'edit', 'group_id' => $group->getIdentity()), $this->translate('Edit Group'), array(
                              'class' => 'buttonlink icon_group_edit'
                            )) ?>
                            <?php echo $this->htmlLink(array('route' => 'group_specific', 'action' => 'delete', 'group_id' => $group->getIdentity()), $this->translate('Delete Group'), array(
                              'class' => 'buttonlink REMsmoothbox icon_group_delete'
                            )) ?>
                          <?php elseif( !$group->membership()->isMember($this->viewer(), null) ): ?>
                            <?php echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'join', 'group_id' => $group->getIdentity()), $this->translate('Join Group'), array(
                              'class' => 'buttonlink smoothbox icon_group_join'
                            )) ?>
                          <?php elseif( $group->membership()->isMember($this->viewer(), true) ): ?>
                            <?php echo $this->htmlLink(array('route' => 'group_extended', 'controller' => 'member', 'action' => 'leave', 'group_id' => $group->getIdentity()), $this->translate('Leave Group'), array(
                              'class' => 'buttonlink smoothbox icon_group_leave'
                            )) ?>
                        <?php endif; ?>
                    <?php endif; ?>
                    */ ?>
                </div>
                <div class="groups_info" style="width:75%">
                    <div class="groups_title">
                        <h3><?php echo $this->htmlLink($group->getHref(), $group->getTitle()) ?></h3>
                    </div>
                    <div class="groups_members">
                        <?php  echo $this->translate(array('%s member in', '%s members in', $group['member_count']),$this->locale()->toNumber($group['member_count'])) ?> <a href="javascript:void(0);" onclick='categorySubmit("<?php echo $group->getCategory()->category_id; ?>");'><?php echo $group->getCategory()->title;?></a>
                    </div>
                    <div class="groups_desc"><?php echo $this->viewMore($group->getDescription()) ?></div>
                </div>
            </li>
           
            <?php endforeach; ?>
        </ul>
       
        <?php echo $this->paginationControl($pages, null, null, array(
          'query' => $formValues
        )); ?>
       
        <?php else: ?>
          <div class="tip">
            <span>
              <?php echo $this->translate('Tip: %1$sClick here%2$s to create the first group!', "<a href='".$this->url(array('action' => 'create'), 'group_general', true)."'>", '</a>'); ?>
            </span>
          </div>
        <?php endif; ?>
        
    </div>
    <div class="pt-content-event-right">
        <div class="pt-block" style="margin-top:20px">
            <?php echo $this->content()->renderWidget('event.upcoming-events'); ?>                                  
        </div>
    </div>
    
</div>




 
<script type="text/javascript">
var categorySubmit = function(category_id){
    //$('category_id').value = category_id;
    //$('group_search_form').submit();
}

</script>