<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: create.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     Jung
 */

?>
<?php
$this->headScript()
  ->appendFile($this->layout()->staticBaseUrl . 'externals/calendar/calendar.compat.js');
$this->headLink()
  ->appendStylesheet($this->layout()->staticBaseUrl . 'externals/calendar/styles.css');
?>
<script type="text/javascript">
  var myCalStart = false;
  var myCalEnd = false;

  en4.core.runonce.add(function init()
  {
    monthList = [];
    myCal = new Calendar({ 'start_time[date]': 'M d Y', 'end_time[date]' : 'M d Y' }, {
      classes: ['event_calendar'],
      pad: 0,
      direction: 0
    });
  });


  var updateTextFields = function(endsettings)
  {
    var endtime_element = document.getElementById("end_time-wrapper");
    endtime_element.style.display = "none";

    if (endsettings.value == 0)
    {
      endtime_element.style.display = "none";
      return;
    }

    if (endsettings.value == 1)
    {
      endtime_element.style.display = "block";
      return;
    }
  }

en4.core.runonce.add(updateTextFields);

</script>

<div class='settings'>
  <?php echo $this->form->render($this); ?>
</div>