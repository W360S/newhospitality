<style type="text/css">
#global_content{width: 100%;padding-top: 0;}
#content{padding: 10px 0;}
</style>

<div class="layout_main">
<?php echo $this->content()->renderWidget('recruiter.search-job');?>
<!--
<div class="headline">
    <?php echo $this->content()->renderWidget('recruiter.menu')?>
</div>
<div class="layout_left">
<?php echo $this->content()->renderWidget('recruiter.manage-job');?>
</div>
-->
<div id="content">
        <div class="section jobs">

            <div class="layout_right">
                <!-- online resume -->
                <?php echo $this->content()->renderWidget('resumes.sub-menu');?>
                <!-- end -->
                <!-- job manage -->
                <?php echo $this->content()->renderWidget('recruiter.manage-job');?>
                <!-- end -->
                <!-- feature employers -->
                <?php //echo $this->content()->renderWidget('recruiter.featured-employer');?>
                <!-- end -->
                <div class="subsection">
                    <a href="<?php echo $this->baseUrl().'/resumes'?>"><img src="application/modules/Core/externals/images/img-showcase-4.jpg" alt="Image" /></a>
                </div>
            </div>

            <div class="layout_middle">
                <!--job categories -->
                <?php echo $this->content()->renderWidget('recruiter.employers');?>
                <!-- end -->
                
            </div>

            <div class="clear"></div>

        </div>
</div>

</div>
