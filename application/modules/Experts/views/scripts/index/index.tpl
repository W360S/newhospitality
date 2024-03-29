<div id="wd-content-container">
<div class="wd-center">
	<div class="wd-content-left">
		<?php echo $this->content()->renderWidget('experts.categories'); ?>
<?php echo $this->content()->renderWidget('core.ad-campaign', array('adcampaign_id' => 3)); ?>
	</div>
	<div class="wd-content-content-sprite pt-fix">
		<div class="wd-content-event">
			<div class="pt-content-event">
				<div class="pt-event-tabs">
					<?php echo $this->content()->renderWidget('experts.search'); ?>
				</div>
				<div class="pt-reply-how">
					<div class="pt-reply-left">
						<div class="pt-event-tabs">
							<style>
								ul li.ui-tabs-active a {font-weight:bold}
							</style>
							<div class="pt-title-reply">
								<h3>Tất cả câu hỏi</h3>
								<ul>
									<li><div id="url_tab01" >Mới cập nhật</div></li>
									<li><div id="url_tab02" >Xem nhiều nhất</div></li>
									<li><div id="url_tab03" >Phản hồi nhiều nhất</div></li>
								</ul>
							</div>
							<div id="tab-01">
								<?php echo $this->content()->renderWidget('experts.top-home'); ?>
							</div>
							<div id="tab-02">
								<?php echo $this->content()->renderWidget('experts.top-views'); ?>
							</div>
							<div id="tab-03">
								<?php echo $this->content()->renderWidget('experts.top-rating'); ?>
							</div>
						</div>
					</div>
					<div class="pt-reply-right">
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.post-question'); ?>
						</div>
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.my-accounts'); ?>
						</div>
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.lasted-questions'); ?>
						</div>
						<div class="pt-block">
							<?php echo $this->content()->renderWidget('experts.featured-experts'); ?>
<?php echo $this->content()->renderWidget('core.ad-campaign', array('adcampaign_id' => 4)); ?>
						</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>
<div id="wd-extras">
	<div class="wd-center">
		
	</div>	
</div>
<script type="text/javascript">
  
 window.addEvent('domready',function(){

	jQuery("#tab-03").hide();
	jQuery("#tab-02").hide();
	jQuery(this).css( "color", "black" );
	jQuery('#url_tab02').css({ "color": 'blue' });
	jQuery('#url_tab03').css({ "color": 'blue' });

	jQuery('#url_tab02').bind('click', function(){
		jQuery("#tab-01").hide();
		jQuery("#tab-02").toggle();
		jQuery("#tab-03").hide();
		jQuery(this).css( "color", "black" );
		jQuery('#url_tab03').css({ "color": 'blue' });
		jQuery('#url_tab01').css({ "color": 'blue' });
		
	});

	jQuery('#url_tab01').bind('click', function(){
		jQuery("#tab-01").toggle();
		jQuery("#tab-02").hide();
		jQuery("#tab-03").hide();
		jQuery(this).css( "color", "black" );
		jQuery('#url_tab02').css({ "color": 'blue' });
		jQuery('#url_tab03').css({ "color": 'blue' });
		
	});

	jQuery('#url_tab03').bind('click', function(){
		jQuery("#tab-01").hide();
		jQuery("#tab-02").hide();
		jQuery("#tab-03").toggle();
		jQuery(this).css( "color", "black" );
		jQuery('#url_tab01').css({ "color": 'blue' });
		jQuery('#url_tab02').css({ "color": 'blue' });
		
	});
  });
</script>