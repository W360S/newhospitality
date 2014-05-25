<?php
/**
* SocialEngine
*
* @category   Application_Extensions
* @package    Event
* @copyright  Copyright 2006-2010 Webligo Developments
* @license    http://www.socialengine.net/license/
* @version    $Id: index.tpl 7244 2010-09-01 01:49:53Z john $
* @access	   John
*/
?>
<?php $eventFeture = $this->eventFeture; ?>
<div class="pt-block">
<h3 class="pt-title-right"><?php echo $this->translate('Upcoming Events');?></h3>
    <ul>
        <?php foreach( $eventFeture as $item ): ?>
        <li class="Tips1" title="<?php echo $item['title'];?>" rel="<?php echo $this->translate('Start:'). date('F d, Y',strtotime($item['starttime'])).'<br />'. $this->translate('End: ').date('F d, Y',strtotime($item['endtime'])).'<br />'.$this->translate('Place: '). $item['location'].'<br />'.$this->translate('Organized by: ').$item['host'].'<br />'.$this->translate('Post by: ').$this->user($item['user_id'])->displayname;?>">
            <div class="pt-user-post">
                <a href="<?php echo $this->baseUrl() . '/event/'.$item['event_id']; ?>"><span class="pt-avatar"><img alt="Image" src="<?php echo $this->baseUrl(); ?>/<?php echo $item['img_url']; ?>"></span></a>
                <div class="pt-how-info-user-post">
                    <h3><a href="<?php echo $this->baseUrl() . '/event/'.$item['event_id']; ?>"><?php echo $this->substring($item['title'],30);?></a></h3>
                    <p>
                        <?php //echo $item['starttime']; ?> 
                        <?php echo $this->timestamp($item['starttime'], array("notag"=> 1)) ?> - Hà Nội
                    </p>
                </div>
            </div>
        </li>
        <?php endforeach; ?>
    </ul>
</div>
<script type="text/javascript">
    // window.addEvent('domready', function(){
    //     var Tips1 = new Tips($$('.Tips1'));
    // });
</script>

