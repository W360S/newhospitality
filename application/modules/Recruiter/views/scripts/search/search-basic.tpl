<?php
    $paginator= $this->paginator; 
    $keyword= $this->keyword;
    $city_id= $this->city_id;
    $industry= $this->industry;
    $category= $this->category;
    //$position= $this->position;
    $country_id= $this->country_id;
    $values= $this->values;
    $no_req= $this->no_req;

    // print_r($paginator);
?>
<div class="pt-list-job">
    <ul class="pt-list-job-ul">
            <?php if( count($paginator)>0 ): ?>
                <?php foreach($paginator as $item): ?>

                    <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
                    
                    <li class="news">
                        <div class="pt-lv1"><span class="pt-fulltime">Full Time</span></div>
                        <div class="pt-lv2">
                            <h3>
                                 <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position, array('target'=>'_blank')) ?>
                            </h3>
                            <span><?php if($this->company($item->user_id)) echo $this->company($item->user_id)->company_name;?></span>
                        </div>
                        <div class="pt-lv3">
                            <p class="pt-address"><span></span><?php echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?></p>
                        </div>
                        <div class="pt-lv4">
                            <div class="pt-user-name">
                                <a href="#" class="pt-avatar"><img src="img/thumb/img-05.jpg" alt="Image"></a>
                                <strong>Đăng bởi:</strong>
                                <p><a href="#">Vinh Bui</a><span>- 2 giờ trước</span></p><p></p>
                            </div>
                        </div>
                    </li>
                    
                <?php endforeach; ?>
            <?php else: ?>
                    There is no results based on your search..
            <?php endif;?>        
    </ul>
    <div class="pt-paging">
        <ul class="pagination-flickr">
            <li class="previous-off">«Previous</li>
            <li class="active">1</li>
            <li><a href="?page=2">2</a></li>
            <li><a href="?page=3">3</a></li>
            <li class="next"><a href="?page=2">Next »</a></li>
        </ul>
    </div>
</div>
<?php /*
<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
div.search_result table td a{color: #028EB9;}
.search_result{padding-top: 0; width: 100%;}
.wd-tab .wd-item li{background-color:#f2f2f2;float:left;font-weight:bolder;margin-right:2px;padding:.5em 1em;}
.wd-tab .wd-item li.wd-current{background-color:#F1F8FC;}
.wd-tab .wd-item li.wd-current a{ color:#009ECF !important;}
.wd-tab .wd-item li a:link, .wd-tab .wd-item li a:visited{color:#000;}
.wd-tab .wd-item li a:hover{color:#c00;}
.wd-tab .wd-item li a{font-size:1.2em; text-transform:uppercase;}
.wd-tab .wd-panel{padding:1em;}
.wd-tab .wd-panel h3, .wd-tab .wd-panel h4, .wd-tab .wd-panel h5, .wd-tab .wd-panel ul, .wd-tab .wd-panel ol, .wd-tab .wd-panel p{margin-bottom:1em;}
.wd-tab .wd-panel h3, .wd-tab .wd-panel h4, .wd-tab .wd-panel h5{font-size:1em;}
.wd-tab .wd-panel ul, .wd-tab .wd-panel ol{margin-left:3em;margin-right:3em;}
.wd-tab .wd-panel li{padding:.1em 0;}
.wd-tab .wd-panel ul{list-style:disc;}
.wd-tab .wd-panel ol{list-style:decimal;}
</style>
<?php
    $paginator= $this->paginator; 
    $keyword= $this->keyword;
    $city_id= $this->city_id;
    $industry= $this->industry;
    $category= $this->category;
    //$position= $this->position;
    $country_id= $this->country_id;
    $values= $this->values;
    $no_req= $this->no_req;
    
?>
<div class="layout_main">
<?php echo $this->content()->renderWidget('recruiter.search-job');?>

<div id="content">
        <div class="section jobs">

            <div class="layout_right">
                <!-- online resume -->
                <?php echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
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
                 <div class="wd-tab">
                	<ul class="wd-item">
                		<li style="border-top-left-radius: 8px;"><a href="#wd-fragment-1"><?php echo $this->translate('Careers')?></a></li>
                		<li style="border-top-left-radius: 8px;"><a href="#wd-fragment-2"><?php echo $this->translate('Industries')?></a></li>
                		
                	</ul>
                	<div style="clear:both;">
                		<div class="wd-section" id="wd-fragment-1">
                			<!--job careers -->
                            <?php echo $this->content()->renderWidget('recruiter.industry-job');?>
                            <!-- end -->
                		</div>
                		<div class="wd-section" id="wd-fragment-2">
                			<?php echo $this->content()->renderWidget('recruiter.categories');?>
                		</div>
                		
                	</div>
                </div>
                
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
                			<td class="align_l">
                                <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position, array('target'=>'_blank')) ?>
                            </td>
                			<td><?php if($this->company($item->user_id)) echo $this->company($item->user_id)->company_name;?></td>
                			<td><?php echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?></td>
                			<td>
                                <?php echo date('d m Y', strtotime($item->creation_date));?>
                                <?php //echo date('d F Y', strtotime($item->creation_date));?>
                            </td>
                		</tr>
                    <?php endforeach; ?>
                    </table>
                    <?php else: ?>
                    <div style="margin-top: 5px; margin-left: 5px;" class="tip">
                        <span>
                          <?php echo $this->translate("No job has been found.") ?>
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
            </div>

            <div class="clear"></div>

        </div>
</div>
<!-- 
<div class="layout_middle">


<?php echo $this->content()->renderWidget('recruiter.industry-job');?>

</div>
-->
</div>
<script type="text/javascript">
window.addEvent('domready', function(){
    var keyword= "<?php echo $keyword ?>";
    //var country_id= "<?php echo $country_id ?>";
    var city_id= "<?php echo $city_id ?>";
    var industry= "<?php echo $industry ?>";
    var category= "<?php echo $category ?>";
    var temp_country_id= country_id = 230;
    if(keyword==''){
        keyword="<?php echo $this->translate('Enter job title, position')?>";
    }
    $('search_job').set('value', keyword);
    var no_req= "<?php echo $no_req ?>";
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
      		        jQuery('#city_id').prepend("<option value='0'><?php echo $this->translate('All city')?> </option>");
      		    }
            	jQuery('#city_id option').each(function(){
                    if(city_id==jQuery(this).val()){
                        jQuery(this).attr('selected', 'selected');
                    } 
             }); 	
            }
        }).send();
       
    //});
    
        jQuery('#industry option').each(function(){
           if(industry==jQuery(this).val()){
            jQuery(this).attr('selected', 'selected');
           } 
        });
        jQuery('#category option').each(function(){
           if(category==jQuery(this).val()){
            jQuery(this).attr('selected', 'selected');
           } 
        });
    }
    else{
        //$('search_job').set('value', 'Enter jobs title, position');
        $('search_job').set('value', keyword);
    }
    jQuery('.wd-tab').each(function(){
    	jQuery(this).find('.wd-section').hide();
    
    	var current = jQuery(this).find('.wd-item').children('.wd-current');
    	if (current.length == 0){
    		jQuery(this).find('.wd-item').children(':first-child').addClass('wd-current');
    		jQuery(jQuery(this).find('.wd-item').children(':first-child').find('a').attr('href')).show();
    	}
    
    	jQuery(this).find('.wd-item').find('a').click(function(){
    		var current = jQuery(this).parent().hasClass('wd-current');
    		if (current == false){
    			jQuery(this).parent()
    				.addClass('wd-current')
    				.siblings().each(function(){
    					jQuery(this).removeClass('wd-current');
    					jQuery(jQuery(this).find('a').attr('href')).hide();
    				});
    			jQuery(jQuery(this).attr('href')).fadeIn();
    		}
    		return false;
    	});
    });
});
</script>
*/ ?>
