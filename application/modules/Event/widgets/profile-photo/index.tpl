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
<style type="text/css">
ul.thumbs {
	-moz-border-radius: 3px;
}
div .event_album_options .buttonlink {
	float: none;
}
</style>
<div id='event_photo'>
  <?php echo $this->itemPhoto($this->subject(), 'thumb.profile') ?>
</div>