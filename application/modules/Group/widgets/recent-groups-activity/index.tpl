<div class="subsection recent-groups">
<h2><?php echo $this->translate('Groups Activities') ?></h2>
<?php //print_r($this->actions) ?>
<ul>
<?php foreach ($this->actions as $key => $action): ?>
    <li>
        <?php echo $this->htmlLink($action->getSubject()->getHref(),
          $this->itemPhoto($action->getSubject(), 'thumb.icon', $action->getSubject()->getTitle())
        ) ?>
        <span class="<?php echo ( empty($action->getTypeInfo()->is_generated) ? 'feed_item_posted' : 'feed_item_generated' ) ?>">
            <?php echo $action->getShortContent() ?>
        </span>    
    </li>
<?php endforeach?>
</ul>
<?php $n= count($this->group1); ?>
<?php if($n): ?>
    <ul>
    <?php $dem = 0;  foreach($this->group1 as $item): $dem++;  ?>
    <?php  if((($dem-1) %8 == 0) && (($dem - 1) > 1)): ?>
    </ul>
    <ul>
    <?php endif; ?>
    	<li class="Tips1" title="<?php echo $item['title'];?>" rel="<?php echo $this->translate('Post by: ').$this->user($item['user_id'])->displayname. '<br />'.$this->translate('Last Update: ').date('F d, Y',strtotime($item['modified_date'])).'<br />'.$this->translate('Views: ').$item['view_count'] ?>" >
            <?php if(!empty($item['img_url'])): ?>
                <img alt="Image" width="57" height="40" src="<?php echo $this->baseUrl(); ?>/<?php echo $item['img_url']; ?>">
            <?php else: ?>
                <img alt="Image" width="57" height="40" src="<?php echo $this->baseUrl(); ?>/application/modules/Group/externals/images/nophoto_group_thumb_normal.png">
            <?php endif; ?>
    	    <h3><a href="<?php echo $this->baseUrl().'/group/'.$item['group_id']; ?>"><?php echo $item['title'];?></a></h3>
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