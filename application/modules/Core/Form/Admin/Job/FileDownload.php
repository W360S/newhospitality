<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: FileDownload.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Form_Admin_Job_FileDownload extends Engine_Form
{
  public function init()
  {
    $this
      ->setTitle('Job: Download File')
      ->setDescription('This will download a file from a specified URL.')
      ;

    $this->addElement('Text', 'url', array(
      'label' => 'URL',
      'required' => true,
      'allowEmpty' => false,
      //'validators' => array(),
    ));

    $this->addElement('Text', 'file', array(
      'label' => 'File',
      'required' => true,
      'allowEmpty' => false,
      //'validators' => array(),
    ));

    $this->addElement('Button', 'execute', array(
      'label' => 'Add',
      'type' => 'submit',
      'ignore' => true,
    ));
  }
}