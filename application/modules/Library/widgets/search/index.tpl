<style>
div.wd-adap-select {width: 134px !important;}
</style>
<script type="text/javascript">
 window.addEvent('domready',function(){
 
    var input_text= "<?php echo Zend_Controller_Front::getInstance()->getRequest()->keyword;?>";
  
    if(input_text.length >0){
        $('search_keyword').set('value', input_text);
    }

    jQuery('#search_book').click(function() {
        var url = "<?php echo $this->baseUrl().'/library/index/index'; ?>";
        var key_word = jQuery("#search_keyword").val();
	var default_key_word = "<?php echo $this->translate('Enter text'); ?>";
	if(key_word == default_key_word){
		key_word = "";
	}
        var cats = jQuery("#library_category").val();
	 var order = jQuery("#search_book_option").val();
        url = url + "/keyword/" + key_word + "/cats/" + cats+ "/order/" + order ;
        window.location.href = url;
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
				<div class="wd-adap-select">
					<span class="wd-adap-icon-select"></span>
					<select id="library_category">
						<option value="0"><?php echo $this->translate('Select category'); ?></option>
						<?php foreach($this->categories as $item): ?>
						<option value="<?php echo $item->category_id; ?>"><?php echo $item->name; ?></option>
						<?php endforeach; ?>
					</select>
				</div>
			</li>
			<li>	
				<div class="wd-adap-select">
					<span class="wd-adap-icon-select"></span>
				<select id="search_book_option">
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
				</div>
			</li>
			<li class="last">
				<button style="cursor:pointer;" id="search_book" class="button bt_expert" type="button" value="<?php echo $this->translate('Search')?>" ><span></span>Tìm kiếm ngay</button>
			</li>
			
		</ul>
	</fieldset>
</form>
</div>