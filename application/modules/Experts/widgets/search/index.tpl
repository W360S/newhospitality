<style>
.wd-content-container .wd-center {
	width: 1188px !important;
}
</style>
<style style="text/css">
.wd-content-left { width:204px; float:left; padding-top:20px;}
.panel {float:left;margin-right:3px;position:relative;;margin-top:1px}
/*
.panel .trigger {background:#fff url(~/application/modules/Core/externals/images/arrow-17.gif) right 2px no-repeat;border:1px solid #999;cursor:pointer;height:20px;overflow:hidden;width:148px;padding-left:10px;line-height:22px; border-radius: 3px; -moz-border-radius: 3px; -webkit-border-radius: 3px}
.panel .content {background:#fff url(~/application/modules/Core/externals/images/gradient-1.gif) left bottom repeat-x;border:1px solid #DCDCDC;padding:10px;right:0;top:24px;width:138px;z-index:100; height: 205px; overflow: auto;}
*/
.panel .content .s-input{float:left;margin-bottom:6px;clear:both;}
.panel .content .s-input input{margin:0 3px 0 0;width:auto;border:none;color:#fff;font-size:0px;display:inline-block }
.panel .content .s-input label {font-weight:normal;line-height:15px; float:left;display:inline-block;width:154px}

    
#content_compose_title .s-input label, #content_compose_experts .s-input label{
padding-right:2px;
padding-top: 2px;
text-align:left;
}
.panel #content_compose_title, .panel #content_compose_experts{
width: 268px;
}

#content_compose_title div.s-input{
width: 400px;
}    

#content_compose_title div.s-input label{
width: 340px;
}

.panel #trigger_compose_title, .panel #trigger_compose_experts{
width: 280px;
}
#panel_compose_title{

}

#search_experts_apply_btn{
width: 194px !important;
}
#search_trigger{
text-align: center;
padding-left: 9px;
padding-top: 8px;
height: 25px;
}

.pt-content-searching ul li input#search_keyword {
width: 540px !important;
}
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
        jQuery('search_keyword').set('value', input_text);
    }


    jQuery('#search_experts_apply_btn').click(function() {
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
    
    jQuery('#search_trigger').bind('click', function(){
        jQuery(this).siblings('#widget_searchs').slideToggle();
	//alert(1);
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
							<div class="wd-adap-select">
								<div class="input select_sort">
								<div class="panel">
									<div id="search_trigger"><?php echo $this->translate('Chọn danh mục'); ?></div>
									<div class="content" id="widget_searchs">
										<?php if(count($this->categories)): ?>
											<input style="margin-bottom: 10px;" type="button" id="search_experts_apply_btn" class="bt_send_question" value="<?php echo $this->translate('Chọn và tìm kiếm') ?>">
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
<script type="text/javascript">
function submitenter(myfield,e)
{
    var keycode;
    if (window.event) keycode = window.event.keyCode;
    else if (e) keycode = e.which;
    else return true;
    
    if (keycode == 13)
       {
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
        //jQuery("#widget_searchs").slideToggle();
        jQuery("#widget_searchs").hide();
        return false;
       }
    else
       return true;
    }
</script>