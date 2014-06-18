<form method="post" class="global_form_popup" action="<?php echo $this->url(array()) ?>">
  <div>
    <h3>
    <?php if(!empty($this->credit)){?>
        <?php echo $this->translate("System will subtract")?>&nbsp;<?php echo $this->credit ?> &nbsp;<?php echo $this->translate("coupon on your account balance")?>, 
        <?php echo $this->translate("Do you want to download this book in your bookshelf?") ?>
    <?php } else{?>
        <?php echo $this->translate("Download this book in your bookshelf?")?>
    <?php }?>
    </h3>
       <p>
          <button type='submit'><?php echo $this->translate("Download"); ?></button>
          <?php echo $this->translate("or") ?>
        	<a href='javascript:void(0);' onclick='javascript:parent.Smoothbox.close()'>
        		<?php echo $this->translate("cancel") ?>
        	</a>
        </p>
  </div>
</form>
