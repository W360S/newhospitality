<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: contact.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<?php if( $this->status ): ?>
  <?php echo $this->message; ?>
<?php else: ?>
  <?php echo $this->form->render($this) ?>
<?php endif; ?>