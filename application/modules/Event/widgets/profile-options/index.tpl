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
 <style>
 	.post_topic .buttonlink {height:16px;line-height:16px}
    div .buttonlink {
        float:none;
    }
     div .profile_options{
        margin-top:10px;
    }
	div .profile_options .buttonlink {
        margin-left:10px;
    }
</style>

<div class="profile_options subsection"> 
    <h2>
      <?php echo $this->translate('Event Options') ?>
    </h2>
	<div id='profile_options'>
	  <?php // This is rendered by application/modules/core/views/scripts/_navIcons.tpl
	    echo $this->navigation()
	      ->menu()
	      ->setContainer($this->navigation)
	      ->setPartial(array('_navIcons.tpl', 'core'))
	      ->render()
	  ?>
	</div>
</div>