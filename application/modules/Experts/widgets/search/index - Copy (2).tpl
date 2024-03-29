<style>

.panel #widget_searchs {
    height: auto !important;
}
.pt-content-searching ul li.last {padding-left: 190px !important;}
</style>
<script src="<?php echo $this->baseUrl().'/application/modules/Experts/externals/scripts/custom.expert.js'?>" type="text/javascript"></script>
<script type="text/javascript">    
jQuery.noConflict();
</script>
<script type="text/javascript">
  
 window.addEvent('domready',function(){
 jQuery("#widget_searchs").show();
    var input_text= "<?php echo Zend_Controller_Front::getInstance()->getRequest()->keyword;?>";
  
    if(input_text.length >0){
        $('search_keyword').set('value', input_text);
    }


    

    jQuery('#search_experts').click(function() {
        var url = "<?php echo $this->baseUrl().'/experts/search/index'; ?>";
        var key_word = jQuery("#search_keyword").val();
        var cats = jQuery("input[name='expertcategory']:checked");
        var str_cats = "";
        var cnt = 1;
        if(key_word == "Nhập từ khóa"){
            key_word = "";
        }
        
        jQuery.each(cats, function() {
          if(cnt < cats.length) {
            str_cats += jQuery(this).val()+",";
            cnt ++;
          } else {
            str_cats += jQuery(this).val();
          }
        });
        
        url = url + "/keyword/" + key_word + "/cats/" + str_cats;
        window.location.href = url;
        jQuery("#widget_searchs").hide();
        
    });
    
    jQuery('#widget_searchs').hide();
    jQuery('#search_trigger').bind('click', function(){
        jQuery(this).siblings('#widget_searchs').slideToggle();
    });
    
 });
</script>
<div id="tabs-1" class="pt-content-tab">
	<div class="pt-content-searching">
			<form method="post" accept-charset="utf-8">
				<fieldset>
					<ul>
						<li>
							<input type="text" name="name" id="search_keyword" type="text"onblur="if(this.value=='') this.value='Enter text'"
								onfocus="if(this.value=='Enter text') this.value='';" 
								value="<?php echo $this->translate('Enter text'); ?>"
								onkeypress ="return submitenter(this,event)"/>
						</li>
						<li>
							
								<div class="input select_sort">
								<div class="panel">
									<div class="trigger" id="search_trigger"><?php echo $this->translate('Chọn danh mục'); ?></div>
									<div class="content" id="widget_searchs">
										<?php if(count($this->categories)): ?>
										
											<?php foreach( $this->categories as $item ): ?>
											<div class="s-input">
												<?php if(in_array($item->category_id, $this->arr_cats)){?>
												<input class="search_select_cat" type="checkbox" name="expertcategory" checked="checked" value="<?php echo $item->category_id;  ?>" title="<?php echo $item->category_name; ?>" />
														
												<?php } else {?>
												<input class="search_select_cat" type="checkbox" name="expertcategory" value="<?php echo $item->category_id;  ?>" title="<?php echo $item->category_name; ?>"/>
												<?php }?>

												<label><?php echo $item->category_name; ?></label>
											</div>
											<?php endforeach; ?>
										<?php endif; ?>
									</div>
								</div>
								</div>
							
						</li>
						
						<li class="last">
							<button type="button" title="" id="search_experts" class="button bt_expert"><span></span>Tìm kiếm ngay</button>
						</li>
					</ul>
				</fieldset>
			</form>
	</div>
</div>
