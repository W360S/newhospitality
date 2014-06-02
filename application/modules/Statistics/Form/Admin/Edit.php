<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Album
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Edit.php 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */

/**
 * @category   Application_Extensions
 * @package    Album
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Statistics_Form_Admin_Edit extends Statistics_Form_Admin_Create
{
    public function init()
      {
        parent::init();
        $this->setTitle('Edit statistics page')
          ->setDescription('Edit your statistics page below.');
        $this->submit->setLabel('Save Changes');
      }
}