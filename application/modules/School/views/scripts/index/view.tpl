<style type="text/css">
#global_wrapper {background:none;}
#content{padding: 20px 0;}
#breadcrumb {
    padding-top: 20px;
    padding-bottom: 0px;
}
#global_content .layout_middle {
    padding-right: 0px;
}
</style>
<?php
$school= $this->school;
$comments= $this->comments;
$other_new_articals= $this->other_new_articals;
$viewer_id= $this->viewer_id;
$intro= str_replace("\n", "<br />", $school->intro);
?>
<div id="banner-school">
    <div class="section">
        <?php echo $this->content()->renderWidget('school.banner');?>
    </div>
</div>
<div id="breadcrumb">
        <div class="section">
            <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate('Home');?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/school'?>"><?php echo $this->translate('Education School');?></a> <span>&gt;</span> <strong><?php echo $school->name;?></strong>
        </div>
    </div>
<div id="content">
    <div class="section school-detail">
        <div class="layout_left">
            <?php echo $this->content()->renderWidget('school.lastest-article');?>
            <?php echo $this->content()->renderWidget('school.advertising');?>
        </div>
        
        <div class="layout_middle">
            <div class="subsection">
            	<h2><?php echo $school->name;?></h2>
                <div class="detail-article">
						<div class="school-address">
							<?php echo $this->itemPhoto($school, 'thumb.normal', "Image", array('class'=>'img-school'));?>
							<ul>
								<li><label><?php echo $this->translate('Address: ');?></label><?php echo $school->address;?></li>
								<li><label><?php echo $this->translate('Country: ');?></label><?php echo $this->country($school->country_id)->name;?></li>
								<li><label><?php echo $this->translate('Phone: ');?></label><?php echo $school->phone;?></li>
								<li><p><a class="share smoothbox" href="<?php echo $this->baseUrl() ?>/activity/index/share/type/school_school/id/<?php echo $school->school_id ?>/format/smoothbox"><?php echo $this->translate('Share');?></a></p></li>
							</ul>
						</div>
						<div class="school-contact">
							<ul>
								<li><span><?php echo $this->translate('Website: ');?></span><span class="web-link"><?php echo $school->website;?></span></li>
								<li><span><?php echo $this->translate('Email: ');?></span><?php echo $school->email;?></li>								
							</ul>
                            <?php if(!empty($viewer_id)){?>
							<div class="buttom"><a class="bt-post-article" href="<?php echo $this->baseUrl().'/school/article/create/id/'.$school->school_id;?>"><?php echo $this->translate('Post an Article');?></a></div>
                            <?php } ?>
						</div>
						<p><?php echo $intro;?></p>
                        <br />
                        <!-- AddThis Button BEGIN -->
                		<div class="addthis_toolbox addthis_default_style ">
                		<a class="addthis_button_preferred_1"></a>
                		<a class="addthis_button_preferred_2"></a>
                		<a class="addthis_button_preferred_3"></a>
                		
                		<a class="addthis_button_compact"></a>
                		<a class="addthis_counter addthis_bubble_style"></a>
                		</div>
                		<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=huynhnv"></script>
                		<!-- AddThis Button END -->
                </div>
                	<div class="article-school">
						<div class="sub-section article-right">
						<?php if(count($comments)>0):?>
							<div class="title"><h3><?php echo $this->translate('Comments');?></h3></div>
						<?php endif;?>
							<div class="sub-content">
								<ul class="list_comment">
                                <?php
                                    if(count($comments)>0){
                                        $arr= array();
                                        foreach($comments as $item){
                                            
                                            if(!in_array($item->artical_id, $arr)){ ?>
                                                <li>
                                                    <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
                                        			<h4><?php echo $this->htmlLink(array('route' => 'view-school-artical', 'id'=> $item->artical_id, 'slug'=>$slug), $item->title) ?>
                        	                        </h4>
                                        			<a><?php echo $this->itemPhoto($this->user($item->owner_id), 'thumb.icon');?></a>
                                        			<p><?php echo substr(strip_tags($item->body), 0, 350); if (strlen($item->body)>349) echo "...";?></p>
                                        		</li>
                                        <?php }
                                            $arr[]= $item->artical_id;
                                        }
                                    } 
                                ?>
								</ul>
							</div>
						</div>
						<div class="sub-section article-middle">
						<?php if(count($other_new_articals)):?>
							<div class="title">
								<h3><?php echo $this->translate('Articles of school');?></h3>
								<p class="view-all"><?php echo $this->htmlLink(array('route' => 'view-all-article', 'id'=> $school->school_id), $this->translate('View all')) ?></p>
							</div>
							<?php endif;?>
							<div class="sub-content">
								<ul class="list_articel_school">
                                <?php 
                                if(count($other_new_articals)){
                            
                                    foreach($other_new_articals as $item){    
                                ?>
									<li>
                                    <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
										<?php echo $this->htmlLink(array('route' => 'view-school-artical', 'id'=> $item->artical_id, 'slug'=>$slug), $item->title) ?>									
										<p class="rating">
                                            <span class="post-by"><?php echo $this->translate('Posted by:');?></span> 
                                            <?php echo $this->user($item->user_id);?>
                                            <span class="bd_list">|</span>
                                            <?php 
                                              	$rating= $item->rating;
                                              	if($rating>0){
                                              		for($x=1; $x<=$rating; $x++){?>
                                              			<span class="rating_star_generic rating_star"></span>
                                              		<?php }
                                              		
                                              		
                                              		$remainder = round($rating)-$rating;  			
                                              		if(($remainder<=0.5 && $remainder!=0)):?><span class="rating_star_generic rating_star_half"></span><?php endif;
                                              		if(($rating<=4)){
                                              			for($i=round($rating)+1; $i<=5; $i++){?>
                                    					<span class="rating_star_generic rating_star_disabled"></span> 	
                                    			<?php }
                                              		}
                                	    			
                                              	}else{
                                              		for($x=1; $x<=5; $x++){?>
                                              		<span class="rating_star_generic rating_star_disabled"></span> 
                                              	<?php }
                                              	}
                                              	?> 
                                            <span><?php  echo $this->translate(array('%s rating', '%s ratings', intval($item->total)), intval($item->total)); ?></span>
                                            <span class="bd_list">|</span>
                                            <span><?php  echo $this->translate(array('%s comment', '%s comments', intval($item->comment_count)), intval($item->comment_count)); ?></span>
                                        </p>
										<p><?php echo substr(strip_tags($item->content), 0, 350); if (strlen($item->content)>349) echo "...";?> </p>
									</li>
								<?php
                                    }
                                } 
                                ?>
								</ul>
							</div>
						</div>
					</div>		
            </div>
        </div>
    </div>
</div>    