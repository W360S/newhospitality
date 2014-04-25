<style type="text/css">
input{
	width: 548px;
}
div #category_id-element{
	padding-bottom: 5px;
}
</style>
<h2><?php echo $this->translate("Job Plugin") ?></h2>

<?php if( count($this->navigation) ): ?>
  <div class='tabs'>
    <?php
      // Render the menu
      //->setUlClass()
      echo $this->navigation()->menu()->setContainer($this->navigation)->render()
    ?>
  </div>
<?php endif; ?>

<?php echo $this->form->render($this);?> 