<style type="text/css">
.search_result{padding-top: 0; width: 100%;}
</style>
<?php 
    $profile= $this->profile;
    $industries= $this->industries;
    $user_id= $this->user_id;
    $paginator= $this->paginator_jobs;
    
?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/recruiter'?>"><?php echo $this->translate("Recruiter");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Company Profile");?></strong>
    </div>
</div>
<div class="layout_main">
    <div class="content">
    <div class="section recruiter">
    <div class="layout_right">
        <?php echo $this->content()->renderWidget('recruiter.sub-menu');?>
        <?php echo $this->content()->renderWidget('recruiter.manage-recruiter');?>
        <?php echo $this->content()->renderWidget('resumes.suggest-resume');?>
        <div class="subsection">
            <a href="<?php echo $this->baseUrl().'/recruiter'?>"><img alt="Image" src="application/modules/Core/externals/images/img-showcase-4.jpg"></a>
        </div>
    </div>
    <div class="layout_middle">
        <div class="subsection">
            <h2><?php echo $this->translate('Company Profile')?></h2>
            <div id="loading" style="display: none;">
              <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
              <?php echo $this->translate("Loading ...") ?>
            </div>
            <div class="infom_profile">
		<?php if($profile->photo_id !=null){?>
                <?php echo $this->itemPhoto($profile, 'thumb.profile');?>
                <?php } else{ ?>
		<img src='application/modules/Job/externals/images/no_image.gif' class="thumb_profile item_photo_recruiter  thumb_profile" />
		<?php }?>
                <ul>
                <li class="first_profile_recruiter"><strong><?php echo $profile->company_name;?></strong></li>
                <li><?php echo $this->translate('Industry: ');?>
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
                    </li>
                    <li><?php echo $this->translate('Company Size: ');?>
                        <?php echo $profile->company_size;?>
                    </li>
                    <?php if($user_id==$profile->user_id){?>
                    <li><a href="<?php echo $this->baseUrl().'/recruiter/index/edit-profile/profile_id/'.$profile->recruiter_id;?>"><?php echo $this->translate('Edit');?></a>
                    - <a href="javascript:void(0);" onclick="delete_profile('<?php echo $profile->recruiter_id;?>');return false;"><?php echo $this->translate('Delete');?></a>
                    </li>
                    <?php }?>
                </ul>
                <p><?php echo $profile->description;?></p>
        </div>
    </div>
    <div class="subsection search_result">
    
            <h2><?php echo $this->translate('Jobs of ');?><?php echo $profile->company_name;?></h2>
        	
            <?php if( count($paginator)>0 ): ?>
           
            <table cellspacing="0" cellpadding="0">
            <tr>
    			<th style="width:240px"><?php echo $this->translate("Job Title");?></th>
    			
    			<th style="width:92px"><?php echo $this->translate("Location");?></th>
    			<th><?php echo $this->translate("Date Posted");?></th>
    		</tr>
            	<?php $i = 0; foreach($paginator as $item): 
                    $i++;
                    if($i%2==0){
                        $class= "bg_color";
                    }
                    else{ $class="";}
                ?>
                <tr class="<?php echo $class ?>">
                <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
        			<td class="align_l"><?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position, array('target'=>'_blank')) ?></td>

        			<td><?php echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?></td>
        			<td><?php echo date('d F Y', strtotime($item->creation_date));?></td>
        		</tr>
            <?php endforeach; ?>
            </table>
            <?php else: ?>
            <div style="margin-top: 5px; margin-left: 5px;" class="tip">
                <span>
                  <?php echo $this->translate("Haven't job in company during this time.") ?>
                </span>
              </div>
           
            <?php endif; ?>
        </div>
        <?php if(count($paginator)>0 ): ?>
        <?php echo $this->paginationControl($paginator); ?>
        <?php endif; ?>
    </div>
    </div>
</div>
<script type="text/javascript">
function delete_profile(profile_id){
    var url="<?php echo $this->baseUrl().'/recruiter/index/delete-profile'?>";
    if(confirm("Do you really want to delete this profile?")){
        $('loading').style.display="block";
		new Request({
        url: url,
        method: "post",
        data : {
        		'profile_id': profile_id
        		
       	},
        onSuccess : function(responseHTML)
        {
            $('loading').style.display="none";
            if(responseHTML==1){
                //tam thoi cho redirect ve trang nay
                window.location.href= "<?php echo $this->baseUrl().'/recruiter/'?>";
            }
            
        }
    }).send();
	}	
}
</script>