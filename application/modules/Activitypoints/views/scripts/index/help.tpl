<?php
   $this->headScript()
    ->appendFile($this->baseUrl() . '/application/modules/Activitypoints/externals/scripts/activitypoints.js')
?>

<?php if( count($this->navigation) ): ?>
<div class="headline">
  <h2>
	<?php echo $this->translate('Points ');?>
  </h2>
  <div class="tabs">
	<?php
	  // Render the menu
	  echo $this->navigation()
		->menu()
		->setContainer($this->navigation)
		->render();
	?>
  </div>
</div>
<?php endif; ?>

<!--
<div><?php echo $this->translate('100016747') ?></div>

<br><br>

-->


<script language="javascript">
<!--
function showhide(id1) {
	if(document.getElementById(id1).style.display=='none') {
		document.getElementById(id1).style.display='block';
	} else {
		document.getElementById(id1).style.display='none';
	}
}
// -->
</script>

<div class='activitypoints_faq_header'><?php echo $this->translate('Earning Points') ?></div>
<div class='activitypoints_faq_questions'>
  <a href="javascript:void(0);" onClick="showhide('1');"><?php echo $this->translate('How do i earn points?') ?></a><br>
  <div class='activitypoints_faq' style='display: none;' id='1'>
  <?php  echo sprintf($this->translate('ACTIVITYPOINTS_HELP_EARN'),$this->url(array(),'invite'), $this->url(array('module'	=> 'members', 'controller'	=> 'edit', 'action' => 'photo'),'default')) ?>
  <?php  echo sprintf($this->translate('ACTIVITYPOINTS_HELP_EARN1'),$this->url(array(),'activitypoints_earn'));  ?>
  </div>
</div>
<div class='activitypoints_faq_questions'>
  <a href="javascript:void(0);" onClick="showhide('2');"><?php  echo $this->translate('What activities reward me with points?') ?></a><br>
  <div class='activitypoints_faq' style='display: none;' id='2'>
	
	<?php echo $this->translate('100016752') ?> <br><br>
	
	<table cellpadding='0' cellspacing='0' class='activitypoints_help_table' style="width:500px;" Xwidth='100%'>
	<thead>
	  <tr>
	  <th><?php echo $this->translate('Activity') ?></th>
	  <th><?php echo $this->translate('Points') ?></th>
	  <th><?php echo $this->translate('Maximum') ?></th>
	  <th><?php echo $this->translate('Reset period') ?></th>
	  </tr>
	</thead>

	<?php  for($action_loop = 0; $action_loop < count($this->actions); $action_loop++) : ?>
	
	<?php for($action_gloop = 0; $action_gloop < count($this->actions[$action_loop]); $action_gloop++) : ?>
	  
	<tbody>
	  <tr>
	  <td><?php  echo $this->translate($this->actions[$action_loop][$action_gloop]['action_name']) ?></td>
	  <td width="20px"><?php echo $this->actions[$action_loop][$action_gloop]['action_points'] ?></td>
	  <td width="20px"><?php if ($this->actions[$action_loop][$action_gloop]['action_pointsmax'] == 0): ?><?php echo $this->translate('100016758') ?><?php else: ?><?php echo $this->actions[$action_loop][$action_gloop]['action_pointsmax'] ?><?php endif; ?></td>
	  <td width="100px"><?php if ($this->actions[$action_loop][$action_gloop]['action_rolloverperiod'] == 0): ?><?php echo $this->translate('100016759') ?><?php else: ?> <?php echo $this->actions[$action_loop][$action_gloop]['action_rolloverperiod'] ?> <?php echo $this->translate('100016757') ?> <?php endif; ?></td>
	  </tr>
		
  <?php endfor; ?>
		  
		<tr><td colspan=4 style="border-bottom: 1px dashed #CCC">&nbsp;</td></tr>	
  
  <?php endfor; ?>

	</tbody>
	</table>
  
	<br><br>
	
  </div>
</div>

<br>

<?php if(Engine_Api::_()->getDbTable('modules','core')->hasModule('activityrewards')) : ?>

<div class='activitypoints_faq_header'><?php echo $this->translate('Spending Points') ?></div>
<div class='activitypoints_faq_questions'>
  <a href="javascript:void(0);" onClick="showhide('6');"><?php echo $this->translate('How can i spend points?') ?></a><br>
  <div class='activitypoints_faq' style='display: none;' id='6'>
  <?php echo sprintf($this->translate('ACTIVITYPOINTS_HELP_SPEND'),$this->url(array(),'activitypoints_spend')) ?>
  </div>
</div>
<br>
<?php endif; ?>

