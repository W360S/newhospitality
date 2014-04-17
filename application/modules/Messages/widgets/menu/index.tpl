<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Messages
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John Boehr <j@weblego.com>
 */
?>
<?php /*
<div class="headline">
  <h2>
    <?php //echo $this->translate('My Messages') ?>
  </h2>
  <div class="tabs">
    <?php
      // Render the menu
      echo $this->navigation()
        ->menu()
        ->setContainer($this->navigation)
        ->render();
    ?>
  </div>
</div>
*/ ?>
<ul class="pt-menu-event">
  <li class="active">
    <a href="<?php echo $this->baseUrl(); ?>/messages/inbox">Hộp thư đến</a>
  </li>
  <li>
    <a href="<?php echo $this->baseUrl(); ?>/messages/outbox">Thư đã gửi</a>
  </li>
</ul>
<a href="<?php echo $this->baseUrl(); ?>/messages/compose" class="pt-registering-event"><span></span>Soạn Thư Mới</a>