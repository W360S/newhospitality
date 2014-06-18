<h3 class="pt-title-right"><?php echo "Chuyên gia tích cực"; ?></h3>
<?php if(count($this->list_experts)): ?>
	  <ul class="pt-list-right pt-list-right-fix">
	   <?php foreach($this->list_experts as $item): ?>
            <li>

		<div class="pt-user-post">
			<a href="#"><span class="pt-avatar">
			<?php if($item->photo_id): ?>
                        <?php echo $this->itemPhoto($item, 'thumb.normal', "Image"); ?>
                    <?php else: ?>
                         <img alt="Image" src="<?php echo $this->baseUrl(); ?>">
                    <?php endif; ?>
			
			</span></a>
			<div class="pt-how-info-user-post">
				<h3><a href="<?php echo $this->baseUrl("/") . "profile/" . $item->username; ?>"><?php echo $item->displayname; ?></a></h3>
				<!--<p><?php //echo $item->company; ?></p>-->
				<a href="<?php echo $this->url(array('controller'=>'my-questions','action'=>'index','user_id'=>$item->user_id,'view_user'=>$item->displayname)); ?>"><?php  echo $this->translate(array('%s Answer', '%s Answers', intval($item->answered)), intval($item->answered)) ?></a>
			</div>
		</div>
		
	    </li>
	<?php endforeach; ?> 
	</ul>
 <?php else: ?>
    <div class="not-found-expert"><p><?php echo $this->translate("Haven't found any experts."); ?></p></div>
  <?php endif; ?>