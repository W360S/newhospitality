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
$paginators= $this->paginator;
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
            <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate('Home');?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/school'?>"><?php echo $this->translate('Education School');?></a>  <span>&gt;</span> <?php echo $this->htmlLink(array('route' => 'view-school', 'id'=> $school->school_id), $school->name) ?><span>&gt;</span> <strong><?php echo $this->translate('View all');?></strong>
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
								<li><?php echo $this->translate('Address: ');?><?php echo $school->address;?></li>
								<li><span><?php echo $this->translate('Country: ');?><?php echo $this->country($school->country_id)->name;?></span></li>
								<li><span><?php echo $this->translate('Phone: ');?><?php echo $school->phone;?></span></li>
								<li><p><a class="share smoothbox" href="<?php echo $this->baseUrl() ?>/activity/index/share/type/school_school/id/<?php echo $school->school_id ?>/format/smoothbox"><?php echo $this->translate('Share');?></a></p></li>
							</ul>
						</div>
						<div class="school-contact">
							<ul>
								<li><span><?php echo $this->translate('Website: ');?></span><?php echo $school->website;?></li>
								<li><span><?php echo $this->translate('Email: ');?></span><?php echo $school->email;?></li>								
							</ul>
                            <?php if(!empty($viewer_id)){?>
							<div class="buttom"><a class="bt-post-article" href="<?php echo $this->baseUrl().'/school/article/create/id/'.$school->school_id;?> "><?php echo $this->translate('Post an Article');?></a></div>
                            <?php } ?>
						</div>
						<p></p>
                </div>
                	<div class="article-school">
						
						<div class="sub-section article-middle">
							
							<div class="sub-content">
								<ul class="list_articel_school">
                                <?php 
                                if(count($paginators)){
                            
                                    foreach($paginators as $item){    
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
                                <?php echo $this->paginationControl($paginators);?>
							</div>
						</div>
					</div>		
            </div>
        </div>
    </div>
</div>    