<script type="text/javascript">
  
 window.addEvent('domready',function(){
    jQuery('#search_featured_experts').click(function() {
        var url = "<?php echo $this->baseUrl().'/experts/ajax-request/selected-experts?cats='; ?>";
        var cats = jQuery("input[name='expertcategory']:checked");
        var str_cats = "";
        var str_title_cats = "";
        var cnt = 1;
        if(cats.length < 1) { 
			//alert("Please select category"); return false;
		} else {
		    jQuery.each(cats, function() {
		      if(cnt < cats.length) {
                str_cats += jQuery(this).val()+",";
                str_title_cats += jQuery(this).attr("title") + ", ";
                cnt ++;
              } else {
                str_cats += jQuery(this).val();
                str_title_cats += jQuery(this).attr("title");
              }
            });
        }
        url = url + str_cats;

        jQuery("#trigger_featured_experts").html("");
        jQuery("#trigger_featured_experts").html(str_title_cats);
       
        jQuery.ajax({
          url: url,
          cache: false,
          success: function(html){
            jQuery("#widget_experts").slideToggle();
            jQuery("#widget_experts").hide();
            jQuery("#featured-experts").html(html);
          }
        });
        
    });
    
    jQuery('#trigger_featured_experts').bind('click', function(){
        jQuery(this).siblings('#widget_experts').slideToggle();
    });
    
 });
</script>
<style type="text/css">
    .panel #widget_experts {
        height: auto !important;
     }
    .generic_layout_container h3 {
        margin-bottom: 0px !important;
    }
    
    .subsection .category_expert {
        min-height: 150px;
    }
    .not-found-expert{
        padding-left: 5px;
        padding-top: 5px;
    }
    .featured-groups-wrapper .bxslider-wrap .next, .featured-groups-wrapper .bxslider-wrap .prev {bottom: -10px;}
    
</style>
<div class="pt-block">
<h3 class="pt-title-right" style="font-size:14px"><?php echo $this->translate('experts of the month'); ?><a style="color:#4FC1E9" href="<?php echo PATH_SERVER_INDEX ?>/experts"><?php echo $this->translate('All'); ?></a></h3>
    
        <?php 
            $n= count($this->list_experts); 
        if($n): 
        ?>
            
            <?php $dem = 0;  foreach($this->list_experts as $item): $dem++;  ?>
            <?php  if((($dem-1) %5 == 0) && (($dem - 1) > 1)): ?>
            
            <ul class="pt-list-right pt-list-right-fix">
            <?php endif; ?>
                <li style="list-style:none">
                <div class="pt-user-post" style="padding:15px 10px">
                    <?php if($item->photo_id): ?><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$item->user_id)); ?>">
                        <?php echo '<span class="pt-avatar" style="float:left;">'.$this->itemPhoto($item, 'thumb.icon', "Image").'</span>'; ?></a>
                    <?php else: ?><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$item->user_id)); ?>">
                         <span class="pt-avatar" style="float:left;"><img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_icon.png"></span></a>
                    <?php endif; ?>
                    <div class="pt-how-info-user-post" style=" float: left;padding-left: 5px;width: 62%;">
	                    <h3><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'profile','username'=>$item->username), 'default', true) ?>"><?php echo $item->displayname; ?></a></h3>
	                    
	                    <p><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$item->user_id)); ?>">Bởi: <?php echo $item->company;  ?></a> - <?php echo date('Y-m-d', strtotime(str_replace('.', '/', $item->creation_date))); ?></p>
	                    <div class="pt-how-add-views">
	                    	<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$item->user_id)); ?>" class="pt-views"><span></span><?php  echo $this->translate(array('%s Answer', '%s Answers', intval($item->answered)), intval($item->answered)) ?></a>
							<a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'profile','username'=>$item->username), 'default', true) ?>" class="pt-commnet"><span></span><?php  echo $this->translate(array('%s Year ex', '%s Years ex', intval($item->experience)), intval($item->experience)) ?></a>
	                       	</div>
					</div>
					<style>
						.pt-link-add{
							border-radius:3px;
							border:1px solid #E5E5E5;
						 	float: right;
						    margin-top: 12px;
						    padding: 3px 5px;
						}
					</style>
					<a class="pt-link-add" href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$item->user_id)); ?>" ><?php echo $this->translate('See'); ?></a>					
				</div>
				
                </li>
            <?php endforeach; ?>    
            </ul>
          <?php else: ?>
            <div class="not-found-expert"><p><?php echo $this->translate("Haven't found any experts."); ?></p></div>
          <?php endif; ?>
    
    <br />
</div>