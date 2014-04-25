<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
.content_artical p{padding: 10px 10px 5px 10px !important;}
</style>
<?php 
    $artical= $this->artical;
    $other_old_articals= $this->other_old_articals;
    $other_new_articals= $this->other_new_articals;
?>
<div class="layout_main">
<?php echo $this->content()->renderWidget('recruiter.search-job');?>
<!--
<div class="headline">
    <?php echo $this->content()->renderWidget('recruiter.menu')?>
</div>
<div class="layout_left">
<?php echo $this->content()->renderWidget('recruiter.manage-job');?>
</div>
-->
<div id="content">
        <div class="section jobs">

            <div class="layout_right">
                <!-- online resume -->
                <?php echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
                <!-- job manage -->
                <?php echo $this->content()->renderWidget('recruiter.manage-job');?>
                <!-- end -->
                <!-- feature employers -->
                <?php //echo $this->content()->renderWidget('recruiter.featured-employer');?>
                <!-- end -->
                <div class="subsection">
                    <a href="<?php echo $this->baseUrl().'/resumes'?>"><img src="application/modules/Core/externals/images/img-showcase-4.jpg" alt="Image" /></a>
                </div>
            </div>

            <div class="layout_middle">
                <!--view artical -->
                <div id="breadcrumb">
                    <div class="section">
                        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/recruiter/index/article'?>"><?php echo $this->translate("Articles");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Detail article");?></strong>
                    </div>
                </div>
                <div class="subsection">
                    <h2><?php echo $artical->title;?></h2>
                    
                    <div class="content_artical">
                    <p>Date: <span style="font-style: italic;"><?php echo date('d F Y', strtotime($artical->created)) ?></span></p> 
                    <p><?php echo $artical->content;?></p>
                    </div>
                    <!-- AddThis Button BEGIN -->
                    <div class="addthis_toolbox addthis_default_style " style="padding-bottom: 5px; padding-left: 10px;">
                    <a href="http://www.addthis.com/bookmark.php?v=250&amp;username=huynhnv" class="addthis_button_compact">Share</a>
                    <span class="addthis_separator">|</span>
                    <a class="addthis_button_preferred_1"></a>
                    <a class="addthis_button_preferred_2"></a>
                    <a class="addthis_button_preferred_3"></a>
                    <a class="addthis_button_preferred_4"></a>
                    </div>
                    <script type="text/javascript">var addthis_config = {"data_track_clickback":true};</script>
                    <script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=huynhnv"></script>
                    <!-- AddThis Button END -->
                    </div>
                <!-- end -->
                
                    
                    <?php if(count($other_old_articals) || count($other_new_articals)){ ?>
                    <div class="subsection">
                    <h2><?php echo $this->translate('Other Articles');?></h2>
                        <ul class="articles_jobs">
                        <?php 
                        if(count($other_new_articals)){
                            
                        foreach($other_new_articals as $item){    
                        ?>
                        	
                    		<li>
                    			
                                <?php if(!empty($item->photo_id)){
                                    echo $this->itemPhoto($item, 'thumb.icon');
                                    } else{?>
                                        <img alt="No image" src="application/modules/Job/externals/images/no_image.gif" />
                                    <?php }
                                ?>
                    			<div class="link_jobs">
                                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
                    				<a href="<?php echo $this->baseUrl().'/recruiter/index/view-article/id/'.$item->artical_id.'/'.$slug ?>"><?php echo $item->title;?></a>
                    			</div>
                    		</li>
                    	
                        <?php } 
                        } ?> 
                        <?php 
                        if(count($other_old_articals)){
                        foreach($other_old_articals as $item){    
                        ?>
                        	
                    		<li>
                    			
                                <?php if(!empty($item->photo_id)){
                                    echo $this->itemPhoto($item, 'thumb.icon');
                                    } else{?>
                                        <img alt="No image" src="application/modules/Job/externals/images/no_image.gif" />
                                    <?php }
                                ?>
                    			<div class="link_jobs">
                                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
                    				<a href="<?php echo $this->baseUrl().'/recruiter/index/view-article/id/'.$item->artical_id.'/'.$slug ?>"><?php echo $item->title;?></a>
                    			</div>
                    		</li>
                    	
                        <?php } 
                        } ?> 
                        </ul>
                        </div>
                       <?php }
                        ?>
                
           
            </div>

            <div class="clear"></div>

        </div>
</div>

</div>
