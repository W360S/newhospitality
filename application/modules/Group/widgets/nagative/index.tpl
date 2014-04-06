<?php 
$nav = $this->navigation;
$nav1 = $this->navigation();
?>
    <div class="headline">
      <h2>
        <?php echo $this->translate('Groups');?>
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