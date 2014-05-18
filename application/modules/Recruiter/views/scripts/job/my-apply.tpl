<div class="pt-title-event">
    <ul class="pt-menu-event pt-menu-libraries">
        <li>
            <a href="/recruiter">Dành cho nhà tuyển dụng</a>
        </li>
        <li>
            <a href="/recruiter/job/manage-apply">Quản lý hồ sơ</a>
        </li>
        <li>
            <span>Đơn xin việc của tôi</span>
        </li>
    </ul>
</div>
<div class="subsection">
    <?php echo $this->content()->renderWidget('recruiter.my-apply'); ?>
</div>

<script type="text/javascript">
    window.addEvent('domready', function() {
        //When page loads...
        jQuery(".tab_content").hide(); //Hide all content
        jQuery("ul.tabs li:first").addClass("active").show(); //Activate first tab
        jQuery(".tab_content:first").show(); //Show first tab content

        //On Click Event
        jQuery("ul.tabs li").click(function() {

            jQuery("ul.tabs li").removeClass("active"); //Remove any "active" class
            jQuery(this).addClass("active"); //Add "active" class to selected tab
            jQuery(".tab_content").hide(); //Hide all tab content

            var activeTab = jQuery(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
            jQuery(activeTab).fadeIn(); //Fade in the active ID content
            return false;
        });

    });
</script>