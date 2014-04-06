<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: create.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<style type="text/css">
.layout_middle{
	padding:0px 0px;
}
.global_form > div {
	padding: 9px 0px;
}
</style>
<?php 
	$event= $this->event;
	$form= $this->form;
?>
<div class="content">
<?php echo $this->content()->renderWidget('event.profile-featured');?>
<div class="layout_middle">
<div class="headline">
<h2>
  <?php echo $event->__toString()." ".$this->translate("&#187; Discussions") ?>
</h2>
</div>

<?php echo $form->render($this) ?>
</div>
</div>