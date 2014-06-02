<style type="text/css">
img.thumb_icon{border: none; float: left; margin-right: 5px; position: relative; bottom: 3px; width: 22px;}
</style>
<div class="subsection">
	
    <ul class="left-menu-about">
        <li><a class="about" href="<?php echo $this->url(array('module'=>'statistics','controller'=>'index','action'=>'about-us'),'default', true); ?>"><span><?php echo $this->translate('About Us')?></span></a></li>
        <li><a class="terms" href="<?php echo $this->url(array('module'=>'statistics','controller'=>'index','action'=>'terms-of-services'),'default', true); ?>"><span ><?php echo $this->translate('Terms of Service')?></span></a></li>
        <li><a class="privacy" href="<?php echo $this->url(array('module'=>'statistics','controller'=>'index','action'=>'privacy'),'default', true); ?>"><span ><?php echo $this->translate('Privacy Policy')?></span></a></li>
        <li><a class="coupon" href="<?php echo $this->url(array('module'=>'statistics','controller'=>'index','action'=>'coupon'),'default', true); ?>"><span ><?php echo $this->translate('Coupon')?></span></a></li>
	<li><a class="partner" href="<?php echo $this->url(array('module'=>'partner','controller'=>'index','action'=>'index'),'default', true); ?>"><span ><?php echo $this->translate('Partners')?></span></a></li>
       
	<li><a class="contact" href="<?php echo $this->url(array('module'=>'statistics','controller'=>'index','action'=>'contact-us'),'default', true); ?>"><span ><?php echo $this->translate('Contact Us')?></span></a></li>
        <li>
			<a class="submenu-help" href="javascript:void(0);"><span><?php echo $this->translate('Help')?></span></a>
			<ul>
                <?php if(count($this->categories)):?>
                <?php foreach($this->categories as $category):?>
                    <?php $class="";?>
                    <?php if($this->alias===$category->alias):?>
                        <?php $class= 'current-item-active';?>
                        
                    <?php endif;?>
                    <li><a class="<?php echo $class ?>" href="<?php echo $this->baseUrl().'/statistics/index/help/slug/'.$category->alias?>">
                        <?php echo $this->itemPhoto($category, 'thumb.icon', "Image");?>
                        <?php echo $category->name; ?>
                    </a></li>
                <?php endforeach;?>
                <?php endif;?>
			</ul>
		</li>
    </ul>
</div>
