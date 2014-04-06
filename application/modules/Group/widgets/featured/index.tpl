<?php
	$currenturl1=$_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
	//echo $currenturl1;
	$urlarray1=explode('/',$currenturl1);
	$here1= $urlarray1[2];
	if(($here1=='community') || ($here1=='group') || ($here1=='event')){ 
		?>
		<div class="wd-content-left">
				<div class="pt-boss">
					<?php
						//$user_id=$event->user_id;
						//$member2 = Engine_Api::_()->user()->getUser($user_id);
						echo $this->htmlLink(Engine_Api::_()->user()->getViewer()->getHref(), $this->itemPhoto(Engine_Api::_()->user()->getViewer(), 'thumb.icon'), array('class' => 'pt-avatar'));
						?>
					<div class="pt-how-info-boss">
						<h3><?php echo Engine_Api::_()->user()->getViewer(); ?></h3>
						<p><a href="<?php echo Engine_Api::_()->user()->getViewer()->getHref(); ?>"><?php echo $this->translate("Personal page") ?></a></p>
					</div>
				</div>
				<ul class="pt-menu-left">
					<li>
						<h3><?php echo $this->translate("Control panel") ?></h3>
					</li>
					<li>
						<a href="<?php echo $this->baseUrl() ?>/news" class="pt-active" ><span class="pt-icon-menu-left pt-icon-menu-01"></span><span class="pt-menu-text"><?php echo $this->translate("News") ?></span><span class="pt-number"><?php
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
						<a href="<?php echo $this->baseUrl() ?>/messages/inbox/"><span class="pt-icon-menu-left pt-icon-menu-02"></span><span class="pt-menu-text"><?php echo $this->translate("Message") ?></span><span class="pt-number"><?php $viewer = Engine_Api::_()->user()->getViewer();$message_count = Engine_Api::_()->messages()->getUnreadMessageCount($viewer); if($message_count>0) echo $message_count; else echo '0';  ?></span></a>
					</li>
					<li>
						<a href="<?php echo $this->baseUrl() ?>/events"><span class="pt-icon-menu-left pt-icon-menu-03"></span><span class="pt-menu-text"><?php echo $this->translate("Events") ?></span><span class="pt-number"><?php 
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
						<a href="<?php echo $this->baseUrl() ?>/community"><span class="pt-icon-menu-left pt-icon-menu-04"></span><span class="pt-menu-text"><?php echo $this->translate("Album") ?></span></a>
					</li>
					
				</ul>
			</div>
			<h3 style="color:#A4A9AE"><?php echo $this->translate("Groups") ?></h3>
<?php } ?>		

<div class="featured-groups">
<?php $n= count($this->group1); if($n): ?>
    <ul>
    <?php $dem = 0;  foreach($this->group1 as $item): $dem++;  ?>
    <?php  if((($dem-1) %8 == 0) && (($dem - 1) > 1)): ?>
    </ul>
    <ul>
    <?php endif; ?>
    	<li class="Tips1" title="<?php echo $item['title'];?>" rel="<?php echo $this->translate('Post by: ').$this->user($item['user_id'])->displayname. '<br />'.$this->translate('Last Update: ').date('F d, Y',strtotime($item['modified_date'])).'<br />'.$this->translate('Views: ').$item['view_count'] ?>" >
            <div style="width:20px;float:left;padding-left:8px">
				<?php if(!empty($item['img_url'])): ?>
                <img alt="Image" width="15" height="15" src="<?php echo $this->baseUrl() ?>/<?php echo $item['img_url']; ?>">
            <?php else: ?>
                <img alt="Image" width="15" height="15" src="<?php echo $this->baseUrl() ?>/application/modules/Group/externals/images/nophoto_group_thumb_normal.png">
            <?php endif; ?>
			</div>
			<div style="width:117px;float:left;padding-left:12px"><a href="<?php echo $this->baseUrl().'/group/'.$item['group_id']; ?>"><span class="pt-menu-text"><?php $text= $item['title'];
			$txt			=	$text;
			$qty=2;
		$arr_replace	=	array("<p>","</p>","<br>","<br />","  ");
		$text			=	str_replace($arr_replace,"",$text);
		$dem			=	0;
		for ( $i=0 ; $i < strlen($text) ; $i++ )
		{
			if ($text[$i] == ' ') $dem++;
			if ($dem == $qty)	break;
		}
		$text		=	substr($text,0,$i);
		if ($i	<	strlen($txt))
			$text .= " ...";
		echo	$text;
			?></span></a></div>
    	    <div style="width:15px;float:right;padding-left:0px; background-color: #BEC7CA;  transition: all 1s ease 0s;color:#fff;padding:0 3px;border-radius:5px; text-align: center;font-size:12px">
    	    <span ><?php  echo $this->locale()->toNumber($item['member_count']) ?></span></div>
    	    <div style="clear:both"></div>
    	</li>
    	
    <?php endforeach; ?>
    </ul>
<?php endif; ?>    
</div>
