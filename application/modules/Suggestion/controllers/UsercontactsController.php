<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: UsercontactsController.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_UsercontactsController extends Core_Controller_Action_Standard
{
	//https://www.google.com/accounts/ManageDomains
  //FUNCTION FOR GETTING GOOGLE CONTACTS OF THE REQUESTED USER.
  public function getgooglecontactsAction () {

	$this->_helper->layout->disableLayout();
	include_once APPLICATION_PATH . '/application/modules/Suggestion/Api/googleapi.php';
	$session = new Zend_Session_Namespace();
	$session->windowlivemsnredirect = 0;		
	$session->yahooredirect = 0;
	$session->googleredirect =1;	
	$session->aolredirect = 0;
	$viewer = $this->_helper->api()->user()->getViewer();
	$user_id = $viewer->getIdentity();
	

	// the domain that you entered when registering your application for redirecting from google site.
	$callback = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getBaseUrl() . '/suggestions/friends_suggestions';
	
	// var_dump($callback); exit;
	//HERE WE ARE CHECKING IF REQUEST IS NOT AN AJAX REQUEST THEN WE WILL REDIRECT TO GOOGLE SITE.FOR GETTING TOKEN.
    if (empty($_POST['task'])) {

      $scope  = "http://www.google.com/m8/feeds/contacts/default/";
      $googleUri = Zend_Gdata_AuthSub::getAuthSubTokenUri($callback,urlencode($scope), 0, 1);
      
	  header('location: ' . $googleUri);
    }
    
	//IF THE TASK IS TO SHOWING THE LIST OF FRIENDS.
	if (!empty($_POST['task']) && $_POST['task'] == 'get_googlecontacts') {

		//IF WE GET THE TOKEN MEANS GOOGLE HAS RESPOND SUCCESSFULLY.THIS IS ONE TIME USES TOKEN
		if (!empty($_POST['token'])) {
			$token = urldecode($_POST['token']);

			//CHECKING THE AUTHENTICITY OF REQUESTED USER EITHER THIS TOKEN IS VALID OR NOT.
			$result = GoogleContactsAuth ($token);
			
			if (!empty($result)) {

				$session->googleredirect = 0;

				//FETCHING THE ALL GOOGLE CONTACTS OF THIS USER.
				$GoogleContacts =  GoogleContactsAll($result);

				//NOW WE WILL PARSE THE RESULT ACCORDING TO HOW MANY USERS ARE MEMBERS OF THIS SITE.
				if (!empty($GoogleContacts)) {
					$SiteNonSiteFriends = $this->parseUserContacts ($GoogleContacts);
					 
					if (!empty($SiteNonSiteFriends[0]))  {
						$this->view->task = 'show_sitefriend';
						$this->view->addtofriend = $SiteNonSiteFriends[0];
					}
					if (!empty($SiteNonSiteFriends[1])) { 
						$this->view->addtononfriend = $SiteNonSiteFriends[1];
					}
				}

				if (empty($SiteNonSiteFriends[0]) && empty($SiteNonSiteFriends[1])) {
					$this->view->errormessage = true;
				}
			}
		}
	}

  }

  //FUNCTION FOR GETTING YAHOO CONTACTS OF THE REQUESTED USER.
  public function getyahoocontactsAction () {

   		$session = new Zend_Session_Namespace();
		$this->_helper->layout->disableLayout();

		// the domain that you entered when registering your application for redirecting from google site.
	 	$callback = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getBaseUrl() . '/suggestions/friends_suggestions';
		include_once APPLICATION_PATH . '/application/modules/Suggestion/Api/yahoo/getreqtok.php';

		//STEP:1 FIRST WE WILL GET REQUEST VALID OAUTH TOKEN OAUTH TOKEN SECRET FROM YAHOO.
		if (empty($_POST['oauth_verifier'])) {
			$session->windowlivemsnredirect = 0;		
			$session->yahooredirect = 1;
			$session->googleredirect = 0;	
			$session->aolredirect = 0;
			// Get the request token using HTTP GET and HMAC-SHA1 signature
			$retarr = get_request_token(OAUTH_CONSUMER_KEY, OAUTH_CONSUMER_SECRET,
																	$callback, false, true, true);
			//var_dump($retarr); exit;
			if (! empty($retarr) && is_array($retarr) ) { 
				unset($session->oauth_token_secret);	
				unset($session->oauth_token);				
				$session->oauth_token_secret = $retarr[3]['oauth_token_secret'];
				$session->oauth_token = $retarr[3]['oauth_token'];
				$redirecturl = urldecode($retarr[3]['xoauth_request_auth_url']);
				header('location: ' . $redirecturl);
			}
		}

		//STEP:2 AFTER GETTING REQUESTED OAUTH TOKE AND OAUTH TOKEN SECRET WE WILL GET OAUTH VERIFIER BY GRANTING ACCESS TO THIRD PARTY FOR FATCHING YAHOO CONTACTS.
		else if (!empty($_POST['oauth_verifier'])) {
			$session->redirect = 0;
			$request_token=$session->oauth_token;
			$request_token_secret=$session->oauth_token_secret;
			$oauth_verifier= $_POST['oauth_verifier'];
			//STEP:3 AFTER GETTING OAUTH VERIFIER AND OTHER TOKENS WE WILL AGAIN CALL YAHOO API TO GET OAUTH VERIFY SUCCESS TOKEN.
			$retarr = get_access_token(OAUTH_CONSUMER_KEY, OAUTH_CONSUMER_SECRET, $request_token, $request_token_secret, $oauth_verifier, false, true, true);	
			
			if (!empty($retarr)) {

				$guid=$retarr[3]['xoauth_yahoo_guid'];
				$access_token=urldecode($retarr[3]['oauth_token']);
				$access_token_secret=$retarr[3]['oauth_token_secret'];

				// Call Contact API
				$YahooContacts = callcontact(OAUTH_CONSUMER_KEY, OAUTH_CONSUMER_SECRET, $guid, $access_token, $access_token_secret,false, true);
                 		
				//NOW WE WILL PARSE THE RESULT ACCORDING TO HOW MANY USERS ARE MEMBERS OF THIS SITE.
				if (!empty($YahooContacts)) {

					$SiteNonSiteFriends = $this->parseUserContacts ($YahooContacts);
						   
					if (!empty($SiteNonSiteFriends[0]))  {
						$this->view->task = 'show_sitefriend';
						$this->view->addtofriend = $SiteNonSiteFriends[0];
					}

					if (!empty($SiteNonSiteFriends[1])) { 
						$this->view->addtononfriend = $SiteNonSiteFriends[1];
					}
				}

				if (empty($SiteNonSiteFriends[0]) && empty($SiteNonSiteFriends[1])) {
					$this->view->errormessage = true;
				}

			}

		}

	}
	
	//FUNCTION FOR GETTING WINDOW LIVE  CONTACTS OF THE REQUESTED USER.
	public function getwindowlivecontactsAction () {
		$session = new Zend_Session_Namespace();
		$session->windowlivemsnredirect = 1;		
		$session->yahooredirect = 0;
		$session->googleredirect = 0;
		$session->aolredirect = 0;	
		$this->_helper->layout->disableLayout();

		// the domain that you entered when registering your application for redirecting from google site.
		$callback = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getBaseUrl() . '/suggestions/friends_suggestions';
		
		include_once APPLICATION_PATH . '/application/modules/Suggestion/Api/LiveContactsPHP/contacts_fn.php';
		//var_dump(123); exit;
		$cookie = @$_COOKIE[$COOKIE];
		
		//WE WILL INCLUDE THIS FILE AFTER WE WILL GET BACK FROM WINDOW LIVE SITE HAVING SUCCESSFULL AUTHENTICATION.THIS FILE IS USED TO SET THE COOKIES AFTER GETTING //SUCCESSFULL AUTHENTICATION AND THEN REDIRECTING TO AT CALLBACK URL.
		if ($session->redirect) {
			include_once APPLICATION_PATH . '/application/modules/Suggestion/Api/LiveContactsPHP/delauth-handler.php';
		}
		
		//initialize Windows Live Libraries
		$wll = WindowsLiveLogin::initFromXml($KEYFILE);
//var_dump( @$_COOKIE[$COOKIE]); exit;
		// If the raw consent token has been cached in a site cookie, attempt to

		// process it and extract the consent token.
		$token = null;
		
		if ($cookie) {
			$token = $wll->processConsentToken($cookie);
			//var_dump($token); exit;
		}
//var_dump($token); exit;
		//Check if there's consent and, if not, redirect to the login page
		if ($token && !$token->isValid()) {
			$token = null;
		}

		if ($token==null) {
			$session->redirect = 1;
			$consenturl = $wll->getConsentUrl($OFFERS);	
			
			header( 'Location:'.$consenturl) ;
		}
    
		//HERE WE ARE CHECKING IF THE VALID TOKEN IS ALREADY COOKIED AND ACTIVE AND REQUEST IS NOT AJAX THEN WE WILL REDIRECT IT TO CALLBACK URL.
		if ($token && empty($_POST['task'])) {
			header("Location: $callback");
		}
   
		//IF REQUEST IS AJAX FOR SHOWING WINDOW LIVE CONTACTS.
		if ($token) { 
			
			$WindowLiveContacts = get_people_array($token);
			$session->windowliveredirect = 0;		
			//NOW WE WILL PARSE THE RESULT ACCORDING TO HOW MANY USERS ARE MEMBERS OF THIS SITE.
			if (!empty($WindowLiveContacts)) {
				$SiteNonSiteFriends = $this->parseUserContacts ($WindowLiveContacts);
				if (!empty($SiteNonSiteFriends[0]))  {
					$this->view->task = 'show_sitefriend';
					$this->view->addtofriend = $SiteNonSiteFriends[0];
				}
				if (!empty($SiteNonSiteFriends[1])) { 
					$this->view->addtononfriend = $SiteNonSiteFriends[1];
				}
			}
			if (empty($SiteNonSiteFriends[0]) && empty($SiteNonSiteFriends[1])) {
				  $this->view->errormessage = true;
			}
		}
	}


	//FUNCTION FOR GETTING WINDOW LIVE  CONTACTS OF THE REQUESTED USER.
	public function getaolcontactsAction () {
		$this->_helper->layout->disableLayout();
		$session = new Zend_Session_Namespace();
		$session->windowlivemsnredirect = 0;		
		$session->yahooredirect = 0;
		$session->googleredirect =0;	
		$session->aolredirect = 1;

		include_once APPLICATION_PATH . '/application/modules/Suggestion/Api/aolapi.php';

		if (!empty($session->aol_email)) {

			$AolContacts = getaolcontacts ($session->aol_email, $session->aol_password, false);

			//NOW WE WILL PARSE THE RESULT ACCORDING TO HOW MANY USERS ARE MEMBERS OF THIS SITE.
			if (!empty($AolContacts)) {
				$SiteNonSiteFriends = $this->parseUserContacts ($AolContacts);
				if (!empty($SiteNonSiteFriends[0]))  {
					$this->view->task = 'show_sitefriend';
					$this->view->addtofriend = $SiteNonSiteFriends[0];
				}
				if (!empty($SiteNonSiteFriends[1])) { 
					$this->view->addtononfriend = $SiteNonSiteFriends[1];
				}
			}

			if (empty($SiteNonSiteFriends[0]) && empty($SiteNonSiteFriends[1])) {
				  $this->view->errormessage = true;
			}
		}

  }


  //FUNTION FOR GETTING USERNAME AND PASSWORD OF AOL MAIL.
  public function aolloginAction() {

		$this->_helper->layout->disableLayout();
		$this->view->form = $form = new Suggestion_Form_Aollogin();

		if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {

			include_once APPLICATION_PATH . '/application/modules/Suggestion/Api/aolapi.php';

			$values = $form->getValues();
			$session = new Zend_Session_Namespace();
			$session->windowlivemsnredirect = 0;		
			$session->yahooredirect = 0;
			$session->googleredirect =0;	
			$session->aolredirect = 1;
			$loginsuccess = getaolcontacts($values['email'], $values['password'], true);

			if ($loginsuccess) {
				$session->aol_email = $values['email'];
				$session->aol_password = $values['password'];		
				// the domain that you entered when registering your application for redirecting from google site.
				$callback = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getBaseUrl() . '/suggestions/friends_suggestions';
				header('location:'. $callback);
			} else {
				$this->view->error = Zend_Registry::get('Zend_Translate')->_("Incorrect Username or Password");
			}
		}
  }
	
	
 //FUNCTION FOR PARSING USER CONTACTS IN 2 PARTS SITE MEMBERS AND NONSITE MEMBERS.
  public function parseUserContacts ($UserContacts) {
		$viewer = $this->_helper->api()->user()->getViewer();
		$user_id = $viewer->getIdentity();
		$table_user = Engine_Api::_()->getitemtable('user');
		$tableName_user = $table_user->info('name');
		$table_user_memberships = Engine_Api::_()->getDbtable('membership' , 'user');
		$tableName_user_memberships = $table_user_memberships->info('name');
		$SiteNonSiteFriends[] = '';
		foreach ($UserContacts as $values) {

			//FIRST WE WILL FIND IF THIS USER IS SITE MEMBER
			$select = $table_user->select()
			->setIntegrityCheck(false)
			->from($tableName_user, array('user_id', 'displayname', 'photo_id'))
			->where('email = ?', $values['contactMail']);

			$is_site_members = $table_user->fetchAll($select);
						
			//NOW IF THIS USER IS SITE MEMBER THEN WE WILL FIND IF HE IS FRINED OF THE OWNER.
			if (!empty($is_site_members[0]->user_id) && $is_site_members[0]->user_id != $user_id) {
				$contact = $this->_helper->api()->user()->getUser($is_site_members[0]->user_id);
				// check that user has not blocked the member
				if(!$viewer->isBlocked($contact)) {
					// The contact should not be my friend, and neither of us should have sent a friend request to the other.
					$select = $table_user_memberships->select()
					->setIntegrityCheck(false)
					->from($tableName_user_memberships, array('user_id'))
					->where($tableName_user_memberships . '.resource_id = ' . $user_id .' AND ' . $tableName_user_memberships . '.user_id = ' . $is_site_members[0]->user_id )
					->orwhere($tableName_user_memberships . '.resource_id = ' . $is_site_members[0]->user_id .' AND ' . $tableName_user_memberships . '.user_id = ' .$user_id );
					$already_friend = $table_user->fetchAll($select);
					
					//IF THIS QUERY RETURNS EMPTY RESULT MEANS THIS USER IS SITE MEMBER BUT NOT FRIEND OF CURRENTLY LOGGEDIN USER SO WE WILL SEND HIM TO FRIENDSHIP REQUEST.
					if (empty($already_friend[0]->user_id)) { 
						$SiteNonSiteFriends[0][] = $is_site_members;
					}
				}
			}
			//IF USER IS NOT SITE MEMBER .
			else {
				$SiteNonSiteFriends[1][] = $values;
			}
		}

		return $SiteNonSiteFriends;
	}

	//FUNCTION FOR GETTING CSV FILE CONTACTS OF THE REQUESTED USER.
	function getcsvcontactsAction () {

		$this->_helper->layout->disableLayout();
		$session = new Zend_Session_Namespace();
		$filebaseurl = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getBaseUrl() . '/public/suggestion/csvfiles/'; 
		$validator = new Zend_Validate_EmailAddress();
		$fp = fopen($filebaseurl . $session->filename,'r') or die("can't open file");
		$k = 0;	

		//READING THE CSV FILE AND FINDING THE EMAIL FOR CORROSPONDING ROW.
		while($csv_line = fgetcsv($fp,4096)) {
			for ($i = 0, $j = count($csv_line); $i < $j; $i++) {
				if ($validator->isValid($csv_line[$i])) {
					$usercontacs_csv[$k]['contactMail'] =  $csv_line[$i];
					$usercontacs_csv[$k]['contactName'] =  $csv_line[$i];
					$k++;
					break;
				}
			}
		}

		//CLOSING THE FILE AFTER READING. 
		fclose($fp) or die("can't close file");

		//AFTER READING THE FILE WE ARE UNLINKING THE FILE.
		$filebaseurl = APPLICATION_PATH.'/public/suggestion/csvfiles/'.$session->filename;
		@unlink($filebaseurl);
		unset($session->filename);
		if (!empty($usercontacs_csv)) {
		  sort($usercontacs_csv);
			$SiteNonSiteFriends = $this->parseUserContacts ($usercontacs_csv);
			if (!empty($SiteNonSiteFriends[0]))  {
				$this->view->task = 'show_sitefriend';
				$this->view->addtofriend = $SiteNonSiteFriends[0];
			}
			if (!empty($SiteNonSiteFriends[1])) { 
				$this->view->addtononfriend = $SiteNonSiteFriends[1];
			}
		}
		if (empty($SiteNonSiteFriends[0]) && empty($SiteNonSiteFriends[1])) {
			$this->view->errormessage = true;
		}
	}

	public function uploadsAction() { 
		// Prepare
		if( empty($_FILES['Filedata']) ) {
		  $this->view->error = Zend_Registry::get('Zend_Translate')->_('File failed to upload. Check your server settings (such as php.ini max_upload_filesize).');
		  return;
		}

		$session = new Zend_Session_Namespace();
		$session->filename = $_FILES['Filedata']['name'];		
		$file_path = APPLICATION_PATH . '/public/suggestion/csvfiles';

		if( !is_dir($file_path) && !mkdir($file_path, 0777, true) ) {
			//$filename = APPLICATION_PATH . "/application/languages/$localeCode/custom.csv";
			mkdir(dirname($file_path));
			chmod(dirname($file_path), 0777);
			touch($file_path);
			chmod($file_path, 0777);
		}	
    
		// Prevent evil files from being uploaded
		$disallowedExtensions = array('php');
		if (in_array(end(explode(".", $_FILES['Filedata']['name'])), $disallowedExtensions)) {
		  $this->view->error = Zend_Registry::get('Zend_Translate')->_('File type or extension forbidden.');
		  return;
		}
		
		$info = $_FILES['Filedata'];
		$targetFile = $file_path . '/' . $info['name'];
		$vals = array();

		if( file_exists($targetFile) ) {
		  $deleteUrl = $this->view->url(array('action' => 'delete')) . '?path=' . $relPath . '/' . $info['name'];
		  $deleteUrlLink = '<a href="'.$this->view->escape($deleteUrl) . '">' . Zend_Registry::get('Zend_Translate')->_("delete") . '</a>';
		  $this->view->error = Zend_Registry::get('Zend_Translate')->_("File already exists. Please %s before trying to upload.", $deleteUrlLink);
		  return;
		}

		if( !is_writable($file_path) ) {
		  $this->view->error = Zend_Registry::get('Zend_Translate')->_('Path is not writeable. Please CHMOD 0777 the public/admin directory.');
		  return;
		}
		
		// Try to move uploaded file
		if( !move_uploaded_file($info['tmp_name'], $targetFile) ) {
		  $this->view->error = Zend_Registry::get('Zend_Translate')->_("Unable to move file to upload directory.");
		  return;
		}
		
		$this->view->status = 1;

//     if( null === $this->_helper->contextSwitch->getCurrentContext() ) {
//       return $this->_helper->redirector->gotoRoute(array('action' => 'index'));
//     }
	}


}

?>
