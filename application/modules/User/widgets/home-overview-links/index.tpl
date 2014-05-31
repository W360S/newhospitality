<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<div class="pt-menu-left"> 
    <h3>Bảng điều khiển</h3>
    <ul id="member-home-left-main-menu">
        <li>
            <a href="<?php echo $this->baseUrl() ?>/members/home" id="link-newfeed"><span class="pt-icon-menu-left pt-icon-home"></span><span class="pt-menu-text">Bảng tin</span>
            </a>
        </li>
        <li>
            <a href="<?php echo $this->baseUrl() ?>/messages/inbox" id="link-message"><span class="pt-icon-menu-left pt-icon-message"></span><span class="pt-menu-text">Tin nhắn</span></a>
        </li>
        <li>
            <a href="<?php echo $this->baseUrl() ?>/events" id="link-events"><span class="pt-icon-menu-left pt-icon-event"></span><span class="pt-menu-text">Sự kiện</span></a>
        </li>
        <?php /*
        <li>
            <a href="javascript:void(0)" id="link-albums"><span class="pt-icon-menu-left pt-icon-album"></span><span class="pt-menu-text">Album ảnh</span></a>
        </li>
        */ ?>
        <li>
            <a href="<?php echo $this->baseUrl() ?>/groups" id="link-groups"><span class="pt-icon-menu-left pt-icon-event"></span><span class="pt-menu-text">Nhóm</span></a>
        </li>
    </ul>
</div>
<script>

</script>