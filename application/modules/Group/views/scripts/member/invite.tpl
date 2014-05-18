<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: invite.tpl 7244 2010-09-01 01:49:53Z john $
 * @author	   John
 */
?>
<style type="text/css">
  #group_form_invite #all-wrapper #all-label{display: none;}
#group_form_invite #all-wrapper #all-element input{width: auto;}
</style>
<?php if( $this->count > 0 ): ?>
  <script type="text/javascript">
    jQuery(document).ready(function(){
      var selectAllEl = jQuery("#selectall");
      selectAllEl.click(function(){
        var flag = selectAllEl.attr("checked");
        if (flag) {
          jQuery('input[type="checkbox"]').attr("checked", selectAllEl.attr("checked"));
        }else{
          jQuery('input[type="checkbox"]').attr("checked", false);
        }
      });
    });
  </script>

  <?php echo $this->form->setAttrib('class', 'global_form_popup')->render($this) ?>
<?php else: ?>
  <div>
    <?php echo $this->translate('You have no friends you can invite.');?>
    <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Close'), array('onclick' => 'parent.Smoothbox.close();')) ?>
  </div>
<?php endif; ?>