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
	var default_key_word = "<?php echo $this->translate('Enter text'); ?>";
	if(key_word == default_key_word){
		key_word = "";
	}
        var cats = jQuery("#expert_category").val();
        url = url + "/keyword/" + key_word + "/cats/" + cats;
        window.location.href = url;
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
								<span class="wd-adap-icon-select"></span>
								<select id="expert_category">
									<option value="0"><?php echo $this->translate('Select category'); ?></option>
									<?php foreach($this->categories as $item): ?>
									<option value="<?php echo $item->category_id; ?>"><?php echo $item->category_name; ?></option>
									<?php endforeach; ?>
								</select>
							</div>
							
						</li>
						
						<li class="last">
							<button type="button" title="" id="search_experts" class="bt_expert"><span></span>Tìm kiếm ngay</button>
						</li>
					</ul>
				</fieldset>
			</form>
	</div>
</div>
