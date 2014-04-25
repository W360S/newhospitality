<style type="text/css">
#global_wrapper {background:none;}
#content{padding: 20px 0;}
#breadcrumb {
    padding-top: 20px;
    padding-bottom: 0px;
}
#global_content .layout_middle {
    padding-right: 0px;
}
</style>
<?php
$paginator= $this->paginator;

$input_search= $this->input_search;
$values= $this->values;
$country_search= $this->country_search;
?>
<div id="banner-school">
    <div class="section">
        <?php echo $this->content()->renderWidget('school.banner');?>
       
    </div>
</div>
<div id="breadcrumb">
        <div class="section">
            <a href="<?php echo $this->baseUrl()?>"><?php echo $this->translate('Home');?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/school'?>"><?php echo $this->translate('Education School');?></a> <span>&gt;</span> <strong><?php echo $this->translate('Find School');?></strong>
        </div>
    </div>
<div id="content">
    <div class="section shool">
        <div class="layout_left">
            <?php echo $this->content()->renderWidget('school.lastest-article');?>
            <?php echo $this->content()->renderWidget('school.advertising');?>
        </div>
        
        <div class="layout_middle">
            <div class="subsection">
            	<h2><?php echo $this->translate('Result');?></h2>
            	<ul class="list_top_school">
                <?php if(count($paginator)>0){
                    foreach($paginator as $item){?>
                        <li>
                			<a><?php echo $this->itemPhoto($item);?></a>
                            <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->name);?>
                			<h4 class="title"><?php echo $this->htmlLink(array('route' => 'view-school', 'id'=> $item->school_id, 'slug'=>$slug), $item->name) ?></h4>
                			<p><?php echo $this->translate('County:')?> <?php echo $this->country($item->country_id)->name;?></p>
                            <p style="font-size: 11px; color:#8D8D8D;">
                                <span><?php  echo $this->translate(array('%s article', '%s articles', intval($item->num_artical)), intval($item->num_artical)); ?></span>
                                <span class="bd_list">|</span>
                                <span><?php  echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)); ?></span>
                                
                            </p>
                            <?php echo $this->htmlLink(array('route' => 'view-school', 'id'=> $item->school_id, 'slug'=>$slug), $this->translate('View detail'), array('class'=>'view-detail')) ?>
           		           
                        </li>
                    <?php }
                } else {?>
                    <div class="tip" style="padding-top: 5px; padding-left:5px;">
                    <span>
                      <?php echo $this->translate("There are no schools.") ?>
                    </span>
                 </div>
                <?php }
                ?>
                    
                </ul>
                <?php echo $this->paginationControl($paginator, null, null, array('query'=> $values));?>
             </div>
        </div>
    </div>
</div>    
<script type="text/javascript">
window.addEvent('domready', function(){
    var input= "<?php echo $input_search;?>";
    var country= "<?php echo $country_search;?>";
    jQuery('#input_search').val(input);
    jQuery('#country_id option').each(function(){
        if(country==jQuery(this).val()){
            jQuery(this).attr('selected', 'selected');
        }
    });
});
</script>