<form method="get" action="<?php echo $this->url(); ?>" enctype="application/x-www-form-urlencoded" id="search_form">

<ul class="list_category">
    <?php foreach($this->data as $item): ?>
	<li ><a cat="<?php echo $item['category_id'];  ?>" class="event_category <?php if($this->category_id == $item['category_id'] ){echo "category_selected";}  ?>" href="javascript:void(0)"><?php echo $item['title']; ?>(<span><?php echo $item['cnt_group']; ?></span>)</a></li>
    <?php endforeach; ?>
</ul>
<input type="hidden" name="category_id" id="category_id" value=""/>

</form>

<script type="text/javascript">
 window.addEvent('domready',function(){
    
    jQuery('.event_category').click(function() {
            var cat_id = jQuery(this).attr('cat');
            jQuery('#category_id').val(cat_id);
            jQuery('#search_form').submit();
    });
    
 });
</script>