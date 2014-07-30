<style>
.global_form > div > div > h3 + div, .global_form > div > div > h3 + p + div {
    border-top: 1px solid #EEEEEE;
    margin-top: 8px;
    padding-top: 20px;
    width: 97%;
}
.global_form div.form-label {
  width:30%;
}
.global_form input[type="text"], .global_form input[type="password"] {
  width:296px;
}
button {
    background: none repeat scroll 0 0 #50C1E9;
    border: 1px solid #FAFAFA;
    border-radius: 3px;
    color: #FFFFFF;
    font-size: 11px;
    font-weight: bold;
    padding: 11px;
}
.global_form > div {
    margin-top: 10px;
    padding: 0 0 9px !important;
    width: 100%;
}
.global_form > div > div {
    background-color: #FFFFFF;
    border: none;
     border-radius: 0;
    margin-top: 16px;
    padding: 12px;
}

.global_form div.form-element {
    clear: none;
    float: left;
    margin-bottom: 10px;
    max-width: 600px;
    min-width: 150px;
    overflow: hidden;
    padding: 5px;
    text-align: left;
}
</style>
<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: edit.tpl 7244 2010-09-01 01:49:53Z john $
 * @author	   John
 */
?>
<div class="content">
    <div class="wd-content-event">

      <?php $nav1 = $this->navigation(); ?>
      <?php $form= $this->form; ?>
      <div class="pt-title-event">
                <ul class="pt-menu-event">
                  <li class="active">
                    <a href="<?php echo $this->baseUrl(); ?>/groups"><?php echo $this->translate('All groups') ?></a>
                  </li>                 
                  <li>
                    <a href="<?php echo $this->baseUrl(); ?>/groups/manage"><?php echo $this->translate('My groups') ?></a>
                  </li>
                </ul>
      </div>
      <?php echo $form->render($this) ?>
    </div>
</div>
    