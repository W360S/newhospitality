<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: performance.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>
<div class='settings'>
  
  <?php echo $this->form->render($this) ?>

</div>
<script type="text/javascript">
//<![CDATA[
function updateFields() {
  $$('div[id$=-wrapper][id^=file_]').hide();
  $$('div[id$=-wrapper][id^=memcache_]').hide();
  $$('div[id$=-wrapper][id^=xcache_]').hide();
  var new_value = $$('input[name=type]:checked')[0].get('value');
  if ('File' == new_value)
    $$('div[id$=-wrapper][id^=file_]').show();
  else if ('Memcached' == new_value)
    $$('div[id$=-wrapper][id^=memcache_]').show();
  else if ('Xcache' == new_value)
    $$('div[id$=-wrapper][id^=xcache_]').show();
}
window.addEvent('load', function(){
  updateFields();
  <?php if ($this->isPost): ?>
  if ($('message').get('text').length) {
      $('message').show();
      $('message').inject( $$('div.form-elements')[0], 'before');
  }
  <?php endif; ?>
});
//]]>
</script>

<div id="message" style="display:none;">
  <?php echo $this->message ?>
</div>
