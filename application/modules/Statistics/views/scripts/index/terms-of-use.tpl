<style type="text/css">
#global_content .layout_middle, .layout_left{padding-right: 0;}
.layout-about-us ul.left-menu-about li a.terms-use{color:#fff;font-size:13px;text-transform:uppercase;background: url(<?php echo "/application/modules/Statistics/externals/images/help/title-about-us.gif" ?>) repeat-x;font-weight:bold}

</style>
<?php
    $data= $this->data; 
?>
<div id="content">
    <div class="section layout-about-us">
        <div class="layout_left">
            <?php echo $this->content()->renderWidget('statistics.panel-left');?>
        </div>
        <div class="layout_middle">
            <?php 
                if($data){
                    echo $data['body'];
                }
            ?>
        </div>
        <?php echo $this->content()->renderWidget('statistics.footer');?>
    </div>
</div>