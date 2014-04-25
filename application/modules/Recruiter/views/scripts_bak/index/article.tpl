<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
</style>
<?php $paginator= $this->paginator;?>
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
                <div id="breadcrumb">
                    <div class="section">
                        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/recruiter/index/article'?>"><?php echo $this->translate("Articles");?></a>
                    </div>
                </div>
                <!--list all articals -->
                <div class="subsection">
                    <h2>Articles</h2>
                    <?php if($paginator){ ?>
                        <ul class="articles_jobs">
                        <?php 
                        foreach($paginator as $item){    
                    ?>
                        	
                    		<li>
                    			
                                <?php if($item->photo_id){
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
                    		
                    		
                    	
                        <?php }?>
                        </ul>
                        
                       <?php }
                        ?>
                        
                       <div>
                       <?php echo $this->paginationControl($paginator); ?>
                       </div>
       
                    </div>
                <!-- end -->
                
            </div>

            <div class="clear"></div>

        </div>
</div>

</div>
