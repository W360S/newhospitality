<style type="text/css">
#global_content .layout_middle, .layout_left{padding-right: 0;}
</style>
<?php
    $contents= $this->contents; 
    $category_id= $this->category_id;
?>
<div id="content">
    <div class="section layout-about-us">
        <div class="layout_left">
            <?php echo $this->content()->renderWidget('statistics.panel-left');?>
        </div>
        <div class="layout_middle">
            
            <ul class="title">
				<li class="first-link">
					<h3><a href="javascript:void(0);"><?php echo $this->translate('Help')?></a></h3>
				</li>
				<li>
					<h3><a href="javascript:void(0);"><?php $category= Engine_Api::_()->getApi('setting', 'statistics')->getCategory($category_id); echo $category->name;?></a></h3>
				</li>
			</ul>
            <ul class="wd-accordion">
                <?php if($contents):?>
                    <?php foreach($contents as $content):?>
                            <li>
						      <h4><?php echo $content->title;?></h4>
						      <div class="wd-content"><?php echo $content->content;?></div>
                            </li>
                    <?php endforeach; ?>
                    <?php endif;?>
            </ul>
            
        </div>
        <?php echo $this->content()->renderWidget('statistics.footer');?>
    </div>
</div>
<script type="text/javascript">
window.addEvent('domready',function(){
    //active menu help
    var h = jQuery('.left-menu-about li a.submenu-help').parent().find('ul').is(':hidden');
	if(h==true){
		jQuery('.left-menu-about li a.submenu-help').parent().find('ul').slideDown();
		
		jQuery('.left-menu-about li a.submenu-help').addClass('submenu-help-up');
        jQuery('.left-menu-about li a.submenu-help').removeClass('submenu-help');
	}
 });
</script>