<?php

class Resumes_Bootstrap extends Engine_Application_Bootstrap_Abstract
{
     public function __construct($application)
	 {
		parent::__construct($application);
		
		// Add view helper and action helper paths
		$this->initViewHelperPath();
		$this->initActionHelperPath();
        /*
        require_once APPLICATION_PATH . '/application/libraries/Zend/dompdf/dompdf_config.inc.php';
        //Zend_Loader::registerAutoload();
        spl_autoload_register('DOMPDF_autoload'); 
		*/
	  }
}