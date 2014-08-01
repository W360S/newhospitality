<style>
.subsection{
    overflow:visible !important;
}
</style>
<script type="text/javascript">
  
 window.addEvent('domready',function(){
    jQuery("#widget_searchs").hide();
    jQuery('.select_sort .panel .trigger,.panel_form .trigger').bind('click', function(){
        jQuery(this).siblings('.content').slideToggle();
    });
    
    jQuery('#search_question').click(function() {
        jQuery("#widget_searchs").hide();
        
        var url = "<?php echo $this->baseUrl().'/admin/experts/manage-experts/view/expert_id/'.intval($this->expert_id); ?>";
        var order = jQuery("#search_question_option").val();
        var status = jQuery("#search_status_question_option").val();
        var key_word = jQuery("#search_keyword").val();
        var cats = jQuery("input[name='questioncategory']:checked");
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
        
        url = url + "/cat_id/" + str_cats + "/keyword/" + key_word + "/status/" + status  + "/order/" + order ;
        window.location.href = url;
        
    });
    
 });
</script>
<div class="subcontent">
	<fieldset class="filter">
		<div class="input">
			<input id="search_keyword" type="text"onblur="if(this.value=='') this.value='Enter text'"
								onfocus="if(this.value=='Enter text') this.value='';" 
								value='Enter text' />								
		</div>
		<div class="input select_sort">
			<div class="panel">
				<div class="trigger">All category</div>
				<div class="content" id="widget_searchs">
					<?php if(count($this->categories)): ?>
                    <?php foreach( $this->categories as $item ): ?>
        			<div class="s-input">
        				<input type="checkbox" name="questioncategory" value="<?php echo $item->category_id;  ?>" />
        				<label><?php echo $item->category_name; ?></label>
        			</div>
        			<?php endforeach; ?>
                    <?php endif; ?>
				</div>
			</div>
            Status
            <select id="search_status_question_option">
              <option value="1"><?php echo $this->translate('Pending'); ?></option>
              <option value="2"><?php echo $this->translate('Answered'); ?></option>
              <option value="3"><?php echo $this->translate('Closed'); ?></option>
              <option value="4"><?php echo $this->translate('Cancelled'); ?></option>
            </select>
            Order by
            <select id="search_question_option">
              <option value="rating"><?php echo $this->translate('Rating'); ?></option>
              <option value="view"><?php echo $this->translate('View'); ?></option>
              <option value="created"><?php echo $this->translate('Created date'); ?></option>
            </select>
			<input id="search_question" class="button bt_expert" type="button" value="<?php echo $this->translate('Search'); ?>" />
		</div>
	</fieldset>
</div>
