<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Statistics.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Plugin_Task_Statistics extends Core_Plugin_Task_Abstract
{
  public function execute()
  {
  }

  protected function _phpinfo()
  {
    ob_start();
    phpinfo(-1);
    $phpinfo = ob_get_clean();

    $phpinfo = preg_replace(array(
      '#^.*<body>(.*)</body>.*$#ms', '#<h2>PHP License</h2>.*$#ms',
      '#<h1>Configuration</h1>#',  "#\r?\n#", "#</(h1|h2|h3|tr)>#", '# +<#',
      "#[ \t]+#", '#&nbsp;#', '#  +#', '# class=".*?"#', '%&#039;%',
      '#<tr>(?:.*?)" src="(?:.*?)=(.*?)" alt="PHP Logo" /></a>'
      .'<h1>PHP Version (.*?)</h1>(?:\n+?)</td></tr>#',
      '#<h1><a href="(?:.*?)\?=(.*?)">PHP Credits</a></h1>#',
      '#<tr>(?:.*?)" src="(?:.*?)=(.*?)"(?:.*?)Zend Engine (.*?),(?:.*?)</tr>#',
      "# +#", '#<tr>#', '#</tr>#'
    ), array(
      '$1', '', '', '', '</$1>' . "\n", '<', ' ', ' ', ' ', '', ' ',
      '<h2>PHP Configuration</h2>'."\n".'<tr><td>PHP Version</td><td>$2</td></tr>'.
      "\n".'<tr><td>PHP Egg</td><td>$1</td></tr>',
      '<tr><td>PHP Credits Egg</td><td>$1</td></tr>',
      '<tr><td>Zend Engine</td><td>$2</td></tr>' . "\n" .
      '<tr><td>Zend Egg</td><td>$1</td></tr>', ' ', '%S%', '%E%'
    ), $phpinfo);

    $sections = explode('<h2>', strip_tags($phpinfo, '<h2><th><td>'));
    unset($sections[0]);

    $phpinfo = array();
    foreach( $sections as $section ) {
      $n = substr($section, 0, strpos($section, '</h2>'));
      preg_match_all('#%S%(?:<td>(.*?)</td>)?(?:<td>(.*?)</td>)?(?:<td>(.*?)</td>)?%E%#', $section, $matches, PREG_SET_ORDER);
      foreach( $matches as $m ) {
        if( isset($m[2]) && (!isset($m[3]) || $m[2] == $m[3]) ) {
          $phpinfo[$n][$m[1]] = $m[2];
        } else {
          $phpinfo[$n][$m[1]] = array_slice($m,2);
        }
        //$phpinfo[$n][$m[1]] = ( !isset($m[3] ) || $m[2] == $m[3] ) ? $m[2] : array_slice($m,2);
      }
    }

    return $phpinfo;
  }
}