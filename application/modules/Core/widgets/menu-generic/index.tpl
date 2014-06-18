<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<?php
  echo $this->navigation()
    ->menu()
    ->setContainer($this->navigation)
    ->setPartial(null)
    ->setUlClass($this->ulClass)
    ->render();
?>
