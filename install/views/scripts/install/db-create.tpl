<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Install
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: db-create.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<h1>
  <?php echo $this->translate('Step 3: Setup MySQL Database') ?>
</h1>

<?php if( !empty($this->error) ): ?>

  <p>
    <?php echo $this->error ?>
  </p>

  <br />

  <?php if( $this->code == 2 ): ?>
    <button onclick="window.location.replace('<?php echo $this->url() ?>?force=1');">Overwrite</button>
  <?php elseif( $this->code == 3 ): ?>
    <button onclick="window.location.replace('<?php echo $this->url() ?>?force=2');">Continue Anyway</button>
  <?php endif; ?>

<?php endif; ?>

<?php if( !empty($this->status) ): ?>

  <p>
    Success! Your SocialEngine database is now ready to go.
  </p>

  <br />

  <button onclick="window.location.replace('<?php echo $this->url(array('action' => 'account')) ?>');">Continue...</button>

<?php endif; ?>