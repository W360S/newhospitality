<style>
.subsection{
    overflow:visible !important;
}
</style>
<script type="text/javascript">
  
 window.addEvent('domready',function(){
    var input_text= "<?php echo Zend_Controller_Front::getInstance()->getRequest()->keyword;?>";
   
    if(input_text.length >0){
        $('search_keyword').set('value', input_text);
    }
    jQuery("#widget_searchs").hide();
    jQuery('.select_sort .panel .trigger,.panel_form .trigger').bind('click', function(){
        jQuery(this).siblings('.content').slideToggle();
    });
    jQuery('#search_question').click(function() {
        jQuery("#widget_searchs").hide();
        var url = "<?php echo $this->baseUrl().'/admin/experts/manage-experts/index/'; ?>";
        var order = jQuery("#search_experts_option").val();
        var key_word = jQuery("#search_keyword").val();
        var cats = jQuery("input[name='expertscategory']:checked");
        var str_cats = "";
        var cnt = 1;
        if(key_word.trim() == "" || (key_word == "Enter text")){
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
        
        url = url + "cat_id/" + str_cats + "/keyword/" + key_word +  "/order/" + order ;
        window.location.href = url;
        
    });
    
 });
</script>
<div class="subcontent">
	<fieldset class="filter">
		<div class="input">
			<input id="search_keyword" type="text"onblur="if(this.value=='') this.value='Enter text'"
								onfocus="if(this.value=='Enter text') this.value='';" 
								value='Enter text' 
                                onkeypress ="return submitenter(this,event)"
                                />						
		</div>
		<div class="input select_sort">
			<div class="panel">
				<div class="trigger">All category</div>
				<div class="content" id="widget_searchs">
					<?php if(count($this->categories)): ?>
                    <?php foreach( $this->categories as $item ): ?>
        			<div class="s-input" style="width:138px">
        				
                        <?php if(in_array($item->category_id, $this->arr_cats)){?>
                        <input type="checkbox" name="expertscategory" checked="checked" value="<?php echo $item->category_id;  ?>" />
        				
                    <?php } else {?>
                        <input type="checkbox" name="expertscategory" value="<?php echo $item->category_id;  ?>" />
                    <?php }?>
                        <label style="width:108px"><?php echo $item->category_name; ?></label>
        			</div>
        			<?php endforeach; ?>
                    <?php endif; ?>
				</div>
			</div>
            
            Order by
            <select id="search_experts_option">
            <?php if($this->order==="question"){?>
                <option selected value="question"><?php echo $this->translate("Questions"); ?></option>
                <option value="answered"><?php echo $this->translate('Answered'); ?></option>
                <option value="created"><?php echo $this->translate('Created date'); ?></option>
            
            <?php } else if($this->order==="answered"){ ?>
                <option value="question"><?php echo $this->translate("Questions"); ?></option>
                <option selected value="answered"><?php echo $this->translate('Answered'); ?></option>
                <option value="created"><?php echo $this->translate('Created date'); ?></option>
            
            <?php } else if($this->order==="created"){?>
                <option value="question"><?php echo $this->translate("Questions"); ?></option>
                <option value="answered"><?php echo $this->translate('Answered'); ?></option>
                <option selected value="created"><?php echo $this->translate('Created date'); ?></option>
            
            <?php } else{?>
               <option value="question"><?php echo $this->translate('Question'); ?></option>
               <option value="answered"><?php echo $this->translate('Answered'); ?></option>
               <option value="created"><?php echo $this->translate('Created date'); ?></option>
            <?php }?>
              
            </select>
			<input id="search_question" class="button bt_expert" type="button" value="<?php echo $this->translate('Search'); ?>" />
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
        jQuery("#widget_searchs").hide();
        var url = "<?php echo $this->baseUrl().'/admin/experts/manage-experts/index/'; ?>";
        var order = jQuery("#search_experts_option").val();
        var key_word = jQuery("#search_keyword").val();
        var cats = jQuery("input[name='expertscategory']:checked");
        var str_cats = "";
        var cnt = 1;
        if(key_word.trim() == "" || (key_word == "Enter text")){
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
        
        url = url + "cat_id/" + str_cats + "/keyword/" + key_word +  "/order/" + order ;
        window.location.href = url;
        return false;
       }
    else
       return true;
    }
</script>