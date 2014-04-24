<div class="subsection">
	<h2><?php echo $this->translate('Top Hospitality Schools');?></h2>
	<ul class="list_top_school">
    <?php if($this->schools){
        foreach($this->schools as $item){?>
            <li>
    			<a><?php echo $this->itemPhoto($item);?></a>
                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->name);?>
    			<h4 class="title"><?php echo $this->htmlLink(array('route' => 'view-school', 'id'=> $item->school_id, 'slug'=>$slug), $item->name) ?>
				</h4>
    			<p><?php echo $this->translate('Country:')?> <?php echo $this->country($item->country_id)->name;?></p>
    			<p style="font-size: 11px; color:#8D8D8D;">
                    <span><?php  echo $this->translate(array('%s article', '%s articles', intval($item->num_artical)), intval($item->num_artical)); ?></span>
                    <span class="bd_list">|</span>
                    <span><?php  echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)); ?></span>
                </p>
    		
            </li>
        <?php }
    }
    ?>
        
    </ul>
 </div>