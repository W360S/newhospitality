<style type="text/css">
#global_wrapper{background: none;}
</style>
<?php
    $paginator= $this->paginator;
    $keyword= $this->keyword;
    $country_id= $this->country_id;
    $city_id= $this->city_id;
    $level= $this->level;
    $language= $this->language;
    $degree= $this->degree;
    $values= $this->values;
    $no_req= $this->no_req;
    $industry= $this->industry;
    
?>

    <div id="content">
    <div class="section recruiter">
    <div class="layout_right">
        <?php echo $this->content()->renderWidget('recruiter.sub-menu');?>
        <?php echo $this->content()->renderWidget('recruiter.manage-recruiter');?>
        <?php echo $this->content()->renderWidget('resumes.suggest-resume');?>
        <!-- insert some advertising -->
        <?php include 'ads/right-column-ads.php'; ?>
    </div>
    <div class="layout_middle">
        <div class="recruiter_main">
            
            <?php echo $this->content()->renderWidget('recruiter.search-resumes');?>
            
            <?php echo $this->content()->renderWidget('resumes.categories');?>
            <div class="subsection">
                <h2><?php echo $this->translate('Search Result');?></h2>
                <?php if(count($paginator)>0 ): ?>
   
                    <ul class="list_questions">
                    	<?php $cnt = 1; foreach($paginator as $item): ?>
                        <li>
                    		<div class="list_number">
                    			<?php echo $cnt; ?>
                    		</div>
                    		<div class="content_questions">
                    			<?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
                                <h3><a href="<?php echo $this->baseUrl().'/resumes/resume/view/resume_id/'.$item->resume_id.'/'.$slug ?>"><?php echo $item->title;?></a></h3>
                
                    			<p><?php echo $this->user($item->user_id);?></p>
                            </div>
                    	</li>
                    <?php $cnt = $cnt + 1; endforeach; ?>
                    </ul>
                    
                    <?php else: ?>
                    <div style="margin-top: 5px; margin-left: 5px;" class="tip">
                        <span>
                          <?php echo $this->translate("Haven't resumes.") ?>
                        </span>
                      </div>
                   
                    <?php endif; ?>
            </div>
            
        </div>
        <?php if(count($paginator)>0 ): ?>
        <?php echo $this->paginationControl($paginator, null, null, array(
            'query' => $values
        )); ?>
    <?php endif; ?>
    </div>
    </div>
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
    var keyword= "<?php echo $keyword ?>";
    //var country_id= "<?php echo $country_id ?>";
    var city_id= "<?php echo $city_id ?>";
    
    var level= "<?php echo $level ?>";
    var language= "<?php echo $language ?>";
    var degree= "<?php echo $degree ?>";
    var industry= "<?php echo $industry ?>";
    $('search_resume').set('value', keyword);
    var no_req= "<?php echo $no_req ?>";
    var temp_country_id= country_id =230;
    if(no_req !=1){
    //jQuery('#country_id option').each(function(){
       //if(country_id==jQuery(this).val()){
        //jQuery(this).attr('selected', 'selected');
        
       //}
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
                if(temp_country_id==230 && city_id==0){
                   
      		        jQuery('#city_id').prepend("<option value='0'><?php echo $this->translate('All city')?></option>");
      		    }
                
            	jQuery('#city_id option').each(function(){
                    if(city_id==jQuery(this).val()){
                        jQuery(this).attr('selected', 'selected');
                    } 
             }); 	
            }
        }).send();
       
    //});
    
    jQuery('#level option').each(function(){
       if(level==jQuery(this).val()){
        jQuery(this).attr('selected', 'selected');
       } 
    });
    //jQuery('#language option').each(function(){
       //if(language==jQuery(this).val()){
        //jQuery(this).attr('selected', 'selected');
       //} 
    //});
    //jQuery('#degree option').each(function(){
       //if(degree==jQuery(this).val()){
        //jQuery(this).attr('selected', 'selected');
       //} 
    //});
    jQuery('#industry option').each(function(){
       if(industry==jQuery(this).val()){
        jQuery(this).attr('selected', 'selected');
       } 
    });
    }
    else{
        var str= "<?php echo $this->translate('Enter resume title,')?>";
        $('search_resume').set('value', str);
    }
});
</script>