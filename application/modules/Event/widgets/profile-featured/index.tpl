<div class="layout_right">
	<?php //echo $this->formFilter->setAttrib('class', 'filters')->render($this) ?>
    <div class="subsection">
        <h2><?php echo $this->translate('Featured events'); ?></h2>
        <div class="subcontent">
            <div class="featured-groups-wrapper">
                 <?php 
                 echo $this->content()->renderWidget('event.feature'); ?>
            </div>
        </div>
    </div>
</div>
