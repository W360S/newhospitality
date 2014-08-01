<div style="float: left;" class="select_sort">
	<div class="panel" id="panel_compose_experts">
		<div class="trigger" id="trigger_compose_experts"><?php echo $this->translate('Select Experts'); ?></div>
		<div class="content" id="content_compose_experts">
			<?php if(count($this->data)): ?>
            <?php foreach( $this->data as $item ): ?>
			<div class="s-input">
				<input type="checkbox" class="select_experts" name="select_experts" value="<?php echo $item->user_id;?>" id="<?php echo $item->user_id;?>" title="<?php echo $item->displayname; ?>"/>
				<label><?php echo $item->displayname; ?></label>
			</div>
			<?php endforeach; ?>
            <?php endif; ?>
        </div>
	</div>
</div>
<script language="javascript">
jQuery(document).ready(function() {
	jQuery('#content_compose_experts').hide();
    jQuery('#trigger_compose_experts').bind('click', function(){
        jQuery(this).siblings('#content_compose_experts').slideToggle();
    });
     
    jQuery('.select_experts').bind('click', function(){
        var expert_ids = jQuery("input[name='select_experts']:checked");
        var str_expert = "";
        var str_strexpert = "";
        var expert_cnt = 1;
        
        var lastedChecked = jQuery(this).attr('id');
		var countCheck = expert_ids.length;
    	if( countCheck > 3){
    		alert("<?php echo $this->translate('You may choose up to 3 experts.'); ?>");
    		jQuery("#"+lastedChecked).removeAttr("checked");
            expert_ids = jQuery("input[name='select_experts']:checked");
            countCheck = countCheck - 1;
        }
        
        jQuery.each(expert_ids, function() {
          if(expert_cnt < expert_ids.length) {
            str_expert += jQuery(this).val()+",";
            str_strexpert += jQuery(this).attr("title")+",";
            expert_cnt ++;
          } else {
            str_expert += jQuery(this).val();
            str_strexpert += jQuery(this).attr("title");
          }
        });
        jQuery("#check_select_experts").attr("value",str_expert);
        jQuery('#trigger_compose_experts').html(str_strexpert);
    });
    
});
</script>