<?php 
    $school= $this->school;
    $other_new_articals= $this->other_new_articals;
    
?>
<div class="layout_main">
    <div class="headline">
    <?php echo $this->translate('day la headline');?>
    </div>
    <div class="layout_left">
    <?php echo $this->translate('day la left');?>
    </div>
    <div class="layout_middle">
        <div class="school_main_manage">
            <div class="subsection">
                <h2><?php echo $this->translate('Detail school');?></h2>
                <ul>
                <?php if($school->photo_id){?>
                    <li>
                        <?php echo $this->itemPhoto($school, 'thumb.normal');?>
                    </li>
                <?php } ?>
                    <li><?php echo $this->translate("School name: ");?><strong><?php echo $school->name;?></strong></li>
                    <li><?php echo $this->translate("Description: ");?><?php echo $school->intro;?></li>
                    <li><?php echo $this->translate("Website: ");?><?php echo $school->website;?></li>
                    <li><?php echo $this->translate("Email : ");?><?php echo $school->email;?></li>
                    <li><?php echo $this->translate("Fax : ");?><?php echo $school->fax;?></li>
                    <li><?php echo $this->translate("Phone : ");?><?php echo $school->phone;?></li>
                </ul>
            </div>
            <?php if(count($other_new_articals)){ ?>
            <div class="subsection">
                <h2><?php echo $this->translate("Related Articals");?></h2>
            
                <ul>
                    <?php 
                        if(count($other_new_articals)){
                            
                        foreach($other_new_articals as $item){    
                        ?>
                        	
                    		<li>
                    			<div class="articals">
                                    <img src="<?php echo $this->baseUrl().'/application/modules/Core/externals/images/arrow_next.png'?>" />
                    				<?php echo $this->htmlLink(array('route' => 'view-artical', 'id' => $item->artical_id), $item->title) ?>
                                </div>
                    		</li>
                    	
                        <?php } 
                        } ?> 
                        
                </ul>
            </div>
            <?php }?>
            
        </div>
    </div>
</div>