<style type="text/css">
.layout_middle .subsection {clear:both;}
.pt-user-post a span.pt-avatar {
    border-radius: 50%;
    display: block;
    float: left;
    height: 45px;
    margin-right: 12px;
    width: 45px;
}
.pt-user-post a span.pt-avatar img {
    border-radius: 50%;
    display: block;
    float: left;
    height: 45px;
    width: 45px;
}
.pt-user-post a {
    display: block;
    float: left;
    overflow: hidden;
}
img.thumb_icon{
	border:none;
}
</style>
<div class="block_content">
<div class="pt-block">
    <h3 style="border-bottom: 1px solid #E5E5E5;color: #262626;font-size: 14px; font-weight: normal; margin: 0 10px;overflow: hidden; padding: 10px 0;  text-transform: uppercase;"><?php echo $this->translate("Career Advice");?></h3><a style="color: rgb(79, 193, 233); display: inline-block; float: right; font-size: 12px; text-transform: none; position: relative; margin-right: 21px; margin-top: -28px;" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/index/article'?>"><?php echo $this->translate('All');?></a>
    <?php if($this->paginator){ ?>
        <ul class="pt-list-right">
        <?php 
        foreach($this->paginator as $item){    
    ?>
        	
    		<li>
    			<div class="pt-user-post">
	                <?php if($item->photo_id){
	                    echo $this->itemPhoto($item, 'thumb.icon');
	                    } else{?>
	                        <img alt="No image" src="application/modules/Job/externals/images/no_image.gif" />
	                    <?php }
	                ?>
	    			<div class="pt-how-info-user-post" style="float:right;width:74%"><h3>
	                    <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
	    				<a style="font-size:12px" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/index/view-article/id/'.$item->artical_id.'/'.$slug ?>"><?php echo $item->title;?></a></h3>
	    			</div>
    			</div>
    			
    		</li>
    	
        <?php }?>
        
            <!--<li class="view_all_articles"><a href="<?php echo $this->baseUrl().'/recruiter/index/article'?>"><?php echo $this->translate('View all articles');?></a></li>-->
        
        </ul>
        
       <?php }
        ?>
  </div>     
</div>