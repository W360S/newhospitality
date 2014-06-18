<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: fields.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     Sami
 */
?>

<?php
  /* Include the common user-end field switching javascript */
  echo $this->partial('_jsSwitch.tpl', 'fields', array('topLevelId' => 0))
?>

<?php echo $this->form->render($this) ?>
