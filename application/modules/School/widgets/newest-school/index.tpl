<style type="text/css">
.list_shool ul li a img {width: 163px;}
</style>
<div class="list_shool">
	<ul>
    <?php
        if($this->schools){
            foreach($this->schools as $item){?>
            <li>
    			<a><?php echo $this->itemPhoto($item);?></a>
    			<?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->name);?>
                <?php echo $this->htmlLink(array('route' => 'view-school', 'id'=> $item->school_id, 'slug'=>$slug), $item->name) ?>
					
				<p class="rating"><span><?php  echo $this->translate(array('%s article', '%s articles', intval($item->num_artical)), intval($item->num_artical)); ?></span><span class="bd_list"> |</span>
                <span><?php  echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)); ?></span></p>
			</li> 
        <?php }
        } 
    ?>
		
		
	</ul>
</div>