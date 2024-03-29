<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: action.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John Boehr <j@weblego.com>
 */
?>

<?php echo $this->form->setAttrib('class', 'global_form_popup')->render($this) ?>

<?php if( @$this->closeSmoothbox ): ?>
  <script type="text/javascript">
    parent.Smoothbox.close();
  </script>
<?php endif; ?>
