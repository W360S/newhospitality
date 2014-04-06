
<div class="featured-groups">
<?php $n= count($this->eventFeture); if($n): ?>
    <ul>
    <?php $dem = 0;  foreach($this->eventFeture as $item): $dem++;  ?>
    <?php  if((($dem-1) %8 == 0) && (($dem - 1) > 1)): ?>
    </ul>
    <ul>
    <?php endif; ?>
    	<li class="Tips1" title="<?php echo $item['title'];?>" rel="<?php echo $this->translate('Start:'). date('F d, Y',strtotime($item['starttime'])).'<br />'. $this->translate('End: ').date('F d, Y',strtotime($item['endtime'])).'<br />'.$this->translate('Place: '). $item['location'].'<br />'.$this->translate('Organized by: ').$item['host'].'<br />'.$this->translate('Post by: ').$this->user($item['user_id'])->displayname;?>">
            <?php if(!empty($item['img_url'])): ?>
                <img alt="Image" src="<?php echo $this->baseUrl(); ?>/<?php echo $item['img_url']; ?>">
            <?php else: ?>
                <img width="57" height="40" alt="Image" src="<?php echo $this->baseUrl(); ?>/application/modules/Event/externals/images/nophoto_event_thumb_normal.png">
            <?php endif; ?>
    	    <h3><a href="<?php echo $this->baseUrl().PATH_SERVER_INDEX.'/event/'.$item['event_id']; ?>"><?php echo $this->substring($item['title'],30);?></a></h3>
    	    <div><?php  echo $this->translate(array('%s member', '%s members', $item['member_count']),$this->locale()->toNumber($item['member_count'])) ?></div>
    	</li>
    <?php endforeach; ?>
    </ul>
<?php endif; ?>    
</div>

<script type="text/javascript">
window.addEvent('domready', function(){
    var Tips1 = new Tips($$('.Tips1'));
});

</script>