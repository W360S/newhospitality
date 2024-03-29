<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Activity
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<?php
  $this->form->setTitle('Activity Feed Settings');
  $this->form->setDescription($this->translate('ACTIVITY_FORM_ADMIN_SETTINGS_GENERAL_DESCRIPTION',
      $this->url(array('module' => 'activity','controller' => 'settings', 'action' => 'types'), 'admin_default')));
  $this->form->getDecorator('Description')->setOption('escape', false);
?>
<div class='settings'>
<?php echo $this->form->render($this); ?>
</div>