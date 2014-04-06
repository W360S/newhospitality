<style type="text/css">
	.subsection .entries{overflow:hidden;padding:10px}
</style>

<div class="subsection">
    <h2><a href="<?php echo $this->baseUrl().'/events'?>"><?php echo $this->translate('Events')?></a></h2>
    <div class="subcontent">
        <div class="entries">
            <div class="featured">
                <div class="header">
                <?php if($this->event ==0){
     				echo $this->translate('');
			    ?>
    				
			        </div>
			    <?php }else{
			            $i=0;
			            $list_photos= array();
			            foreach($this->photos as $photo){
			            //start foreach
			                
			                $i++;
			                $list_photos[$i]= $photo;
			            }//endforeach
			            $i=0;
			            $list_events= array();
			            foreach($this->events as $event){
			                //start foreach
			                $i++;
			                if($i==1){
			                    if(!$event->photo_id){?>
			                        <a href="<?php echo $event->getHref();?>"><img  src="<?php echo $this->baseUrl(); ?>/application/modules/Event/externals/images/types/clock_32.png"></a>
			                    <?php } else{
			                        echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.icon'));
			                    }?>
			                    <h3><a href="<?php echo $event->getHref();?>"><?php echo $event->title; ?></a></h3>
			                    <em class="date"><?php echo  date('d F Y, g:i:a',strtotime($event->creation_date)); ?></em>

                </div>			                   
                <p><?php echo $this->viewDescription($this->substring($event->description, 250));  ?></p>
                <?php }
                else{
                    $list_events[$i-1]= $event;
                    $n= $i;
                }
            }
            //end foreach
        	?>   
            </div>
            <ul>
        
		    <?php 
		    if(count($this->events)>1){
		        for($i=1; $i<$n; $i++){?>
		        <li><a href="<?php echo $list_events[$i]->getHref();?>"><strong><?php echo $list_events[$i]->title; ?></strong></a><br /> <em><?php echo  date('d F Y, g:i:a',strtotime($list_events[$i]->creation_date)); ?></em></li>
		    <?php }
		    }
		    ?>
		    </ul>
		<?php } ?>   
            <div class="more"><a href="<?php echo $this->baseUrl().'/events'?>"><?php echo $this->translate("More"); ?></a></div>
        </div>
    </div>
</div>