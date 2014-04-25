 <?php $paginator= $this->profiles;?>
 <?php if(count($paginator)>0):?>
 <div>
	<ul class="feature_empLoyers">
    <?php foreach($paginator as $profile){?>
        <li>
			
            <a title="<?php echo $profile->company_name;?>" href="<?php echo $this->baseUrl().'/recruiter/index/view-profile/id/'.$profile->recruiter_id;?>"><?php echo $this->itemPhoto($profile, 'thumb.profile');?></a>
              
		</li>
    <?php }?>
	</ul>	
</div>
<?php 
if( $paginator->count() > 1 ): 
?>
<div class="paging">
    <?php echo $this->paginationControl($paginator, null, "application/modules/Recruiter/views/scripts/pagination_company_search.tpl"); ?>
</div>
<?php endif; ?>
<?php else:?>
    <p style="padding:10px;"><?php echo $this->translate("There's no company.")?></p>
<?php endif; ?>