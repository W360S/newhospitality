<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Install
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: vfs.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<h3>Add Packages</h3>

<?php
  // Navigation
  echo $this->render('_installMenu.tpl')
?>

<br />


<?php if( $this->form ): ?>

  <?php echo $this->form->render($this) ?>

<?php else: ?>

  <form action="<?php echo $this->url() ?>">
    <?php echo $this->formRadio('location', null, array(), $this->paths) ?>
    <br />
    <br />
    <?php echo $this->formButton('submit', 'Select Path', array('type' => 'submit')) ?>

  </form>

<?php endif; ?>