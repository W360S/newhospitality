<style type="text/css">

div #title-element{
	padding-bottom: 5px;
}
#buttons-wrapper{padding-top: 5px;}
</style>
<h2><?php echo $this->translate("Statistics Plugin") ?></h2>

<?php if( count($this->navigation) ): ?>
  <div class='tabs'>
    <?php
      // Render the menu
      //->setUlClass()
      echo $this->navigation()->menu()->setContainer($this->navigation)->render()
    ?>
  </div>
<?php endif; ?>
<?php echo $this->form->render($this) ?>