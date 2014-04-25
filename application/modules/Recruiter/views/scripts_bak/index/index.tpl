<style type="text/css">
.recruiter_main .subsection{background-color: #fff;}
#global_wrapper{background: none;}
</style>
<div id="content">

    <div class="section recruiter">
    <div class="layout_right">
        <?php echo $this->content()->renderWidget('recruiter.sub-menu');?>
        <?php echo $this->content()->renderWidget('recruiter.manage-recruiter');?>
        <!-- resume tools -->
    <?php echo $this->content()->renderWidget('resumes.resume-tools');?>
    <!-- end -->
        <?php echo $this->content()->renderWidget('resumes.suggest-resume');?>
         <!-- insert some advertising -->
        <div class="subsection">
            <a href="http://www.vtcb.org.vn/">
                <img src="application/modules/Job/externals/images/companies/vtcb.jpg" alt="Image" />
            </a>
            <a href="http://www.moevenpick-hotels.com/en/asia/vietnam/ho-chi-minh-city/hotel-saigon/overview/">
                <img src="application/modules/Job/externals/images/companies/movenpick.png" alt="Image" />
            </a>
            <a href="http://www.seasideresort.com.vn/201203_seaside/">
                <img src="application/modules/Job/externals/images/companies/seaside.png" alt="Image" />
            </a>
            <a href="http://www.namnguhotel.com/index.php">
                <img src="application/modules/Job/externals/images/companies/namngu.png" alt="Image" />
            </a>
        </div>
    </div>
        <div class="layout_middle">
    
            <div class="recruiter_main">
                
                <?php echo $this->content()->renderWidget('recruiter.search-resumes');?>
                <?php echo $this->content()->renderWidget('resumes.categories');?>
                <?php echo $this->content()->renderWidget('resumes.new-resumes');?>
                 <?php echo $this->content()->renderWidget('recruiter.articals');?>
                 
            </div>
        </div>
    </div>

</div>
