<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: edit.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>

<?php
$this->headScript()
  ->appendFile($this->baseUrl() . '/externals/calendar/calendar.compat.js');
$this->headLink()
  ->appendStylesheet($this->baseUrl() . '/externals/calendar/styles.css');
?>

<style type="text/css">
.global_form > div {
	padding: 0 0 9px 0;
}
</style>

	<!--[if IE 7]>
	<style>
	#event_create_form .form-elements .form-wrapper{
		padding-bottom:10px;
	}
	</style>
	<![endif]-->

<div class="content">
<div class="layout_right">
	<?php //echo $this->formFilter->setAttrib('class', 'filters')->render($this) ?>
    <div class="subsection">
        <h2>Featured events</h2>
        <div class="subcontent">
            <div class="featured-groups-wrapper">
                 <?php 
                 $nav = $this->navigation;
                 $nav1 = $this->navigation();
                 $pages = $this->paginator;  
                 $form= $this->form;
                 echo $this->content()->renderWidget('event.feature'); ?>
            </div>
        </div>
    </div>
    <!--
    <div class="subsection">
        <?php //echo $this->content()->renderWidget('event.ad'); ?>
    </div>
    -->
</div>
<div class="layout_middle">
<div class="headline">
  <h2>
    <?php echo $this->translate('Events');?>
  </h2>
  <div class="tabs">
    <?php
      // Render the menu
      echo $nav1
        ->menu()
        ->setContainer($nav)
        ->render();
    ?>
  </div>
</div>
<?php echo /*->setAttrib('class', 'global_form_popup')*/$form->render($this) ?>
</div>
</div>