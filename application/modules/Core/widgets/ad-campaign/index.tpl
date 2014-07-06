<?php

/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     Jung
 */
?>
<?php /* turn off old ads code
<script type="text/javascript">
  en4.core.runonce.add(function() {
    var url = '<?php echo $this->url(array('module' => 'core', 'controller' => 'utility', 'action' => 'advertisement'), 'default', true) ?>';
    var processClick = window.processClick = function(adcampaign_id, ad_id) {
      (new Request.JSON({
        'format': 'json',
        'url' : url,
        'data' : {
          'format' : 'json',
          'adcampaign_id' : adcampaign_id,
          'ad_id' : ad_id
        }
      })).send();
    }
  });
</script>

<div onclick="javascript:processClick(<?php echo $this->campaign->adcampaign_id.", ".$this->ad->ad_id?>)">
  <?php echo $this->ad->html_code; ?>
</div>
*/ ?>

<?php if(count($this->ads) >=1 ): ?>
<!--Render ads-->
<div class="pt-block">
    <h3 class="pt-title-right">Tài trợ <a href="/bang/index/create" class="smoothbox">Tạo mới</a></h3>
    <?php $ads = $this->ads; ?>
<?php foreach($ads as $key => $ad ): ?>
    <div class="advertisement">
        <div class="ad-photo">
            <?php echo $ad->html_code; ?>
        </div>
        <div class="ad-header">
            <div class="ad-title">
                <a href="javascript:void(0)" ><?php echo $ad->title ?></a>
            </div>
            <div class="ad-subtitle">
                <?php echo $ad->subtitle ?>
            </div>
        </div>
        <div class="ad-description">
            <?php echo $ad->description ?>
        </div>
    </div>
<?php endforeach; ?>
</div>

<style>
    div.advertisement {padding: 10px 10px 0px 10px;}
    div.ad-header{margin: 10px 0px 5px;}
    div.ad-title a{color: #758286;font-size: 14px;}
    div.ad-subtitle{font-size: 11px; font-style: italic}
    div.ad-photo {overflow: hidden;}
    div.ad-photo a{display: block; width: 100%}
    div.ad-photo a img{display: block; width: 99%; border: 1px solid #e5e5e5}
    div.ad-description {padding:0px 0px 10px;font-size: 11px; color: #758286;border-bottom: 1px solid #e5e5e5;}
</style>

<?php else: ?>
<!--No ads to render-->
<?php endif; ?>
