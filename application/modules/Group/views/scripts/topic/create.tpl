<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: create.tpl 7244 2010-09-01 01:49:53Z john $
 * @author	   John
 */
?>
<style type="text/css">
.global_form > div {
	padding: 9px 0px;
}
</style>
<div class="content">
    <div class="layout_right">
        <div class="subsection">
            <h2>Featured groups</h2>
            <div class="subcontent">
                <div class="featured-groups-wrapper">
                     <?php  
                     $group= $this->group;
                     $form= $this->form;
                     echo $this->content()->renderWidget('group.featured'); ?>
                     
                </div>
            </div>
        </div>
    </div>
    <div class='layout_middle'> 
        <div class="headline">
        <h2>
          <?php echo $group->__toString() ?>
          <?php echo $this->translate('&#187; Discussions');?>
        </h2>
        </div>
        <?php echo $form->render($this) ?>
    </div>
</div>