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

.company_profile img {
    display: inline;
    float: left;
    height: 31px;
    margin-right: 18px;
    margin-top: 6px;
    padding: 1px 1px 9px;
    width: 76px;
}
</style>
<?php 
    $profile= $this->profile;
    $industries= $this->industries;
?>
<?php if(!empty($profile)){?>
        <div class="subsection">
            <!--<h2><?php //echo $this->translate('Profile Company')?></h2>-->
            
            <div class="company_profile" style="background:#F6F6F6">
                <?php if($profile->photo_id !=null){?>
                <?php echo $this->itemPhoto($profile, 'thumb.profile');?>
                <?php } else{ ?>
        		<img src='application/modules/Job/externals/images/no_image.gif' class="thumb_profile item_photo_recruiter  thumb_profile" />
        		<?php }?>
                <p><strong  style="color:#666666;font-size:15px;"><?php echo $profile->company_name;?> </strong></p>
                
                <p><?php echo $this->translate('Industry: ');?>
                    <?php 
                    $i=0;
                        foreach($industries as $industry){
                            $i++;
                            if($i==count($industries)){
                                echo $this->categoryJob($industry->industry_id)->name;
                            }else{
                                echo $this->categoryJob($industry->industry_id)->name. " - ";
                            }
                            
                        }
                    ?>
                    </p>
                    <div style="clear:both"></div>
                    <p  style="color:#666666;margin-top:11px"><span id="companyprofile"> <?php echo $profile->description;?></span> <a style="color:#3D7CBF;text-decoration:underline;" class="text-s" id="but1" href="javascript:toggle();">View more</a></p>
					
	<script type="text/javascript">
        var tflag = 0;
        var txt = document.getElementById("companyprofile").innerHTML;
        function toggle() {
            if (tflag == 0) {  // show first 399 characters
                document.getElementById("companyprofile").innerHTML = txt.substring(0, 399) + "...";
                tflag = 1;
                document.getElementById("but1").innerHTML = "View more";
            }
            else {
                document.getElementById("companyprofile").innerHTML = txt;
                document.getElementById("but1").innerHTML = "View less";
                tflag = 0;
            }
        }
        toggle();
    </script>
                    <p style="color:#666666;font-size:13px;margin-top:13px"><?php echo $this->translate('Company Size: ');?>
                        <?php echo $profile->company_size;?>
                    </p><!--
                    <p style="color:#666666;font-size:13px"><?php echo $this->translate('Contact name: ');?>
                        <?php echo $_SESSION['contact_name'];?>
                    </p>-->
                    
                	
        </div>
    </div>
<?php } ?>