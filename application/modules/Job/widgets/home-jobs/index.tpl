<div class="pt-event-tabs">
    <ul class="pt-title">
        <li id="tabs-1-title" class="ui-state-active"><a href="javascript:showTab1()">TÌM KIẾM</a></li>
        <li id="tabs-3-title"><a href="javascript:showTab3()">NGHỀ NGHIỆP</a></li>
        <li id="tabs-2-title"><a href="javascript:showTab2()">LĨNH VỰC</a></li>
    </ul>
    <div id="tabs-1" class="pt-content-tab">
        <?php echo $this->content()->renderWidget('recruiter.search-job'); ?>
    </div>
    <div id="tabs-2" class="pt-content-tab" style="display:none">
        <?php echo $this->content()->renderWidget('recruiter.industry-job'); ?>
    </div>
    <div id="tabs-3" class="pt-content-tab" style="display:none">
        <?php echo $this->content()->renderWidget('recruiter.categories'); ?>
    </div>
</div>
<?php /*
<div class="pt-list-job">
    <?php echo $this->content()->renderWidget('recruiter.new-job'); ?>
</div>
*/ ?>
<script>
    function showTab1(){
        jQuery(".pt-content-tab").each(function(){
            jQuery(this).hide();
        });
        jQuery("#tabs-1").show();
        jQuery("#tabs-1-title").addClass('ui-state-active');
        jQuery("#tabs-2-title").removeClass('ui-state-active');
        jQuery("#tabs-3-title").removeClass('ui-state-active');
    }
    
    function showTab2(){
        jQuery(".pt-content-tab").each(function(){
            jQuery(this).hide();
        });
        jQuery("#tabs-2").show();
        jQuery("#tabs-2-title").addClass('ui-state-active');
        jQuery("#tabs-1-title").removeClass('ui-state-active');
        jQuery("#tabs-3-title").removeClass('ui-state-active');
    }
    
    function showTab3(){
        jQuery(".pt-content-tab").each(function(){
            jQuery(this).hide();
        });
        jQuery("#tabs-3").show();
        jQuery("#tabs-3-title").addClass('ui-state-active');
        jQuery("#tabs-2-title").removeClass('ui-state-active');
        jQuery("#tabs-1-title").removeClass('ui-state-active');
    }
</script>
<?php
/*
  <style type="text/css">
  #global_content{width: 100%;padding-top: 0;}
  #content{padding: 10px 0; width: 101%;}
  img { vertical-align: top; }

  .wd-tab .wd-item li{background-color:#f2f2f2;float:left;font-weight:bolder;margin-right:2px;padding:.5em 1em;}
  .wd-tab .wd-item li.wd-current{background-color:#F1F8FC;}
  .wd-tab .wd-item li.wd-current a{ color:#009ECF !important;}
  .wd-tab .wd-item li a:link, .wd-tab .wd-item li a:visited{color:#686868;}
  .wd-tab .wd-item li a:hover{color:#c00;}
  .wd-tab .wd-item li a{font-size:1.2em; text-transform:uppercase;}
  .wd-tab .wd-panel{padding:1em;}
  .wd-tab .wd-panel h3, .wd-tab .wd-panel h4, .wd-tab .wd-panel h5, .wd-tab .wd-panel ul, .wd-tab .wd-panel ol, .wd-tab .wd-panel p{margin-bottom:1em;}
  .wd-tab .wd-panel h3, .wd-tab .wd-panel h4, .wd-tab .wd-panel h5{font-size:1em;}
  .wd-tab .wd-panel ul, .wd-tab .wd-panel ol{margin-left:3em;margin-right:3em;}
  .wd-tab .wd-panel li{padding:.1em 0;}
  .wd-tab .wd-panel ul{list-style:disc;}
  .wd-tab .wd-panel ol{list-style:decimal;}
  </style>
  <div id="content">
  <div class="section jobs">

  <div class="layout_right">
  <!-- online resume -->
  <?php //echo $this->content()->renderWidget('resumes.sub-menu');?>
  <!-- end -->
  <!-- job manage -->
  <?php //echo $this->content()->renderWidget('recruiter.manage-job');?>
  <!-- end -->
  <!-- job tools -->
  <?php //echo $this->content()->renderWidget('recruiter.job-tools');?>
  <!-- end -->
  <!-- feature employers -->
  <?php //echo $this->content()->renderWidget('recruiter.featured-employer');?>
  <!-- end -->
  <!-- insert some advertising -->
  <?php //include 'ads/right-column-ads.php'; ?>
  </div>

  <div class="layout_middle">
  <div class="wd-tab">
  <ul class="wd-item">
  <li style="border-top-left-radius: 8px;"><a href="#wd-fragment-1"><?php echo $this->translate('Careers')?></a></li>
  <li style="border-top-left-radius: 8px;"><a href="#wd-fragment-2"><?php echo $this->translate('Industries')?></a></li>

  </ul>
  <div>
  <div class="wd-section" id="wd-fragment-1">
  <!--job careers -->
  <?php echo $this->content()->renderWidget('recruiter.industry-job');?>
  <!-- end -->
  </div>
  <div class="wd-section" id="wd-fragment-2">
  <?php echo $this->content()->renderWidget('recruiter.categories');?>
  </div>

  </div>
  </div>

  <!-- newest jobs -->
  <?php //echo $this->content()->renderWidget('recruiter.new-job');?>
  <!-- end -->
  <!-- hot jobs -->
  <?php //echo $this->content()->renderWidget('recruiter.hot-job');?>
  <!-- end -->
  <!-- artical -->
  <?php //echo $this->content()->renderWidget('recruiter.articals');?>
  <!-- end -->
  <div class="clear"></div>
  </div>

  <div class="clear"></div>

  </div>
  </div>
  <script type="text/javascript">
  window.addEvent('domready', function(){
  jQuery('.wd-tab').each(function(){
  jQuery(this).find('.wd-section').hide();

  var current = jQuery(this).find('.wd-item').children('.wd-current');
  if (current.length == 0){
  jQuery(this).find('.wd-item').children(':first-child').addClass('wd-current');
  jQuery(jQuery(this).find('.wd-item').children(':first-child').find('a').attr('href')).show();
  }

  jQuery(this).find('.wd-item').find('a').click(function(){
  var current = jQuery(this).parent().hasClass('wd-current');
  if (current == false){
  jQuery(this).parent()
  .addClass('wd-current')
  .siblings().each(function(){
  jQuery(this).removeClass('wd-current');
  jQuery(jQuery(this).find('a').attr('href')).hide();
  });
  jQuery(jQuery(this).attr('href')).fadeIn();
  }
  return false;
  });
  });
  });
  </script>
 */?>