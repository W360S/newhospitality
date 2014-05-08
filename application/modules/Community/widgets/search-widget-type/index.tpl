<style type="text/css">
.current_type{
	background-color: #EBF6FB;
    font-size : 115%; 
}

</style>
<script type="text/javascript">
    window.addEvent('domready',function(){
    //jQuery(document).ready(function() {
        jQuery('.ajax_search').click(function(){
        	//if(jQuery('.ajax_search').hasClass('current_type')){
				
        	//}
        	jQuery('.current_type').removeClass('current_type'); 
        	jQuery(this).parent().addClass('current_type');
            var selected = jQuery(this).attr('rel');
            jQuery('#type option[value='+ selected +']').attr('selected', 'selected');
            searchMembers();    
            return false;           
        });
    });
</script>
<h2><?php echo $this->translate('Type');?></h2>
<div class="section">
		<ul class="member_info">
            <li class="type_notchange current_type">
              <a class="ajax_search" rel="" href="#">All</a>	
            </li>   
            <?php foreach($this->type as $key => $type) { ?>
    	    <li class="type_notchange">
              <a class="ajax_search" rel="<?php echo $key; ?>" href="#"><?php echo $this->translate($type); ?></a>	
            </li>   
            <?php } ?>         	    
        </ul>        	
</div>