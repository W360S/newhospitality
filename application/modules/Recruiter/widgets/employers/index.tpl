<?php $paginator= $this->profiles;?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("All Featured Employers");?></strong>
    </div>
</div>
<div class="subsection">
    <div id="search_company" class="search-company">
        
        <input type="text" value="" class="input" id="txt-search" />
        <input type="submit" value="<?php echo $this->translate('Search');?>" id="bt-search-company" style="cursor: pointer;" />
    </div>
    <div id="company">
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
        <?php echo $this->paginationControl($paginator, null, "application/modules/Recruiter/views/scripts/pagination_company.tpl"); ?>
    </div>
    <?php endif; ?>
</div>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
    $('txt-search').addEvent( 'keypress', function( evt ){ 
        if(evt.key== 'enter' && evt.shift == false){
            jQuery('#bt-search-company').click();
        }
    });
    jQuery('#bt-search-company').click(function(){
        var txt= jQuery('#txt-search').val();
        jQuery.post
                ('<?php echo $this->baseUrl() . '/recruiter/index/search' ?>',
                { 
                    search : txt
                   
                },
                function (data){                       
                    jQuery('#company').html(data);
                }
                );
    });
});

</script>
