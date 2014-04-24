<ul>
<?php 
    foreach($this->paginator as $paginator){?>
        <li>
        
            <?php if($paginator->photo_id){
            echo $this->itemPhoto($paginator, 'thumb.icon');
        } else{ ?>
            <img src="<?php echo $this->baseUrl().'/application/modules/Job/externals/images/no_image.gif' ?>" class="thumb_icon item_photo_school  thumb_icon" />
        <?php }?>
            <h3>
                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($paginator->name);?>
                <?php if(Engine_String::strlen($job->position)>64){
        			$strings= Engine_String::substr($paginator->name, 0, 64) . $this->translate('... &nbsp;');
        			}
        		else{
        			$strings= $paginator->name;
        		}
        		?>
                <?php echo $this->htmlLink(array('route' => 'view-school', 'id' => $paginator->school_id, 'slug'=>$slug), $strings) ?>
            </h3>
            <p><?php echo $paginator->address;?></p>
        </li>
        
    <?php } ?>
    
    
</ul>
<?php 
    if( $this->paginator->count() > 1 ): 
?>
<div class="paging">
    <?php echo $this->paginationControl($this->paginator, null, "application/modules/School/views/scripts/pagination.tpl"); ?>
</div>
<?php endif; ?>