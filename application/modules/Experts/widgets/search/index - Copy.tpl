<style>
.subsection{
    overflow:visible !important;
}
.filter .input select {
    float: left !important;
}
.panel #widget_searchs {
        height: auto !important;
}
</style>
<script type="text/javascript">
  
 window.addEvent('domready',function(){
    var input_text= "<?php echo Zend_Controller_Front::getInstance()->getRequest()->keyword;?>";
   
    if(input_text.length >0){
        $('search_keyword').set('value', input_text);
    }


    jQuery('#search_experts_apply_btn').click(function() {
        var url = "<?php echo $this->baseUrl().'/experts/search/index/typesearch/'; ?>";
        var type_search = jQuery("#search_expert_option").val();
        var key_word = jQuery("#search_keyword").val();
        var cats = jQuery("input[name='expertcategory']:checked");
        var str_cats = "";
        var cnt = 1;
        if(key_word == "Enter text"){
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
        
        url = url + type_search + "/keyword/" + key_word + "/cats/" + str_cats;
        window.location.href = url;
        //jQuery("#widget_searchs").slideToggle();
        jQuery("#widget_searchs").hide();
    });

    jQuery('#search_experts').click(function() {
        var url = "<?php echo $this->baseUrl().'/experts/search/index/typesearch/'; ?>";
        var type_search = jQuery("#search_expert_option").val();
        var key_word = jQuery("#search_keyword").val();
        var cats = jQuery("input[name='expertcategory']:checked");
        var str_cats = "";
        var cnt = 1;
        if(key_word == "Enter text"){
            key_word = "";
        }
        
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

        jQuery("#search_trigger").html("");
        jQuery("#search_trigger").html(str_title_cats);
        
        url = url + type_search + "/keyword/" + key_word + "/cats/" + str_cats;
        window.location.href = url;
        //jQuery("#widget_searchs").slideToggle();
        jQuery("#widget_searchs").hide();
        
    });
    
    jQuery('#search_trigger').bind('click', function(){
        jQuery(this).siblings('#widget_searchs').slideToggle();
    });
    
 });
</script>
<div class="subcontent">
	<fieldset class="filter">
		<div class="input">
			<input id="search_keyword" type="text"onblur="if(this.value=='') this.value='Enter text'"
								onfocus="if(this.value=='Enter text') this.value='';" 
								value="<?php echo $this->translate('Enter text'); ?>"
                                onkeypress ="return submitenter(this,event)"
                                 />								
		</div>
		<div class="input select_sort">
			<div class="panel">
				<div class="trigger" id="search_trigger"><?php echo $this->translate('All category'); ?></div>
				<div class="content" id="widget_searchs">
					<?php if(count($this->categories)): ?>
						<input style="margin-bottom: 10px;" type="button" id="search_experts_apply_btn" class="bt_send_question" value="<?php echo $this->translate('Apply') ?>">
						<?php foreach( $this->categories as $item ): ?>
							<div class="s-input">
						<?php if(in_array($item->category_id, $this->arr_cats)){?>
						<input type="checkbox" name="expertcategory" checked="checked" value="<?php echo $item->category_id;  ?>" title="<?php echo $item->category_name; ?>" />
								
						<?php } else {?>
						<input type="checkbox" name="expertcategory" value="<?php echo $item->category_id;  ?>" title="<?php echo $item->category_name; ?>"/>
						<?php }?>

						<label><?php echo $item->category_name; ?></label>
						</div>
						<?php endforeach; ?>
					<?php endif; ?>
				</div>
			</div>
            <select id="search_expert_option">
            <?php if($this->typesearch==="1"){?>
                <option selected value="1"><?php echo $this->translate("Questions"); ?></option>
                <option value="2"><?php echo $this->translate("Experts"); ?></option>
                
            
            <?php } else if($this->typesearch==="2"){ ?>
                <option value="1"><?php echo $this->translate("Questions"); ?></option>
                <option selected value="2"><?php echo $this->translate("Experts"); ?></option>
                
            <?php } else{?>
               <option value="1"><?php echo $this->translate("Questions"); ?></option>
               <option value="2"><?php echo $this->translate("Experts"); ?></option>
             
            <?php }?>
              
            </select>
			<input id="search_experts" class="button bt_expert" type="button" value="<?php echo $this->translate('Search'); ?>" />
		</div>
	</fieldset>
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
        var url = "<?php echo $this->baseUrl().'/experts/search/index/typesearch/'; ?>";
        var type_search = jQuery("#search_expert_option").val();
        var key_word = jQuery("#search_keyword").val();
        var cats = jQuery("input[name='expertcategory']:checked");
        var str_cats = "";
        var cnt = 1;
        if(key_word == "Enter text"){
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
        
        url = url + type_search + "/keyword/" + key_word + "/cats/" + str_cats;
        window.location.href = url;
        //jQuery("#widget_searchs").slideToggle();
        jQuery("#widget_searchs").hide();
        return false;
       }
    else
       return true;
    }
</script>
