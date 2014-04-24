<div class="subsection" style="border-top-left-radius:0px;">
    
    <?php if(count($this->categories)): ?>
    <ul class="list_category jobs_category">
        <?php if(count($this->categories)<3){
            foreach($this->categories as $item): ?>
               
                        <li><a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/search/category/category_id/'.$item["category_id"] ?>"><?php echo $item["name"]; ?> (<span><?php echo $item["sum"]?></span>)</a></li>
                    
            <?php endforeach;
        } else{?>
            <?php 
                $i=0;
                foreach($this->categories as $item): 
                    $i++;
                ?>
                
                <?php
                if($i==1 || ($i%3==1 && $i !=3)){?>
                
                <?php } ?>
                        <li><a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/search/category/category_id/'.$item["category_id"] ?>"><?php echo $item["name"]; ?> <span><?php echo $item["sum"]?></span></a></li>
            
        		<?php 
                if($i%3==0 || (($i%3==1 ||$i%3==2)&& $i==count($this->categories))){?>
                    
                <?php }?>
                
        			
         	<?php endforeach; ?>
            <?php 
            }
            ?>
        </ul>
        <?php endif; ?>
</div>
 