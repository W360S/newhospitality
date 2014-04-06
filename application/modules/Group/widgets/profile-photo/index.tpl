<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7244 2010-09-01 01:49:53Z john $
 * @author		 John
 */
?>
<style type="text/css">
    ul.thumbs {
        /*
    	-moz-border-radius:3px 3px 3px 3px;
    	border: 1px solid #D0E2EC;
    	padding:10px;
        */
    
    }
    div .group_album_options .buttonlink{
    	float: none;
    }
    .layout_group_profile_photos{
    	border:1px solid #D0E2EC;
    	background-color:#F2FAFF;
    	padding:10px;
    	-moz-border-radius: 0px 3px 3px 3px;  
    	position:relative;
    }
</style>
<div id='group_photo' >
  <?php echo $this->itemPhoto($this->subject(), 'thumb.profile') ?>
</div>