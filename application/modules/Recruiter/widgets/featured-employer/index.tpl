<style type="text/css">
.feature_empLoyers{overflow:hidden;padding:8px 0}
ul.feature_empLoyers li{float:left;width:120px;height:80px;margin-left:8px;display:inline;background:url(application/modules/Job/externals/images/bg_img_employers.gif) no-repeat;padding:1px;margin-bottom:4px;clear:none;}
.feature_empLoyers li.view_all{width:100%;text-align:center;height:auto;background:none;margin:0}
.feature_empLoyers li.view_all a{font-weight:bold;color:#000}
.feature_empLoyers li.view_all a:hover{color:#059CCB}
.feature_empLoyers li img{width:118px;height:70px}
img.main, img.thumb_normal, img.thumb_profile, img.thumb_icon {
    border: none;
}
.feature_empLoyers li img {
    height: 60px;
    width: 108px;
}
</style>
<div class="block_content">
<div class="pt-block">
    <h3 style="border-bottom: 1px solid #E5E5E5;color: #262626;font-size: 14px; font-weight: normal; margin: 0 10px;overflow: hidden; padding: 10px 0;  text-transform: uppercase;"><?php echo $this->translate("Featured Employers"); ?></h3>
    <div class="subcontent">
		<ul class="feature_empLoyers">
        <?php foreach($this->profiles as $profile){?>
            <li style="background:none;padding:7px;width:110px">
    			<?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($profile->company_name);?>
                <a title="<?php echo $profile->company_name;?>" href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/recruiter/index/view-profile/id/'.$profile->recruiter_id.'/'.$slug;?>">
                    <?php 
                        if($profile->photo_id){
                            echo $this->itemPhoto($profile, 'thumb.profile');
                        }else{?>
                            <img src="<?php echo $this->baseUrl('/application/modules/Job/externals/images/no_image.gif')?>" alt="No image" />
                        <?php }
                        ?>
                </a>
                 
    		</li>
        <?php }?> 
            <!--<li class="view_all"><a href="<?php echo $this->baseUrl().'/recruiter/index/employer'?>"><?php echo $this->translate("View all feature employers");?></a></li>-->
		</ul>	
    </div>
</div>
</div>