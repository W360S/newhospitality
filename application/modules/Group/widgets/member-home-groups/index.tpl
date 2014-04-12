<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: index.tpl 7250 2010-09-01 07:42:35Z john $
 * @author		 John
 */
?>
<div class="pt-menu-left">
<h3>Nhóm</h3>
  <ul>
  <?php foreach( $this->paginator as $group ): ?>
    <li>
      <a href="<?php echo $group->getHref() ?>"><span class="pt-icon-menu-left pt-icon-menu-05"></span><span class="pt-menu-text">
      <?php echo $group->getTitle()?>
      </span><span class="pt-number"><?php echo $group->member_count ?></span></a>
      <!-- <?php //echo $this->htmlLink($group, $this->itemPhoto($group, 'thumb.normal')) ?> -->
    </li>
    <?php endforeach; ?>
  </ul>
</div>
