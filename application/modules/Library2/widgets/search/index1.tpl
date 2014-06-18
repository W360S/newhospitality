<style>

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
    jQuery('#search_book').click(function() {
        jQuery("#widget_searchs").hide();
        var url = "<?php echo $this->baseUrl().'/library/index/index/'; ?>";
        var order = jQuery("#search_book_option").val();
        var key_word = jQuery("#search_keyword").val();
        var cats = jQuery("input[name='bookcategory']:checked");
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
        
        url = url + "cat_id/" + str_cats + "/keyword/" + key_word + "/order/" + order ;
        window.location.href = url;
        
    });
    
    jQuery('#widget_searchs').hide();
    jQuery('#trigger_library_searchs').bind('click', function(){
        jQuery(this).siblings('#widget_searchs').slideToggle();
	
    });
 });
</script>
<div class="pt-content-searching">
<form method="post" accept-charset="utf-8">
	<fieldset>
		<ul>
			<li>
				<div class="input">
					<input id="search_keyword" type="text" onblur="if(this.value=='') this.value='<?php echo $this->translate("Enter text")?>'"
										onfocus="if(this.value=='<?php echo $this->translate("Enter text")?>') this.value='';" 
						value="<?php echo $this->translate("Enter text")?>"
						onkeypress ="return submitenter(this,event)"
					/>						
				</div>
			</li>
			<li>
				<div class="input select_sort">
					<div class="panel">
						<div class="trigger" id="trigger_library_searchs"><?php echo $this->translate("All category")?></div>
						<div class="content" id="widget_searchs">
							<?php if(count($this->categories)): ?>
							<?php foreach( $this->categories as $item ): ?>
							<div class="s-input">
								<?php if(in_array($item->category_id, $this->arr_cats)){?>
								<input type="checkbox" name="bookcategory" checked="checked" value="<?php echo $item->category_id;  ?>" />
										
								<?php } else {?>
								<input type="checkbox" name="bookcategory" value="<?php echo $item->category_id;  ?>" />
								<?php }?>
								<label><?php echo $item->name; ?></label>
							</div>
							<?php endforeach; ?>
							<?php endif; ?>
						</div>
						
					</div>
				</div>
			</li>
			<li>	
				<label style="padding-left: 10px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<select style="height:35px !important;" id="search_book_option">
				<?php if($this->order==="download"){?>
				<option selected value="download"><?php echo $this->translate("Download"); ?></option>
				<option value="view"><?php echo $this->translate("View"); ?></option>
				<option value="created"><?php echo $this->translate("Newest"); ?></option>

				<?php } else if($this->order==="view"){ ?>
				<option value="download"><?php echo $this->translate("Download"); ?></option>
				<option selected value="view"><?php echo $this->translate("View"); ?></option>
				<option value="created"><?php echo $this->translate("Newest"); ?></option>

				<?php } else if($this->order==="created"){?>
				<option value="download"><?php echo $this->translate("Download"); ?></option>
				<option value="view"><?php echo $this->translate("View"); ?></option>
				<option selected value="created"><?php echo $this->translate("Newest"); ?></option>

				<?php } else{?>
				<option value="download"><?php echo $this->translate("Download"); ?></option>
				<option value="view"><?php echo $this->translate("View"); ?></option>
				<option value="created"><?php echo $this->translate("Newest"); ?></option>

				<?php }?>

				</select>
			</li>
			<li class="last">
				<button style="cursor:pointer;" id="search_book" class="button bt_expert" type="button" value="<?php echo $this->translate('Search')?>" ><span></span>Tìm kiếm ngay</button>
			</li>
			
		</ul>
	</fieldset>
</form>
</div>