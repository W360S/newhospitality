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

    <ul class='blogs_entrylist'>
    <li>
      <h3>
        <?php echo $this->statistic->getTitle() ?>
      </h3>
      <div class="blog_entrylist_entry_body">
        <?php echo $this->statistic->content ?>
      </div>
    </li>
  </ul>