<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: async.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>
<html>
  <head>
    <script type="text/javascript">
      parent.en4.core.dloader.handleLoad(<?php echo Zend_Json::encode($this->layout()->content) ?>);
    </script>
  </head>
  <body>

  </body>
</html>
