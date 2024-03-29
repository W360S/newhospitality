<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: index.tpl (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
?>
<div class='tabs'>
  <?php
    // Render the menu
    echo $this->navigation()
      ->menu()
      ->setContainer($this->navigation)
      ->render();
  ?>
</div>
<div class='clear'>
  <div class='settings'>
	<?php  echo $this->form->render($this)  ?>
  </div>
</div>