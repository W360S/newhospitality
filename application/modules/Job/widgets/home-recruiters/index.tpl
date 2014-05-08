<div class="pt-event-tabs">
    <ul class="pt-title">
        <li><a href="javascript:showTab1()">TÌM KIẾM</a></li>
        <li><a href="javascript:showTab3()">NGHỀ NGHIỆP</a></li>
    </ul>
    <div id="tabs-1" class="pt-content-tab">
        <?php echo $this->content()->renderWidget('recruiter.search-resumes'); ?>
    </div>
    <div id="tabs-3" class="pt-content-tab" style="display:none">
        <?php echo $this->content()->renderWidget('resumes.categories'); ?>
    </div>
</div>
<script>
    function showTab1(){
        jQuery(".pt-content-tab").each(function(){
            jQuery(this).hide();
        });
        jQuery("#tabs-1").show();
    }
    
    function showTab2(){
        jQuery(".pt-content-tab").each(function(){
            jQuery(this).hide();
        });
        jQuery("#tabs-2").show();
    }
    
    function showTab3(){
        jQuery(".pt-content-tab").each(function(){
            jQuery(this).hide();
        });
        jQuery("#tabs-3").show();
    }
</script>