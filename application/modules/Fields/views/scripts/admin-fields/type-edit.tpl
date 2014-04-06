<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Fields
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: type-edit.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>
<?php if( $this->form ): ?>

  <?php echo $this->form->render($this) ?>

<?php else: ?>

  <div class="global_form_popup_message">
    <?php echo $this->translate("Your changes have been saved.") ?>
  </div>

  <script type="text/javascript">
    (function() {
      parent.onTypeEdit(
        <?php echo Zend_Json::encode($this->option) ?>
      );
      parent.Smoothbox.close();
    }).delay(1000);
  </script>

<?php endif; ?>