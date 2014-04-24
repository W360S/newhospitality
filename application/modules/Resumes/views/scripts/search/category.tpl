<style type="text/css">
.recruiter_main .subsection{background-color: #fff;}
#global_wrapper{background: none;}
</style>
<div id="content">

    <div class="section recruiter">
    <div class="layout_right">
        <?php echo $this->content()->renderWidget('recruiter.sub-menu');?>
        <?php echo $this->content()->renderWidget('recruiter.manage-recruiter');?>
        <?php echo $this->content()->renderWidget('resumes.suggest-resume');?>
        <!-- insert some advertising -->
        <?php include 'ads/right-column-ads.php'; ?>
    </div>
        <div class="layout_middle">
    
            <div class="recruiter_main">
                
                <?php echo $this->content()->renderWidget('recruiter.search-resumes');?>
                <?php echo $this->content()->renderWidget('resumes.categories');?>
                
                 
            </div>
        </div>
    </div>

</div>
