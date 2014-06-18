<?php
    $data = $this->data;
    $categories = $this->categories;
?>
<div class="section">
    <div class="layout_right">
        <?php
               echo $this->content()->renderWidget('experts.my-accounts'); 
        ?>
        
        <div class="subsection">
            <?php
               echo $this->content()->renderWidget('experts.featured-experts'); 
            ?>
        </div>
        <div class="subsection">
            <?php echo $this->content()->renderWidget('group.ad'); ?>
        </div>
    </div>
    <div class="layout_middle">
       <div >
			<div class="search_my_question">
				<?php echo $this->content()->renderWidget('experts.search'); ?>
            </div>
            <?php if(!empty($data)): ?>
			<div class="subsection">
				    <h2><?php echo $this->translate('Experts ').$data->displayname; ?></h2>
                    <div class="container_profile">
						<div class="infor_profile">
							<div class="frame_img">
                                <a alt='profile user' href="<?php echo $this->baseUrl("/")."profile/".$data->username; ?>">
								<?php if($data->photo_id): ?>
                                    <?php echo $this->itemPhoto($data, 'thumb.normal', "Image"); ?>
                                <?php else: ?>
                                    <img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_icon.png">
                                <?php endif; ?>
                                </a>
                            </div>
                            
							<div class="information">
                                <?php $cnt = count($categories);  if($cnt): ?>
                                <p><?php echo $this->translate("Category"); ?>: 
                                <?php $inc = 1; foreach($categories as $item): ?>
                                <?php if($inc < $cnt): ?>
								<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'category', 'category_id'=>$item->category_id),'default',true); ?>"><?php echo $item->category_name; ?></a> <span>-</span>
                                <?php else: ?>
                                <a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'category', 'category_id'=>$item->category_id),'default',true); ?>"><?php echo $item->category_name; ?></a>
                                <?php endif; ?>
                                <?php $inc = $inc + 1; endforeach; ?>
                                </p>
                                <?php endif ?>
								<p><?php echo $this->translate("Full name"); ?>: <strong><?php echo $data->displayname; ?></strong></p>
								<p><?php echo $this->translate("Company"); ?>: <?php echo $data->company; ?></p>
								<p><?php echo $this->translate("Join date"); ?>: <?php echo date("Y-m-d",strtotime($data->created_date)); ?></p>
								<!-- <a class="bt_cancel" href="#">share</a> -->
							</div>
						</div>
						<div class="intro_profile">
							<?php echo $data->description; ?>	
						</div>
                    </div>    
            </div>
            <?php else: ?>
            <div class="subsection">
                <?php echo $this->translate("Invalid id experts"); ?>
            </div>
            <?php endif; ?>
            <?php
               echo $this->content()->renderWidget('experts.answered-by-experts'); 
            ?>
        </div>
        <div class="block_content">
            <div class="subsection">
				<?php echo $this->content()->renderWidget('experts.top-views'); ?>
            </div>
        </div>
        <div class="block_content top_rating">
            <div class="subsection">
				<?php echo $this->content()->renderWidget('experts.top-rating'); ?>
            </div>
        </div>
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>