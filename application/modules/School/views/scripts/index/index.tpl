<style type="text/css">
#global_wrapper {background:none;}
#content{padding: 20px 0;}
</style>
<div id="banner-school">
    <div class="section">
        <?php echo $this->content()->renderWidget('school.banner');?>
        <?php echo $this->content()->renderWidget('school.newest-school');?>
    </div>
</div>
<div id="content">
    <div class="section shool">
        <div class="layout_left">
            <?php echo $this->content()->renderWidget('school.lastest-article');?>
            <?php echo $this->content()->renderWidget('school.advertising');?>
        </div>
        <div class="layout_right">
             <?php echo $this->content()->renderWidget('school.school-tools');?>
             <?php echo $this->content()->renderWidget('school.top-article');?>
             <?php echo $this->content()->renderWidget('school.newest-comment');?>
        </div>
        <div class="layout_middle">
            <?php echo $this->content()->renderWidget('school.top-school');?>
        </div>
    </div>
</div>    