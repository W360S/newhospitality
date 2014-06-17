<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<div class="pt-boss">
        <a href="<?php $this->viewer()->getHref() ?>">
        	<?php //echo $this->itemPhoto($this->viewer(), 'thumb.profile') ?>
    		<?php $image = $this->viewer()->getPhotoUrl('thumb.icon');?>
        	<span class="pt-avatar" style="background-image: url('<?php echo $image; ?>');">

        	</span>
        	<style type="text/css">
        		span.pt-avatar{
        			width: 48px;
    				height: 48px;
        			background-position: center center;
				    background-repeat: no-repeat;
				    overflow: hidden;
        		}
        	</style>
        </a>
        <div class="pt-how-info-boss">
                <h3><a href="<?php echo $this->layout()->staticBaseUrl . 'profile/' . $this->viewer()->getOwner()->username; ?>"><?php echo $this->viewer()->getTitle() ?></a></h3>
                <p><a href="<?php echo $this->layout()->staticBaseUrl . 'profile/' . $this->viewer()->getOwner()->username; ?>">Trang cá nhân</a></p>
        </div>
</div>
