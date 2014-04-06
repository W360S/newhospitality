<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: googleapi.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

//CHECKING FOR AUTHENTICATION.
function GoogleContactsAuth($token) {
        
  include_once('Zend/Loader.php');
  $GoogleContactsService = 'cp';
  try {
  $GoogleContactsClient   =  Zend_Gdata_AuthSub::getHttpClient($token);
	//Zend_Gdata_ClientLogin::getHttpClient($GoogleContactsEmail,$GoogleContactsPass, $GoogleContactsService);
	return $GoogleContactsClient;
  }catch (Exception $e) {
	echo Zend_Registry::get('Zend_Translate')->_('You are not authorize to access this location.');
  }

}

//GETTING ALL GOOGLE CONTACTS.
function GoogleContactsAll($GoogleContactsClient) { 
  $scope          = "http://www.google.com/m8/feeds/contacts/default/";
 try {
	$gdata          = new Zend_Gdata($GoogleContactsClient);
	
	$query          = new Zend_Gdata_Query($scope.'full');
	
	$query->setMaxResults(10000);
	
	$feed           = $gdata->retrieveAllEntriesForFeed($gdata->getFeed($query));
	
	foreach ($feed as $entry) {

	  $contactName = $entry->title->text;

	  $ext = $entry->getExtensionElements();

	  foreach($ext as $extension) {

		if($extension->rootElement == "email") {

		  $attr=$extension->getExtensionAttributes();

		  $contactMail = $attr['address']['value'];

		}
		if($contactName=="") {
		  $contactName = $contactMail;
		}

	  }

	  $arrContactsData['contactMail'] = $contactMail;

	  $arrContactsData['contactName'] = $contactName;
	
	  $arrContacts[] = $arrContactsData;
	}
  sort($arrContacts);
	return $arrContacts;
  }
  catch (Exception $e) {
   echo Zend_Registry::get('Zend_Translate')->_('<ul class="form-notices"><li>Your contacts could not be retrieved right now. Please try after some time.</li></ul>');die;
 }
}

?> 
