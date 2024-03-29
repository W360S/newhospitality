<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: delete.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Jung
 */
?>

  <form method="post" class="global_form_popup">
    <div>
      <h3><?php echo $this->translate("Delete Event Category?") ?></h3>
    	<?php if($this->no_event) { ?>
	      <p>
	        <?php echo $this->translate("This category cannot be deleted as they contain event.") ?>
	      </p>
	      <br />
	      <p>
				<a href='javascript:void(0);' onclick='javascript:parent.Smoothbox.close()'>
					<?php echo $this->translate("Exit") ?>
				</a>
	      </p>
    		
    	<?php } else { ?>
	      <p>
	        <?php echo $this->translate("Are you sure that you want to delete this category? It will not be recoverable after being deleted.") ?>
	      </p>
	      <br />
	      <p>
	        <input type="hidden" name="confirm" value="<?php echo $this->event_id?>"/>
	        <button type='submit'><?php echo $this->translate("Delete") ?></button>
	        <?php echo $this->translate("or") ?>
					<a href='javascript:void(0);' onclick='javascript:parent.Smoothbox.close()'>
					<?php echo $this->translate("cancel") ?></a>
	      </p>
	    <?php } ?>
    </div>
  </form>

<?php if( @$this->closeSmoothbox ): ?>
<script type="text/javascript">
  TB_close();
</script>
<?php endif; ?>
