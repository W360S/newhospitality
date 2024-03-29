<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Install
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: complete.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<h3>
  Install Packages
</h3>

<?php
  // Navigation
  echo $this->render('_installMenu.tpl')
?>

<br />

<p>
  Awesome! The installation has been completed successfully. You can now return to the package manager or your dashboard.
</p>

<br />
<br />

<div>
  <?php $appBaseHref = str_replace('install/', '', $this->url(array(), 'default', true)); ?>
  <form method="get" action="<?php echo $this->url(array('action' => 'index')) ?>">
    <button type="submit">Back to Package Manager</button>
    or <a href="<?php echo $appBaseHref ?>admin/">back to dashboard</a>
  </form>
</div>

<!--
<a href="<?php echo $this->url(array('action' => 'index')) ?>">Return to Manager</a>
-->