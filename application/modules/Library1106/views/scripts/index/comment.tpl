<?php
 $paginator = $this->paginator;
 $pagination_control = $this->paginationControl($this->paginator);
 if( $paginator->getTotalItemCount() ): ?>
<table cellspacing="0" cellpadding="0" border="0">
    <?php foreach ($paginator as $item): ?>
	<tr>
		<td class="box_comment">
			<div class="frame_img">
				<?php if(!empty($item->photo)): ?>
				    <img src="<?php echo $this->baseUrl('/'). 'application/modules/Core/externals/images/avatar_no_img.png'; ?>" />
                <?php else: ?>
                    <?php echo $this->itemPhoto($item, 'thumb.normal', "Image"); ?>
                <?php endif; ?>
			</div>
			<div class="content_comment">
				<p><?php echo $item->content; ?></p>
				<p><em><?php echo $this->translate('Post at'); ?>: <?php echo $item->created_date; ?></em></p>
			</div>
		</td>
	</tr>
    <?php endforeach; ?>
</table>
<div>
  <?php echo $pagination_control; ?>
</div>
<?php else: ?>
    <?php echo "Haven't any comments"; ?>
<?php endif; ?>
 <script type="text/javascript">
window.addEvent('domready',function(){
    jQuery('#ajax_comment .paginationControl a').click(function(){
        //var url = '/viethospitality/library/index/view/book_id/25/page/2';
        var url = jQuery(this).attr('href');
        if(url != '#')
        {
            var url = url.replace('view','comment');
            //alert(url);
            jQuery("#ajax_comment").html("<?php echo $this->translate('Loading...'); ?>");
            jQuery.get(url,function(data){
               jQuery("#ajax_comment").html(data);      
            });    
        }          
        return false;  
    });
});                           
</script>