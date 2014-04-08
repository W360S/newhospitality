<div class="featured-groups" >
<?php 
    $n= count($this->data); 

    if($n): 
?>
    <ul>
    <?php $dem = 0;  foreach($this->data as $item): $dem++;  ?>
    <?php  if((($dem-1) %5 == 0) && (($dem - 1) > 1)): ?>
    </ul>
    <ul>
    <?php endif; ?>
        <li>
            <?php if(isset($item->photo_id)): ?>
                <?php echo $this->itemPhoto($item, 'thumb.normal', "Image"); ?>
            <?php else: ?>
                 <img alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/User/externals/images/nophoto_user_thumb_icon.png">
            <?php endif; ?>
            
            <h3><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'profile','username'=>$item->username), 'default', true) ?>"><?php echo $item->displayname; ?></a></h3>
            <div>
				<em>in <?php echo $item->company; ?></em>
                <p><a href="<?php echo $this->url(array('module'=>'experts','controller'=>'index','action'=>'answered-by-experts','user_id'=>$item->user_id)); ?>"><?php  echo $this->translate(array('%s Answer', '%s Answers', intval($item->answered)), intval($item->answered)) ?></a></p>
                <p><?php  echo $this->translate(array('%s Year experience', '%s Years experience', intval($item->experience)), intval($item->experience)) ?></p>
			</div>
        </li>
    <?php endforeach; ?>    
    </ul>
<?php else: ?>
     <div class="not-found-expert"><p><?php echo $this->translate("Not found any experts."); ?></p></div>
<?php endif; ?>
</div>
<script type="text/javascript">
    (function($){
    
        if ($('.featured-groups').children().length > 1){
    		$('.featured-groups')
            .bxSlider()
            .find('a')
                .tooltip()
                .children('img').attr('alt', '');
    	}else{
    		$(".bxslider-wrap a.next,.bxslider-wrap a.prev").click(function(){
    			return false
    		});
    		$('.featured-groups ul li:last-child').css('border-bottom','none')
    	};
    })(jQuery);
    
</script>