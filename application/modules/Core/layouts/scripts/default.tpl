<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: default.tpl 10017 2013-03-27 01:27:56Z jung $
 * @author     John
 */
?>
<?php echo $this->doctype()->__toString() ?>
<?php $locale = $this->locale()->getLocale()->__toString();
$orientation = ( $this->layout()->orientation == 'right-to-left' ? 'rtl' : 'ltr' ); ?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<?php echo $locale ?>" lang="<?php echo $locale ?>" dir="<?php echo $orientation ?>">
    <head>
        <base href="<?php echo rtrim((constant('_ENGINE_SSL') ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'] . $this->baseUrl(), '/') . '/' ?>" />


        <?php // ALLOW HOOKS INTO META ?>
<?php echo $this->hooks('onRenderLayoutDefault', $this) ?>


        <?php // TITLE/META ?>
        <?php
        $counter = (int) $this->layout()->counter;
        $staticBaseUrl = $this->layout()->staticBaseUrl;
        $headIncludes = $this->layout()->headIncludes;

        $request = Zend_Controller_Front::getInstance()->getRequest();
        $this->headTitle()
                ->setSeparator(' - ');
        $pageTitleKey = 'pagetitle-' . $request->getModuleName() . '-' . $request->getActionName()
                . '-' . $request->getControllerName();
        $pageTitle = $this->translate($pageTitleKey);
        if ($pageTitle && $pageTitle != $pageTitleKey) {
            $this
                    ->headTitle($pageTitle, Zend_View_Helper_Placeholder_Container_Abstract::PREPEND);
        }
        $this
                ->headTitle($this->translate($this->layout()->siteinfo['title']), Zend_View_Helper_Placeholder_Container_Abstract::PREPEND)
        ;
        $this->headMeta()
                ->appendHttpEquiv('Content-Type', 'text/html; charset=UTF-8')
                ->appendHttpEquiv('Content-Language', $this->locale()->getLocale()->__toString());

        // Make description and keywords
        $description = '';
        $keywords = '';

        $description .= ' ' . $this->layout()->siteinfo['description'];
        $keywords = $this->layout()->siteinfo['keywords'];

        if ($this->subject() && $this->subject()->getIdentity()) {
            $this->headTitle($this->subject()->getTitle());

            $description .= ' ' . $this->subject()->getDescription();
            if (!empty($keywords))
                $keywords .= ',';
            $keywords .= $this->subject()->getKeywords(',');
        }

        $this->headMeta()->appendName('description', trim($description));
        $this->headMeta()->appendName('keywords', trim($keywords));

        // Get body identity
        if (isset($this->layout()->siteinfo['identity'])) {
            $identity = $this->layout()->siteinfo['identity'];
        } else {
            $identity = $request->getModuleName() . '-' .
                    $request->getControllerName() . '-' .
                    $request->getActionName();
        }
        ?>
<?php echo $this->headTitle()->toString() . "\n" ?>
        <?php echo $this->headMeta()->toString() . "\n" ?>


        <?php // LINK/STYLES ?>
        <?php
        $this->headLink(array(
            'rel' => 'favicon',
            'href' => ( isset($this->layout()->favicon) ? $staticBaseUrl . $this->layout()->favicon : '/favicon.ico' ),
            'type' => 'image/x-icon'), 'PREPEND');
        $themes = array();
        if (!empty($this->layout()->themes)) {
            $themes = $this->layout()->themes;
        } else {
            $themes = array('default');
        }
        foreach ($themes as $theme) {
            if (APPLICATION_ENV != 'development') {
                //$this->headLink()
                //        ->prependStylesheet($staticBaseUrl . 'application/modules/Core/externals/styles/jquery-ui.css');
                $this->headLink()
                        ->prependStylesheet($staticBaseUrl . 'application/css.php?request=application/themes/' . $theme . '/theme.css');
                $this->headLink()
                        ->prependStylesheet($staticBaseUrl . 'application/modules/Core/externals/styles/jquery.fancybox.css');
                        $this->headLink()
                        ->prependStylesheet($staticBaseUrl . 'application/themes/newhospitality/phuongtt.css');
                

                // $this->headLink()
                        // ->prependStylesheet($staticBaseUrl . 'application/modules/Core/externals/styles/jquery.classyscroll.css');
            } else {
                //$this->headLink()
                //        ->prependStylesheet(rtrim($this->baseUrl(), '/') . '/application/modules/Core/externals/styles/jquery-ui.css');
                $this->headLink()
                        ->prependStylesheet(rtrim($this->baseUrl(), '/') . '/application/css.php?request=application/themes/' . $theme . '/theme.css');
            
                $this->headLink()
                        ->prependStylesheet(rtrim($this->baseUrl(), '/') . '/application/modules/Core/externals/styles/jquery.fancybox.css');
                        $this->headLink()
                        ->prependStylesheet(rtrim($this->baseUrl(), '/') . '/application/themes/newhospitality/phuongtt.css');
                
                // $this->headLink()
                        // ->prependStylesheet(rtrim($this->baseUrl(), '/') . '/application/modules/Core/externals/styles/jquery.classyscroll.css');
            }
        }
        // Process
        foreach ($this->headLink()->getContainer() as $dat) {
            if (!empty($dat->href)) {
                if (false === strpos($dat->href, '?')) {
                    $dat->href .= '?c=' . $counter;
                } else {
                    $dat->href .= '&c=' . $counter;
                }
            }
        }
        ?>
        <?php echo $this->headLink()->toString() . "\n" ?>
        <?php echo $this->headStyle()->toString() . "\n" ?>

        <?php // TRANSLATE  ?>
        <?php $this->headScript()->prependScript($this->headTranslate()->toString()) ?>

        <?php // SCRIPTS  ?>
        <script type="text/javascript">if (window.location.hash == '#_=_')
                window.location.hash = '';</script>
        <script type="text/javascript">
<?php echo $this->headScript()->captureStart(Zend_View_Helper_Placeholder_Container_Abstract::PREPEND) ?>
            Date.setServerOffset('<?php echo date('D, j M Y G:i:s O', time()) ?>');
            en4.orientation = '<?php echo $orientation ?>';
            en4.core.environment = '<?php echo APPLICATION_ENV ?>';
            en4.core.language.setLocale('<?php echo $this->locale()->getLocale()->__toString() ?>');
            en4.core.setBaseUrl('<?php echo $this->url(array(), 'default', true) ?>');
            en4.core.staticBaseUrl = '<?php echo $this->escape($staticBaseUrl) ?>';
            en4.core.loader = new Element('img', {src: en4.core.staticBaseUrl + 'application/modules/Core/externals/images/loading.gif'});
<?php if ($this->subject()): ?>
                en4.core.subject = {
                    type: '<?php echo $this->subject()->getType(); ?>',
                    id: <?php echo $this->subject()->getIdentity(); ?>,
                    guid: '<?php echo $this->subject()->getGuid(); ?>'
                };
<?php endif; ?>
<?php if ($this->viewer()->getIdentity()): ?>
                en4.user.viewer = {
                    type: '<?php echo $this->viewer()->getType(); ?>',
                    id: <?php echo $this->viewer()->getIdentity(); ?>,
                    guid: '<?php echo $this->viewer()->getGuid(); ?>'
                };
<?php endif; ?>
            if (<?php echo ( Engine_Api::_()->getDbtable('settings', 'core')->core_dloader_enabled ? 'true' : 'false' ) ?>) {
                en4.core.runonce.add(function() {
                    en4.core.dloader.attach();
                });
            }

<?php echo $this->headScript()->captureEnd(Zend_View_Helper_Placeholder_Container_Abstract::PREPEND) ?>
        </script>
        <?php
        
        /*
        $this->headScript()
                ->prependFile($staticBaseUrl . 'application/modules/Core/externals/scripts/common.js')
                //->prependFile($staticBaseUrl . 'application/modules/Core/externals/scripts/jquery.classyscroll.js')
                ->prependFile($staticBaseUrl . 'application/modules/Core/externals/scripts/jquery-ui.js')
                ->prependFile($staticBaseUrl . 'application/modules/Core/externals/scripts/jquery.fancybox.js')
                ->prependFile($staticBaseUrl . 'application/modules/Core/externals/scripts/jquery.masonry.min.js')
                ->prependFile($staticBaseUrl . 'application/modules/Core/externals/scripts/jquery-1.10.2.min.js');*/
        

        $this->headScript()
                ->prependFile($staticBaseUrl . 'externals/soundmanager/script/soundmanager2.js')
                ->prependFile($staticBaseUrl . 'externals/smoothbox/smoothbox4.js')
                ->prependFile($staticBaseUrl . 'application/modules/User/externals/scripts/core.js')
                ->prependFile($staticBaseUrl . 'application/modules/Core/externals/scripts/core.js')
                ->prependFile($staticBaseUrl . 'externals/chootools/chootools.js')
                
                ->prependFile($staticBaseUrl . 'externals/mootools/mootools-more-1.4.0.1-full-compat-' . (APPLICATION_ENV == 'development' ? 'nc' : 'yc') . '.js')
                ->prependFile($staticBaseUrl . 'externals/mootools/mootools-core-1.4.5-full-compat-' . (APPLICATION_ENV == 'development' ? 'nc' : 'yc') . '.js');
        // Process
        foreach ($this->headScript()->getContainer() as $dat) {
            if (!empty($dat->attributes['src'])) {
                if (false === strpos($dat->attributes['src'], '?')) {
                    $dat->attributes['src'] .= '?c=' . $counter;
                } else {
                    $dat->attributes['src'] .= '&c=' . $counter;
                }
            }
        }
        ?>
        <?php echo $this->headScript()->toString() . "\n" ?>



        <?php echo $headIncludes ?>


        <style type="text/css">
            @font-face {
                font-family: 'open_sansregular';
                src: url('application/themes/newhospitality/font/opensans-regular.eot');
                src: url('application/themes/newhospitality/font/opensans-regular.eot?#iefix') format('embedded-opentype'),
                    url('application/themes/newhospitality/font/opensans-regular.woff') format('woff'),
                    url('application/themes/newhospitality/font/opensans-regular.ttf') format('truetype'),
                    url('application/themes/newhospitality/font/opensans-regular.svg#open_sansregular') format('svg');
                font-weight: normal;
                font-style: normal;

            }
        </style>

        

    </head>
    <body id="global_page_<?php echo $identity ?>">
        <script src="<?php echo $this->baseUrl().'/application/modules/Core/externals/scripts/jquery-1.10.2.min.js'?>" type="text/javascript"></script>
        <script>
        //lam chu chay
            var title= document.title;
            var espera=200;
            var refresco;
            function auto_title() {
                document.title= title;
                title=title.substring(1, title.length)+title.charAt(0);
                refresco = setTimeout("auto_title();", espera);
            }

        </script>
        <script type="javascript/text">
            if(DetectIpad()){
            $$('a.album_main_upload').setStyle('display', 'none');
            $$('a.album_quick_upload').setStyle('display', 'none');
            $$('a.icon_photos_new').setStyle('display', 'none');
            }
        </script>  

        <div id="global_header">
            <?php echo $this->content('header') ?>
        </div>
        <div id='global_wrapper'>
            <div>
                <?php echo $this->content('navigator') ?>
            </div>
            <div id='global_content'>
                <?php //echo $this->content('global-user', 'before') ?>
                <?php echo $this->layout()->content ?>
                <?php //echo $this->content('global-user', 'after') ?>
            </div>
        </div>
        <div id="global_footer">
            <?php echo $this->content('footer') ?>
        </div>
         <script type="text/javascript">
        soundManager.onload = function() {
              soundManager.createSound({
              id: 'demo_inline_music',
              url: 'public/beep.mp3',
              autoLoad: true,
              autoPlay: false,
              onload: function() {
                
              },
              volume: 50
            });    
        }
        </script> 
        <div id="janrainEngageShare" style="display:none">Share</div>
        
        <script src="<?php echo $this->baseUrl() . '/externals/viethosp/jquery.form.js' ?>" type="text/javascript"></script>
        <script src="<?php echo $this->baseUrl().'/application/modules/Core/externals/scripts/jquery.fancybox.js'?>" type="text/javascript"></script>
        
        <script src="<?php echo $this->baseUrl().'/application/modules/Core/externals/scripts/jquery-ui.js'?>" type="text/javascript"></script>
        <script src="<?php echo $this->baseUrl().'/application/modules/Core/externals/scripts/common.js'?>" type="text/javascript"></script>
        <script src="<?php echo $this->baseUrl().'/application/modules/Core/externals/scripts/jquery.validate.js'?>" type="text/javascript"></script>
        
    </body>
</html>