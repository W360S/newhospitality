<style type="text/css">
.company_profile img{
    
    display:inline;
    float:left;
    height:70px;
    margin-right:18px;
    margin-top:6px;
    padding:1px 1px 9px;
    width:118px;
}
</style>
<?php 
    $profile= $this->profile;
    $industries= $this->industries;
?>
<?php if(!empty($profile)){?>
        <div class="subsection">
            <h2><?php echo $this->translate('Profile Company')?></h2>
            
            <div class="company_profile">
                <?php echo $this->itemPhoto($profile, 'thumb.profile');?>
                
                <p><strong><?php echo $profile->company_name;?></strong></p>
                <p><?php echo $this->translate('Industry: ');?>
                    <?php 
                    $i=0;
                        foreach($industries as $industry){
                            $i++;
                            if($i==count($industries)){
                                echo $this->industry($industry->industry_id)->name;
                            }else{
                                echo $this->industry($industry->industry_id)->name. " - ";
                            }
                            
                        }
                    ?>
                    </p>
                    <p><?php echo $this->translate('Company Size: ');?>
                        <?php echo $profile->company_size;?>
                    </p>
                    <p><?php echo $profile->description;?></p>
        </div>
    </div>
<?php } ?>