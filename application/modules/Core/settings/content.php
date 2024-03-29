<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: content.php 9823 2012-11-20 00:40:35Z matthew $
 * @author     John
 */
return array(
  array(
    'title' => 'HTML Block',
    'description' => 'Inserts any HTML of your choice.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.html-block',
    'special' => 1,
    'autoEdit' => true,
    'adminForm' => array(
      'elements' => array(
        array(
          'Text',
          'title',
          array(
            'label' => 'Title'
          )
        ),
        array(
          'Textarea',
          'data',
          array(
            'label' => 'HTML'
          )
        ),
      )
    ),
  ),
  array(
    'title' => 'Ad Campaign',
    'description' => 'Shows one of your ad banners. Requires that you have at least one active ad campaign.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.ad-campaign',
   // 'special' => 1,
    'autoEdit' => true,
    'adminForm' => 'Core_Form_Admin_Widget_Ads',
  ),
  array(
    'title' => 'Tab Container',
    'description' => 'Adds a container with a tab menu. Any other blocks you drop inside it will become tabs.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.container-tabs',
    'special' => 1,
    'defaultParams' => array(
      'max' => 6
    ),
    'canHaveChildren' => true,
    'childAreaDescription' => 'Adds a container with a tab menu. Any other blocks you drop inside it will become tabs.',
    //'special' => 1,
    'adminForm' => array(
      'elements' => array(
        array(
          'Text',
          'title',
          array(
            'label' => 'Title',
          )
        ),
        array(
          'Select',
          'max',
          array(
            'label' => 'Max Tab Count',
            'description' => 'Show sub menu at x containers.',
            'default' => 4,
            'multiOptions' => array(
              0 => 0,
              1 => 1,
              2 => 2,
              3 => 3,
              4 => 4,
              5 => 5,
              6 => 6,
              7 => 7,
              8 => 8,
              9 => 9,
            )
          )
        ),
      )
    ),
  ),
  array(
    'title' => 'Content',
    'description' => 'Shows the page\'s primary content area. (Not all pages have primary content)',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.content',
    'requirements' => array(
      'page-content',
    ),
  ),
  array(
    'title' => 'Footer Menu',
    'description' => 'Shows the site-wide footer menu. You can edit its contents in your menu editor.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.menu-footer',
    'requirements' => array(
      'header-footer',
    ),
  ),
  array(
    'title' => 'Generic Menu',
    'description' => 'Shows a selected menu. You can edit its contents in your menu editor.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.menu-generic',
    'adminForm' => 'Core_Form_Admin_Widget_MenuGeneric',
  ),
  array(
    'title' => 'Main Menu',
    'description' => 'Shows the site-wide main menu. You can edit its contents in your menu editor.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.menu-main',
    'requirements' => array(
      'header-footer',
    ),
  ),
  array(
    'title' => 'Mini Menu',
    'description' => 'Shows the site-wide mini menu. You can edit its contents in your menu editor.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.menu-mini',
    'requirements' => array(
      'header-footer',
    ),
  ),
  array(
    'title' => 'Site Logo',
    'description' => 'Shows your site-wide main logo or title.  Images are uploaded via the <a href="admin/files" target="_parent">File Media Manager</a>.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.menu-logo',
    'adminForm' => 'Core_Form_Admin_Widget_Logo',
    'requirements' => array(
      'header-footer',
    ),
  ),
  array(
    'title' => 'Profile Links',
    'description' => 'Displays a member\'s, group\'s, or event\'s links on their profile.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.profile-links',
    'isPaginated' => true,
    'defaultParams' => array(
      'title' => 'Links',
      'titleCount' => true,
    ),
    'requirements' => array(
      'subject',
    ),
  ),
  array(
    'title' => 'Statistics',
    'description' => 'Shows some basic usage statistics about your community.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.statistics',
    'defaultParams' => array(
      'title' => 'Statistics'
    ),
    'requirements' => array(
      'no-subject',
    ),
  ),
  array(
    'title' => 'Comments',
    'description' => 'Shows the comments about an item.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.comments',
    'defaultParams' => array(
      'title' => 'Comments'
    ),
    'requirements' => array(
      'subject',
    ),
  ),
  array(
    'title' => 'Theme Chooser',
    'description' => 'Allows a member to switch to any of the currently installed themes.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.theme-choose',
    'defaultParams' => array(
      'title' => 'Themes'
    ),
  ),
  array(
    'title' => 'Contact Form',
    'description' => 'Displays the contact form.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.contact',
    'requirements' => array(
      'no-subject',
    ),
    'defaultParams' => array(
      'title' => 'Contact',
      'titleCount' => true,
    ),
  ),
  array(
    'title' => 'Search Bar',
    'description' => 'Add the ability to search your site\'s content on any page.',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.search',    
  ),
  array(
    'title' => 'Home Login',
    'description' => 'Home Login Block',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.home-login',
    'requirements' => array(
      'header-footer',
    ),
  ),
  array(
    'title' => 'Home Features',
    'description' => 'Home Features Block',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.home-features',
    'requirements' => array(
      'header-footer',
    ),
  ),
  array(
    'title' => 'Home Headlines',
    'description' => 'Home Headlines Block',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.home-headlines',
    'requirements' => array(
      'header-footer',
    ),
  ),
  array(
    'title' => 'Home Login Button',
    'description' => 'Home Login Button Block',
    'category' => 'Core',
    'type' => 'widget',
    'name' => 'core.home-loginbutton',
    'requirements' => array(
      'header-footer',
    ),
  ),
) ?>