<style type="text/css">
.item .featured img{height:92px;}
</style>
<div class="item last">
    <h2><a href="<?php echo $this->url(array('module'=>'events'), 'default', true) ?>"><?php echo $this->translate('Events')?></a> </h2>
    <div class="featured">
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
            	//exit('hao = '.$event->event_id);
            	//echo $this->action('getuser','index','event',array('user_id' => $event->event_id));
                //start foreach
                //Zend_Debug::dump($user_org);exit;
                $i++;
                if($i==1){
                    if(!$event->photo_id){?>
                        <img src="application/modules/Core/externals/images/no-picture_events.jpg" alt="Image" height="92" />
                    <?php } else{
                        echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.normal', null, array("width"=>142,"maxheight"=>102)));
                    }?>
                    
                    <h3><a href="<?php echo $event->getHref();?>"><?php echo $event->title?></a></h3>
                    <em class="date">
                     <?php
                        // Convert the dates for the viewer
                        $startDateObject = new Zend_Date(strtotime($event->starttime));
                        $endDateObject = new Zend_Date(strtotime($event->endtime));
                        if( $this->viewer() && $this->viewer()->getIdentity() ) {
                          $tz = $this->viewer()->timezone;
                          $startDateObject->setTimezone($tz);
                          $endDateObject->setTimezone($tz);
                        }
                      ?>
                      <?php if( $event->starttime == $event->endtime ): ?>  
                
               			  <?php echo  date('D, d F Y',strtotime($event->starttime)); ?>
                		
                            -                
                          <?php echo  date('g:i:a',strtotime($event->starttime)); ?> 
                		
                	<?php elseif( $startDateObject->toString('y-MM-dd') == $endDateObject->toString('y-MM-dd') ): ?>
                	
                			<?php echo  date('D, d F Y',strtotime($event->starttime)); ?>
                		
                	       ,
                			 <?php echo  date('g:i:a',strtotime($event->starttime)); ?> 
                            -
                            <?php echo  date('g:i:a',strtotime($event->endtime)); ?> 
                		
                	<?php else: ?>
                	
                			<?php echo  date('d F Y, g:i:a',strtotime($event->starttime)); ?>
                	       -
                			<?php echo  date('d F Y, g:i:a',strtotime($event->endtime)); ?>
                		<?php endif;?>	
                     </em>
                    <p><?php echo $this->translate("Place:"); ?>  <?php echo $event->location; ?></p>
                    <p><?php echo $this->translate("Organized by:"); ?> <?php echo $this->substring($event->host, 40);?></p>
                    <p><?php echo $this->translate("Post by:"); ?> <?php echo $event->username; ?></p>
                    <p><?php echo $this->translate("Type of Event:"); ?> <?php echo $event->category_name; ?></p>
                    <!-- 
                    <p>
                    	<?php //echo $this->viewDescription($event->description); ?>
                    	<?php //echo $this->substring($event->description,100); ?>
                    </p>
                     -->
                    <div class="more"><a href="<?php echo $event->getHref();?>"><?php echo $this->translate('More')?></a></div>
                <?php }
                else{
                    $list_events[$i-1]= $event;
                    $n= $i;
                }
            }
            //end foreach
        ?>   
        </div>
        <ul style="padding-top: 10px;">
        
        <?php 
        if(count($this->events)>1){
            for($i=1; $i<$n; $i++){?>
            <li>
            	<a href="<?php echo $list_events[$i]->getHref();?>"><?php echo $list_events[$i]->title; ?></a> 
               	<!-- 
               	<em>(< ?php echo date('F d, Y \a\t h:a',strtotime($event->creation_date)); ?>)</em>
            	 -->
            </li>
        <?php }
        }
        ?>
        </ul>
    <?php } ?>   
</div>