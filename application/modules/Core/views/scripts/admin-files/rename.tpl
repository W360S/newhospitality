<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: rename.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>
<?php if( !$this->status ): ?>
  <?php echo $this->form->render($this) ?>
<?php else: ?>
  <?php echo $this->translate('Renamed') ?>
  <script type="text/javascript">
    var fileindex = '<?php echo sprintf('%d', $this->fileIndex) ?>';
    var newName = '<?php echo sprintf('%s', $this->fileName) ?>';
    setTimeout(function() {
      //parent.$('admin_file_' + fileindex).getElement('.admin_file_name').set('html', newName);
      parent.window.location.replace( parent.window.location.href );
      parent.Smoothbox.close();
    }, 1000);
  </script>
<?php endif; ?>