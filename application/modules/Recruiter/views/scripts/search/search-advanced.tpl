<style type="text/css">

#global_wrapper {background: none;}
.panel{position:absolute;}
.panel .trigger{width: 359px;}
.panel .content{width: 350px;}
.search_result{padding-top: 0; width: 100%;}
div.search_result table td a{color: #028EB9;}
#industries-element ul.form-options-wrapper, #categories-element ul.form-options-wrapper{
    height: 186px;
    overflow-y: auto;
    width: 360px;
    border: #E5E5E5 solid 1px;
}
</style>
<?php
    $form= $this->form; 
    $paginator= $this->paginator;
    $keyword= $this->keyword;
    $city_id= $this->city_id;
    $country_id= $this->country_id;
    $type= $this->type;
    $industries= $this->industries;
    $values= $this->values;    
    $categories= $this->categories;
    
?>
<div id="breadcrumb">
    <div class="section">
        <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/resumes'?>"><?php echo $this->translate("Job Seekers");?></a> <span>&gt;</span> <strong><?php echo $this->translate("Search Advanced");?></strong>
    </div>
</div>
<div id="content">
<div class="section jobs">

<div class="layout_right">
    <!-- job manage -->
    <?php echo $this->content()->renderWidget('recruiter.manage-job');?>
    <!-- end -->
    <!-- feature employers -->
    <?php //echo $this->content()->renderWidget('recruiter.featured-employer');?>
    <!-- end -->
    <!-- insert some advertising -->
    <?php include 'ads/right-column-ads.php'; ?>
</div>
<div class="layout_middle">
<!-- Form search -->
<div class="subsection">
    
    <h2><?php echo $this->translate('Search Advanced');?></h2>
    <form id="recruiter_job_search_advanced_form" action="<?php echo $form->getAction();?>" method="post" enctype="application/x-www-form-urlencoded">
        <fieldset class="job-form job-form-step-2">
            <div class="input">
                <?php echo $form->search_job;?>
            </div>
    		<div class="input job_match">
                
	               <?php echo $form->match;?>
                
    		</div>
    		<div class="input">
                <?php echo $form->country_id;?>
                <?php echo $form->city_id;?>
            </div>
    		
    		<div class="input">
                <?php echo $form->type;?>
            </div>
    		<div class="input">
                <?php echo $form->industries;?>
            </div>
            <div class="input">
                <?php echo $form->categories;?>
            </div>
            <div class="submit">
                <input type="submit" class="min" value="Search">
                <input type="reset" class="min" value="Reset" onclick="reset_search();">
            </div>
        </fieldset>
    </form>
   
	
</div>
<!-- end form -->
<!-- Search result -->
<div class="subsection search_result">
    
    <h2><?php echo $this->translate('Search Result');?></h2>
	
    <?php if( count($paginator)>0 ): ?>
    <table cellspacing="0" cellpadding="0">
        <tr>
			<th style="width:240px"><?php echo $this->translate("Job Title");?></th>
			<th style="width:120px"><?php echo $this->translate("Company");?></th>
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
			<td><?php if($this->company($item->user_id)) echo $this->company($item->user_id)->company_name;?></td>
			<td><?php echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?></td>
			<td><?php echo date('d F Y', strtotime($item->creation_date));?></td>
		</tr>
        <?php endforeach; ?>
        
    </table>
    
    <?php else: ?>
    <div style="margin-top: 5px; margin-left: 5px;" class="tip">
        <span>
          <?php echo $this->translate("Haven't job in this search result.") ?>
        </span>
    </div>
    <?php endif; ?>
</div>
<?php if(count($paginator)>0 ): ?>
    <?php echo $this->paginationControl($paginator, null, null, array(
                'query' => $values
        )); ?>
    <?php endif; ?>
    <div class="clear"></div>
<!-- end search result -->
<div class="block_content gutter">
	<div class="jobs_promotion"><a href="http://www.vinpearlluxury-nhatrang.com/" target='_blank'><img src="application/modules/Job/externals/images/companies/vinpearlluxury.png" alt="Image" /></a></div>
</div>
<div class="block_content">
	<div class="jobs_promotion"><a href="http://oceanhospitality.vn/" target='_blank'><img src="<?php echo $this->baseUrl('/application/modules/Resumes/externals/images/oceanhospitality.jpg')?>" alt="Image" /></a></div>
</div>
</div>
</div>
</div>
<script type="text/javascript">
function reset_search(){
    $('recruiter_job_search_advanced_form').reset();
    list_city();
}
window.addEvent('domready', function(){
    //var select_job= document.id('select_job');
   //$('industries-element').inject(select_job);
   //$('sl_job').inject('industries-label', 'after');
    var keyword= "<?php echo $keyword ?>";
    var country_id= "<?php echo $country_id ?>";
    var city_id= "<?php echo $city_id ?>";
    var type= "<?php echo $type ?>";
    var temp_country_id= country_id;
    $('search_job').set('value', keyword);
    if(country_id > 0){
        
    
        jQuery('#country_id option').each(function(){
           if(country_id==jQuery(this).val()){
            jQuery(this).attr('selected', 'selected');
            
           }
           var url= "<?php echo $this->baseUrl().'/resumes/index/city' ?>";
           
        
           new Request({
                url: url,
                method: "post",
                data : {
                		
                		'country_id': country_id
                	},
                onSuccess : function(responseHTML)
                {
                    
                    $('city_id').set('html', responseHTML);
                    if(temp_country_id==0){
          		        jQuery('#city_id').prepend("<option value='0'>All city </option>");
          		    }
                	jQuery('#city_id option').each(function(){
                        if(city_id==jQuery(this).val()){
                            jQuery(this).attr('selected', 'selected');
                        } 
                 }); 	
                }
            }).send();
           
        });
    }
    jQuery('#type option').each(function(){
                    if(type==jQuery(this).val()){
                        jQuery(this).attr('selected', 'selected');
                    } 
             }); 	
    
    
});
function list_city(){
    var url= "<?php echo $this->baseUrl().'/resumes/index/city' ?>";
    var country_id= $('country_id').get('value');
    var temp_country_id= country_id;
    if(country_id==0){
        //country_id=1;
    }
    new Request({
        url: url,
        method: "post",
        data : {
        		
        		'country_id': country_id
        	},
        onSuccess : function(responseHTML)
        {
            
            $('city_id').set('html', responseHTML);
      		if(temp_country_id==0){
      		    jQuery('#city_id').prepend("<option value='0'>All city </option>");
      		}
        }
    }).send();
}
</script>
