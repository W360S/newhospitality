<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     Alex
 */
?>

<h2>
  <?php echo $this->translate("Log Browser") ?>
</h2>

<p>
  <?php echo $this->translate("CORE_VIEWS_SCRIPTS_ADMINSYSTEM_LOG_DESCRIPTION") ?>
</p>

<?php
  $settings = Engine_Api::_()->getApi('settings', 'core');
  if( $settings->getSetting('user.support.links', 0) == 1 ) {
    echo 'More info: <a href="http://anonym.to/http://support.socialengine.com/questions/216/Admin-Panel-Stats-Log-Browser" target="_blank">See KB article</a>.';	
  } 
?>	

<br />
<br />

<script type="text/javascript">
  window.addEvent('domready', function() {
    var el = $$('.admin_logs')[0];
    if( el ) {
      el.scrollTo(0, el.getScrollSize().y);
    }
    $('clear').addEvent('click', function() {
      if( $('file').get('value').trim() == '' ) {
        return;
      }
      var url = '<?php echo $this->url() ?>?clear=1';
      url += '&file=' + encodeURI($('file').get('value'));
      $('filter_form')
        .set('action', url)
        .set('method', 'POST')
        .submit();
        ;
    });
    $('download').addEvent('click', function() {
      if( $('file').get('value').trim() == '' ) {
        return;
      }
      var url = '<?php echo $this->url(array('action' => 'download')) ?>';
      url += '?file=' + encodeURI($('file').get('value'));
      (new IFrame({
        src : url,

        styles : {
          display : 'none'
        }
      })).inject(document.body);
    });
  });
</script>

<?php if( !empty($this->formFilter) ): ?>
  <div class="admin_search">
    <div class="search">
      <?php echo $this->formFilter->render($this) ?>
    </div>
  </div>

  <br />
<?php endif; ?>

<?php if( $this->error ): ?>
  <ul class="form-notices">
    <li>
      <?php echo $this->error ?>
    </li>
  </ul>
<?php endif; ?>


<?php if( !empty($this->logText) ): ?>

  <div class="admin_logs_container">

    <div class="admin_logs_info">
      <?php echo $this->translate(
        'Showing the last %1$s lines, %2$s bytes from the end. The file\'s size is %3$s bytes.',
        $this->locale()->toNumber($this->logLength),
        $this->locale()->toNumber($this->logSize - $this->logOffset),
        $this->locale()->toNumber($this->logSize)
      ) ?>
    </div>
    <br />

    <div class="admin_logs_nav">
      <span class="admin_logs_nav_next">
        <?php if( $this->logEndOffset > 0 ): ?>
          <a href="<?php echo $this->url() ?>?<?php echo http_build_query(array(
            'file' => $this->logName,
            'length' => $this->logLength,
            'offset' => $this->logEndOffset,
          )) ?>">
            Next
          </a>
        <?php endif; ?>
      </span>
      <?php if( $this->logOffset < $this->logSize ): ?>
        <span class="admin_logs_nav_previous">
          <a href="<?php echo $this->url() ?>?<?php echo http_build_query(array(
            'file' => $this->logName,
          )) ?>">
            Back to End
          </a>
        </span>
      <?php endif; ?>
    </div>

    <div class="admin_logs">
      <pre><?php echo $this->logText ?></pre>
    </div>
    
  </div>
<?php endif; ?>