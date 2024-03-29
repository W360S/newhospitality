<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: job-add.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<?php if( !$this->form ): ?>

  <?php foreach( $this->enabledJobTypes as $jobType ): ?>
    <?php echo $this->htmlLink($this->url(array('type' => $jobType->type)), $jobType->title) ?>
    <br />
  <?php endforeach; ?>

<?php else: ?>

  <div class="settings">
    <?php echo $this->form->render($this) ?>
  </div>

<?php endif; ?>