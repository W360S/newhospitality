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
<h2><?php echo $this->translate('featured experts'); ?></h2>
<div class="subcontent category_expert">
	<div class="select_sort">
		<div class="panel" id="wg_cats">
			<div class="trigger" id="trigger_featured_experts" ><?php echo $this->translate('All category'); ?></div>
            <div class="content" id="widget_experts">
                <?php if(count($this->categories)): ?>
                <input style="margin-bottom: 10px;" type="button" id="search_featured_experts" class="bt_send_question" value="<?php echo $this->translate('Apply') ?>">
                <br />
                <?php foreach( $this->categories as $item ): ?>
				<div class="s-input">
					<input type="checkbox" name="expertcategory" value="<?php echo $item->category_id;  ?>" title="<?php echo $item->category_name; ?>"/>
					<label><?php echo $item->category_name; ?></label>
				</div>
				<?php endforeach; ?>
                <?php endif; ?>
                
			</div>
            
		</div>
	</div>
    <div class="featured-groups-wrapper" id="featured-experts">
        <div class="featured-groups" >
        <?php 
            $n= count($this->list_experts); 
        if($n): 
        ?>
            <ul>
            <?php $dem = 0;  foreach($this->list_experts as $item): $dem++;  ?>
            <?php  if((($dem-1) %5 == 0) && (($dem - 1) > 1)): ?>
            </ul>
            <ul>
            <?php endif; ?>
                <li>
                    <?php if($item->photo_id): ?>
                        <?php echo $this->itemPhoto($item, 'thumb.normal', "Image"); ?>
                    <?php else: ?>
                         <img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_icon.png">
                    <?php endif; ?>
                    
                    <h3><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'profile','username'=>$item->username), 'default', true) ?>"><?php echo $item->displayname; ?></a></h3>
                    <div>
						<em>in <?php echo $item->company; ?></em>
                        <p><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$item->user_id)); ?>"><?php  echo $this->translate(array('%s Answer', '%s Answers', intval($item->answered)), intval($item->answered)) ?></a></p>
                        <p><?php  echo $this->translate(array('%s Year experience', '%s Years experience', intval($item->experience)), intval($item->experience)) ?></p>
					</div>
                </li>
            <?php endforeach; ?>    
            </ul>
          <?php else: ?>
            <div class="not-found-expert"><p><?php echo $this->translate("Haven't found any experts."); ?></p></div>
          <?php endif; ?>
        </div>
       
    </div>
    <br />
</div>