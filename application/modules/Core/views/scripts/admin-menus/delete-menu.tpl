<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: delete-menu.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<?php if( $this->form ): ?>

  <?php echo $this->form->setAttrib('class', 'global_form_popup')->render($this) ?>

<?php else: ?>

  <div><?php echo $this->translate("Deleted") ?></div>

  <script type="text/javascript">
    setTimeout(function() {
      parent.window.location.href = '<?php echo $this->url(array('action' => 'index', 'name' => null)) ?>';
      parent.Smoothbox.close();
    }, 500);
  </script>

<?php endif; ?>