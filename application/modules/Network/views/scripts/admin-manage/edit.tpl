<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Network
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: edit.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     Sami
 * @author     John
 */
?>

<?php echo $this->partial('_formAdminJs.tpl', array('form' => $this->form)) ?>

<div class="settings">
  <?php echo $this->form->render($this) ?>
</div>
