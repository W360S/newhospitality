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
                        <!--class="pt-active"-->
			<a href="<?php echo $this->baseUrl() ?>/members/home" id="link-newfeed"><span class="pt-icon-menu-left pt-icon-menu-01"></span><span class="pt-menu-text">Bảng tin</span><!-- <span class="pt-number">23</span> --></a>
		</li>
		<li>
			<a href="<?php echo $this->baseUrl() ?>/messages/inbox" id="link-message"><span class="pt-icon-menu-left pt-icon-menu-02"></span><span class="pt-menu-text">Tin nhắn</span></a>
		</li>
		<li>
			<a href="<?php echo $this->baseUrl() ?>/events" id="link-events"><span class="pt-icon-menu-left pt-icon-menu-03"></span><span class="pt-menu-text">Sự kiện</span></a>
		</li>
		<li>
			<a href="javascript:void(0)" id="link-albums"><span class="pt-icon-menu-left pt-icon-menu-04"></span><span class="pt-menu-text">Album ảnh</span></a>
		</li>
	</ul>
</div>
<script>
    jQuery(document).ready(function($){
        console.log("PT MENU LEFT IS INITING");
        var member_home_url = "<?php echo $this->baseUrl() ?>/members/home";
        var message_inbox_url = "<?php echo $this->baseUrl() ?>/messages/inbox";
        var events_index_url = "<?php echo $this->baseUrl() ?>/events";
        var album_index_url = "<?php echo $this->baseUrl() ?>/albums";
        if(document.URL.indexOf(member_home_url) != -1){
            $("#link-newfeed").addClass("pt-active");
        }
        if(document.URL.indexOf(message_inbox_url) != -1){
            $("#link-message").addClass("pt-active");
        }
        if(document.URL.indexOf(events_index_url) != -1){
            $("#link-events").addClass("pt-active");
        }
        if(document.URL.indexOf(album_index_url) != -1){
            $("#link-albums").addClass("pt-active");
        }
    });
</script>