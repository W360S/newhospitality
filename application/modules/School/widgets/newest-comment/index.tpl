<div class="subsection">
    <h2><?php echo $this->translate('Newest Comments');?></h2>
    <div class="subcontent">
        <ul class="list_comments_school">
        <?php
            if(count($this->comments)>0){
                $arr= array();
                foreach($this->comments as $item){
                    
                    if(!in_array($item->artical_id, $arr)){ ?>
                        <li>
                            <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
                			<h4 class="title"><?php echo $this->htmlLink(array('route' => 'view-school-artical', 'id'=> $item->artical_id, 'slug'=>$slug), $item->title) ?>
	                        </h4>
                			<?php
                            $user= Engine_Api::_()->getDbtable('users', 'user')->find($item->owner_id)->current();
                                   
                            echo $this->itemPhoto($user, 'thumb.icon');?>
                			<p><?php echo substr(strip_tags($item->body), 0, 350); if (strlen($item->body)>349) echo "...";?></p>
                		</li>
                <?php }
                    $arr[]= $item->artical_id;
                }
            } 
        ?>
            
        </u>
    </div>
</div>