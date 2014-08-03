<form method="post" class="global_form_popup" action="<?php echo $this->url(array()) ?>" id="form-download">
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
          <button id="submit-download-button" type='xsubmit'><?php echo $this->translate("Download"); ?></button>
          <?php echo $this->translate("or") ?>
        	<a href='javascript:void(0);' onclick='javascript:parent.Smoothbox.close()'>
        		<?php echo $this->translate("cancel") ?>
        	</a>
        </p>
        <script src="/application/modules/Core/externals/scripts/jquery-1.10.2.min.js" type="text/javascript"></script>
        <script>
            
            jQuery(document).ready(function($){
                $("button#submit-download-button").click(function(){
                    $("form#form-download").submit(function(){
                        setTimeout(function(){
                            parent.Smoothbox.close();
                        },3000);
                        
                    });
                });
            });
        </script>
  </div>
</form>
