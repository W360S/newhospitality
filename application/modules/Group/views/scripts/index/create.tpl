<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: create.tpl 7244 2010-09-01 01:49:53Z john $
 * @author	   John
 */
?>

<!--[if IE 7]>
<style>
	.form-elements .form-wrapper{
		padding-bottom: 10px;
	}
	button{
		line-height:15px;
		width:120px;
	}
</style>
<![endif]-->
	
<?php $form = $this->form; ?>
<div class="content">
		<div class="wd-content-event">
		  <div class="pt-title-event">
								<ul class="pt-menu-event">
									<li class="active">
										<a href="<?php echo $this->baseUrl(); ?>/groups"><?php echo $this->translate('All groups') ?></a>
									</li>									
									<li>
										<a href="<?php echo $this->baseUrl(); ?>/groups/manage"><?php echo $this->translate('My groups') ?></a>
									</li>
								</ul>
								<a href="<?php echo $this->baseUrl(); ?>/groups/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New group') ?></a>
		</div>
		<?php echo $form->render($this) ?>
		</div>
</div>