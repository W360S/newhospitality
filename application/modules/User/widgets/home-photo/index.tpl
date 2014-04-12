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
        <a href="<?php $this->viewer()->getHref() ?>"><span class="pt-avatar"><?php echo $this->itemPhoto($this->viewer(), 'thumb.profile') ?></span></a>
        <div class="pt-how-info-boss">
                <h3><a href="#"><?php echo $this->viewer()->getTitle() ?></a></h3>
                <p><a href="<?php $this->viewer()->getHref() ?>">Trang cá nhân</a></p>
        </div>
</div>
