<?php

/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: AuthController.php 9951 2013-02-23 00:11:25Z jung $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class User_AuthController extends Core_Controller_Action_Standard {
    
    private $tmp_file_id;

    public function loginAction() {
        // Already logged in
        if (Engine_Api::_()->user()->getViewer()->getIdentity()) {
            $this->view->status = false;
            $this->view->error = Zend_Registry::get('Zend_Translate')->_('You are already signed in.');
            if (null === $this->_helper->contextSwitch->getCurrentContext()) {
                $this->_helper->redirector->gotoRoute(array(), 'default', true);
                ;
            }
            return;
        }

        // Make form
        $this->view->form = $form = new User_Form_Login();
        $form->setAction($this->view->url(array('return_url' => null)));
        $form->populate(array(
            'return_url' => $this->_getParam('return_url'),
        ));

        // Facebook login
//    if( User_Model_DbTable_Facebook::authenticate($form) ) {
//      // Facebook login succeeded, redirect to home
//      return $this->_helper->redirector->gotoRoute(array(), 'default', true);
//    }
        // Render
        $this->_helper->content
                //->setNoRender()
                ->setEnabled()
        ;

        // Not a post
        if (!$this->getRequest()->isPost()) {
            $this->view->status = false;
            $this->view->error = Zend_Registry::get('Zend_Translate')->_('No action taken');
            return;
        }

        // Form not valid
        if (!$form->isValid($this->getRequest()->getPost())) {
            $this->view->status = false;
            $this->view->error = Zend_Registry::get('Zend_Translate')->_('Invalid data');
            return;
        }

        // Check login creds
        extract($form->getValues()); // $email, $password, $remember
        $user_table = Engine_Api::_()->getDbtable('users', 'user');
        $user_select = $user_table->select()
                ->where('email = ?', $email);          // If post exists
        $user = $user_table->fetchRow($user_select);

        // Get ip address
        $db = Engine_Db_Table::getDefaultAdapter();
        $ipObj = new Engine_IP();
        $ipExpr = new Zend_Db_Expr($db->quoteInto('UNHEX(?)', bin2hex($ipObj->toBinary())));

        // Check if user exists
        if (empty($user)) {
            $this->view->status = false;
            $this->view->error = Zend_Registry::get('Zend_Translate')->_('No record of a member with that email was found.');
            $form->addError(Zend_Registry::get('Zend_Translate')->_('No record of a member with that email was found.'));

            // Register login
            Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                'email' => $email,
                'ip' => $ipExpr,
                'timestamp' => new Zend_Db_Expr('NOW()'),
                'state' => 'no-member',
            ));

            return;
        }

        // Check if user is verified and enabled
        if (!$user->enabled) {
            if (!$user->verified) {
                $this->view->status = false;

                $resend_url = $this->_helper->url->url(array('action' => 'resend', 'email' => $email), 'user_signup', true);
                $translate = Zend_Registry::get('Zend_Translate');
                $error = $translate->translate('This account still requires either email verification.');
                $error .= ' ';
                $error .= sprintf($translate->translate('Click <a href="%s">here</a> to resend the email.'), $resend_url);
                $form->getDecorator('errors')->setOption('escape', false);
                $form->addError($error);

                // Register login
                Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                    'user_id' => $user->getIdentity(),
                    'email' => $email,
                    'ip' => $ipExpr,
                    'timestamp' => new Zend_Db_Expr('NOW()'),
                    'state' => 'disabled',
                ));

                return;
            } else if (!$user->approved) {
                $this->view->status = false;

                $translate = Zend_Registry::get('Zend_Translate');
                $error = $translate->translate('This account still requires admin approval.');
                $form->getDecorator('errors')->setOption('escape', false);
                $form->addError($error);

                // Register login
                Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                    'user_id' => $user->getIdentity(),
                    'email' => $email,
                    'ip' => $ipExpr,
                    'timestamp' => new Zend_Db_Expr('NOW()'),
                    'state' => 'disabled',
                ));

                return;
            }
            // Should be handled by hooks or payment
            //return;
        }

        // Handle subscriptions
        if (Engine_Api::_()->hasModuleBootstrap('payment')) {
            // Check for the user's plan
            $subscriptionsTable = Engine_Api::_()->getDbtable('subscriptions', 'payment');
            if (!$subscriptionsTable->check($user)) {
                // Register login
                Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                    'user_id' => $user->getIdentity(),
                    'email' => $email,
                    'ip' => $ipExpr,
                    'timestamp' => new Zend_Db_Expr('NOW()'),
                    'state' => 'unpaid',
                ));
                // Redirect to subscription page
                $subscriptionSession = new Zend_Session_Namespace('Payment_Subscription');
                $subscriptionSession->unsetAll();
                $subscriptionSession->user_id = $user->getIdentity();
                return $this->_helper->redirector->gotoRoute(array('module' => 'payment',
                            'controller' => 'subscription', 'action' => 'index'), 'default', true);
            }
        }

        // Run pre login hook
        $event = Engine_Hooks_Dispatcher::getInstance()->callEvent('onUserLoginBefore', $user);
        foreach ((array) $event->getResponses() as $response) {
            if (is_array($response)) {
                if (!empty($response['error']) && !empty($response['message'])) {
                    $form->addError($response['message']);
                } else if (!empty($response['redirect'])) {
                    $this->_helper->redirector->gotoUrl($response['redirect'], array('prependBase' => false));
                } else {
                    continue;
                }

                // Register login
                Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                    'user_id' => $user->getIdentity(),
                    'email' => $email,
                    'ip' => $ipExpr,
                    'timestamp' => new Zend_Db_Expr('NOW()'),
                    'state' => 'third-party',
                ));

                // Return
                return;
            }
        }

        // Version 3 Import compatibility
        if (empty($user->password)) {
            $compat = Engine_Api::_()->getApi('settings', 'core')->getSetting('core.compatibility.password');
            $migration = null;
            try {
                $migration = Engine_Db_Table::getDefaultAdapter()->select()
                        ->from('engine4_user_migration')
                        ->where('user_id = ?', $user->getIdentity())
                        ->limit(1)
                        ->query()
                        ->fetch();
            } catch (Exception $e) {
                $migration = null;
                $compat = null;
            }
            if (!$migration) {
                $compat = null;
            }

            if ($compat == 'import-version-3') {

                // Version 3 authentication
                $cryptedPassword = self::_version3PasswordCrypt($migration['user_password_method'], $migration['user_code'], $password);
                if ($cryptedPassword === $migration['user_password']) {
                    // Regenerate the user password using the given password
                    $user->salt = (string) rand(1000000, 9999999);
                    $user->password = $password;
                    $user->save();
                    Engine_Api::_()->user()->getAuth()->getStorage()->write($user->getIdentity());
                    // @todo should we delete the old migration row?
                } else {
                    $this->view->status = false;
                    $this->view->error = Zend_Registry::get('Zend_Translate')->_('Invalid credentials');
                    $form->addError(Zend_Registry::get('Zend_Translate')->_('Invalid credentials supplied'));
                    return;
                }
                // End Version 3 authentication
            } else {
                $form->addError('There appears to be a problem logging in. Please reset your password with the Forgot Password link.');

                // Register login
                Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                    'user_id' => $user->getIdentity(),
                    'email' => $email,
                    'ip' => $ipExpr,
                    'timestamp' => new Zend_Db_Expr('NOW()'),
                    'state' => 'v3-migration',
                ));

                return;
            }
        }

        // Normal authentication
        else {
            $authResult = Engine_Api::_()->user()->authenticate($email, $password);
            $authCode = $authResult->getCode();
            Engine_Api::_()->user()->setViewer();

            if ($authCode != Zend_Auth_Result::SUCCESS) {
                $this->view->status = false;
                $this->view->error = Zend_Registry::get('Zend_Translate')->_('Invalid credentials');
                $form->addError(Zend_Registry::get('Zend_Translate')->_('Invalid credentials supplied'));

                // Register login
                Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                    'user_id' => $user->getIdentity(),
                    'email' => $email,
                    'ip' => $ipExpr,
                    'timestamp' => new Zend_Db_Expr('NOW()'),
                    'state' => 'bad-password',
                ));

                return;
            }
        }

        // -- Success! --
        // Register login
        $loginTable = Engine_Api::_()->getDbtable('logins', 'user');
        $loginTable->insert(array(
            'user_id' => $user->getIdentity(),
            'email' => $email,
            'ip' => $ipExpr,
            'timestamp' => new Zend_Db_Expr('NOW()'),
            'state' => 'success',
            'active' => true,
        ));
        $_SESSION['login_id'] = $login_id = $loginTable->getAdapter()->lastInsertId();

        // Remember
        if ($remember) {
            $lifetime = 1209600; // Two weeks
            Zend_Session::getSaveHandler()->setLifetime($lifetime, true);
            Zend_Session::rememberMe($lifetime);
        }

        // Increment sign-in count
        Engine_Api::_()->getDbtable('statistics', 'core')
                ->increment('user.logins');

        // Test activity @todo remove
        $viewer = Engine_Api::_()->user()->getViewer();
        if ($viewer->getIdentity()) {
            $viewer->lastlogin_date = date("Y-m-d H:i:s");
            if ('cli' !== PHP_SAPI) {
                $viewer->lastlogin_ip = $ipExpr;
            }
            $viewer->save();
            Engine_Api::_()->getDbtable('actions', 'activity')
                    ->addActivity($viewer, $viewer, 'login');
        }

        // Assign sid to view for json context
        $this->view->status = true;
        $this->view->message = Zend_Registry::get('Zend_Translate')->_('Login successful');
        $this->view->sid = Zend_Session::getId();
        $this->view->sname = Zend_Session::getOptions('name');

        // Run post login hook
        $event = Engine_Hooks_Dispatcher::getInstance()->callEvent('onUserLoginAfter', $viewer);

        // Do redirection only if normal context
        if (null === $this->_helper->contextSwitch->getCurrentContext()) {
            // Redirect by form
            $uri = $form->getValue('return_url');
            if ($uri) {
                if (substr($uri, 0, 3) == '64-') {
                    $uri = base64_decode(substr($uri, 3));
                }
                return $this->_redirect($uri, array('prependBase' => false));
            }

            // Redirect by session
            $session = new Zend_Session_Namespace('Redirect');
            if (isset($session->uri)) {
                $uri = $session->uri;
                $opts = $session->options;
                $session->unsetAll();
                return $this->_redirect($uri, $opts);
            } else if (isset($session->route)) {
                $session->unsetAll();
                return $this->_helper->redirector->gotoRoute($session->params, $session->route, $session->reset);
            }

            // Redirect by hook
            foreach ((array) $event->getResponses() as $response) {
                if (is_array($response)) {
                    if (!empty($response['error']) && !empty($response['message'])) {
                        return $form->addError($response['message']);
                    } else if (!empty($response['redirect'])) {
                        return $this->_helper->redirector->gotoUrl($response['redirect'], array('prependBase' => false));
                    }
                }
            }

            // Just redirect to home
            return $this->_helper->redirector->gotoRoute(array('action' => 'home'), 'user_general', true);
        }
    }

    public function logoutAction() {
        // Check if already logged out
        $viewer = Engine_Api::_()->user()->getViewer();
        if (!$viewer->getIdentity()) {
            $this->view->status = false;
            $this->view->error = Zend_Registry::get('Zend_Translate')->_('You are already logged out.');
            if (null === $this->_helper->contextSwitch->getCurrentContext()) {
                $this->_helper->redirector->gotoRoute(array(), 'default', true);
            }
            return;
        }

        // Run logout hook
        $event = Engine_Hooks_Dispatcher::getInstance()->callEvent('onUserLogoutBefore', $viewer);

        // Test activity @todo remove
        Engine_Api::_()->getDbtable('actions', 'activity')
                ->addActivity($viewer, $viewer, 'logout');

        // Update online status
        $onlineTable = Engine_Api::_()->getDbtable('online', 'user')
                ->delete(array(
            'user_id = ?' => $viewer->getIdentity(),
        ));

        // Logout
        Engine_Api::_()->user()->getAuth()->clearIdentity();

        if (!empty($_SESSION['login_id'])) {
            Engine_Api::_()->getDbtable('logins', 'user')->update(array(
                'active' => false,
                    ), array(
                'login_id = ?' => $_SESSION['login_id'],
            ));
            unset($_SESSION['login_id']);
        }


        // Run logout hook
        $event = Engine_Hooks_Dispatcher::getInstance()->callEvent('onUserLogoutAfter', $viewer);

        $doRedirect = true;

        // Clear twitter/facebook session info
        // facebook api
        $facebookTable = Engine_Api::_()->getDbtable('facebook', 'user');
        $facebook = $facebookTable->getApi();
        $settings = Engine_Api::_()->getDbtable('settings', 'core');
        if ($facebook && 'none' != $settings->core_facebook_enable) {
            /*
              $logoutUrl = $facebook->getLogoutUrl(array(
              'next' => 'http://' . $_SERVER['HTTP_HOST'] . $this->view->url(array(), 'default', true),
              ));
             */
            if (method_exists($facebook, 'getAccessToken') &&
                    ($access_token = $facebook->getAccessToken())) {
                $doRedirect = false; // javascript will run to log them out of fb
                $this->view->appId = $facebook->getAppId();
                $access_array = explode("|", $access_token);
                if (($session_key = $access_array[1])) {
                    $this->view->fbSession = $session_key;
                }
            }
            try {
                $facebook->clearAllPersistentData();
            } catch (Exception $e) {
                // Silence
            }
        }

        unset($_SESSION['facebook_lock']);
        unset($_SESSION['facebook_uid']);

        // twitter api
        /*
          $twitterTable = Engine_Api::_()->getDbtable('twitter', 'user');
          $twitter = $twitterTable->getApi();
          $twitterOauth = $twitterTable->getOauth();
          if( $twitter && $twitterOauth ) {
          try {
          $result = $accountInfo = $twitter->account->end_session();
          } catch( Exception $e ) {
          // Silence
          echo $e;die();
          }
          }
         */
        unset($_SESSION['twitter_lock']);
        unset($_SESSION['twitter_token']);
        unset($_SESSION['twitter_secret']);
        unset($_SESSION['twitter_token2']);
        unset($_SESSION['twitter_secret2']);

        // Response
        $this->view->status = true;
        $this->view->message = Zend_Registry::get('Zend_Translate')->_('You are now logged out.');
        if ($doRedirect && null === $this->_helper->contextSwitch->getCurrentContext()) {
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }
    }

    public function forgotAction() {
        // Render
        $this->_helper->content
                //->setNoRender()
                ->setEnabled()
        ;

        // no logged in users
        if (Engine_Api::_()->user()->getViewer()->getIdentity()) {
            return $this->_helper->redirector->gotoRoute(array('action' => 'home'), 'user_general', true);
        }

        // Make form
        $this->view->form = $form = new User_Form_Auth_Forgot();

        // Check request
        if (!$this->getRequest()->isPost()) {
            return;
        }

        // Check data
        if (!$form->isValid($this->getRequest()->getPost())) {
            return;
        }

        // Check for existing user
        $user = Engine_Api::_()->getDbtable('users', 'user')
                ->fetchRow(array('email = ?' => $form->getValue('email')));
        if (!$user || !$user->getIdentity()) {
            $form->addError('A user account with that email was not found.');
            return;
        }

        // Check to make sure they're enabled
        if (!$user->enabled) {
            $form->addError('That user account has not yet been verified or disabled by an admin.');
            return;
        }

        // Ok now we can do the fun stuff
        $forgotTable = Engine_Api::_()->getDbtable('forgot', 'user');
        $db = $forgotTable->getAdapter();
        $db->beginTransaction();

        try {
            // Delete any existing reset password codes
            $forgotTable->delete(array(
                'user_id = ?' => $user->getIdentity(),
            ));

            // Create a new reset password code
            $code = base_convert(md5($user->salt . $user->email . $user->user_id . uniqid(time(), true)), 16, 36);
            $forgotTable->insert(array(
                'user_id' => $user->getIdentity(),
                'code' => $code,
                'creation_date' => date('Y-m-d H:i:s'),
            ));

            // Send user an email
            Engine_Api::_()->getApi('mail', 'core')->sendSystem($user, 'core_lostpassword', array(
                'host' => $_SERVER['HTTP_HOST'],
                'email' => $user->email,
                'date' => time(),
                'recipient_title' => $user->getTitle(),
                'recipient_link' => $user->getHref(),
                'recipient_photo' => $user->getPhotoUrl('thumb.icon'),
                'object_link' => $this->_helper->url->url(array('action' => 'reset', 'code' => $code, 'uid' => $user->getIdentity())),
                'queue' => false,
            ));

            // Show success
            $this->view->sent = true;

            $db->commit();
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    public function resetAction() {
        // no logged in users
        if (Engine_Api::_()->user()->getViewer()->getIdentity()) {
            return $this->_helper->redirector->gotoRoute(array('action' => 'home'), 'user_general', true);
        }

        // Check for empty params
        $user_id = $this->_getParam('uid');
        $code = $this->_getParam('code');

        if (empty($user_id) || empty($code)) {
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        // Check user
        $user = Engine_Api::_()->getItem('user', $user_id);
        if (!$user || !$user->getIdentity()) {
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        // Check code
        $forgotTable = Engine_Api::_()->getDbtable('forgot', 'user');
        $forgotSelect = $forgotTable->select()
                ->where('user_id = ?', $user->getIdentity())
                ->where('code = ?', $code);

        $forgotRow = $forgotTable->fetchRow($forgotSelect);
        if (!$forgotRow || (int) $forgotRow->user_id !== (int) $user->getIdentity()) {
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        // Code expired
        // Note: Let's set the current timeout for 6 hours for now
        $min_creation_date = time() - (3600 * 24);
        if (strtotime($forgotRow->creation_date) < $min_creation_date) { // @todo The strtotime might not work exactly right
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        // Make form
        $this->view->form = $form = new User_Form_Auth_Reset();
        $form->setAction($this->_helper->url->url(array()));

        // Check request
        if (!$this->getRequest()->isPost()) {
            return;
        }

        // Check data
        if (!$form->isValid($this->getRequest()->getPost())) {
            return;
        }

        // Process
        $values = $form->getValues();

        // Check same password
        if ($values['password'] !== $values['password_confirm']) {
            $form->addError('The passwords you entered did not match.');
            return;
        }

        // Db
        $db = $user->getTable()->getAdapter();
        $db->beginTransaction();

        try {
            // Delete the lost password code now
            $forgotTable->delete(array(
                'user_id = ?' => $user->getIdentity(),
            ));

            // This gets handled by the post-update hook
            $user->password = $values['password'];
            $user->save();

            $db->commit();

            $this->view->reset = true;
            //return $this->_helper->redirector->gotoRoute(array(), 'user_login', true);
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    private function _getFBInfo(){
        $facebookTable = Engine_Api::_()->getDbtable('facebook', 'user');
        $facebook = $facebookTable->getApi();
        $settings = Engine_Api::_()->getDbtable('settings', 'core');
        if ($facebook && $settings->core_facebook_enable) {
            // Get email address
            $apiInfo = $facebook->api('/me'); 

        }

        return isset($apiInfo) ? $apiInfo : false;

    }

    private function _isExistedUserEmail($email){
        $userTable = Engine_Api::_()->getItemTable('user');
        $userIdentity = $userTable->select()
                ->from($userTable, 'user_id')
                ->where('`email` = ?', $email)
                ->limit(1)
                ->query()
                ->fetchColumn(0)
        ;

        return $userIdentity;
    }

    // Array of user form
    // (
    //     [email] => bangvndng@yahoo.com
    //     [username] => bangvndng2015
    //     [profile_type] => 1
    //     [timezone] => Asia/Krasnoyarsk
    //     [language] => vi
    //     [terms] => 1
    //     [locale] => vi
    // )


    // Array of fields form
    // Array
    // (
    //     [1] => 1
    //     [3] => Bằng
    //     [4] => Vũ
    //     [5] => 2 //female 1, male 2
    //     [6] => Array
    //         (
    //             [day] => 20
    //             [month] => 5
    //             [year] => 1987
    //         )

    //     [21] => 19 // danang 19, hanoi 20
    //     [47] => 456456456 // phone
    //     [8] => 
    //     [10] => 
    //     [9] => 
    //     [46] => 23423 // nghe nghiep
    //     [41] => 
    //     [42] => 
    //     [39] => 
    //     [43] => 
    // )

    private function _sendNewmail($user){

        $mailType = null;
        $mailParams = array(
            'host' => $_SERVER['HTTP_HOST'],
            'email' => $user->email,
            'date' => time(),
            'recipient_title' => $user->getTitle(),
            'recipient_link' => $user->getHref(),
            'recipient_photo' => $user->getPhotoUrl('thumb.icon'),
            'object_link' => Zend_Controller_Front::getInstance()->getRouter()->assemble(array(), 'user_login', true),
        );

        // Add password to email if necessary
        if ($random) {
            $mailParams['password'] = $data['password'];
        }

        // Mail stuff
        switch ($settings->getSetting('user.signup.verifyemail', 0)) {
            case 0:
                // only override admin setting if random passwords are being created
                if ($random) {
                    $mailType = 'core_welcome_password';
                }
                if ($emailadmin) {
                    $mailAdminType = 'notify_admin_user_signup';

                    $mailAdminParams = array(
                        'host' => $_SERVER['HTTP_HOST'],
                        'email' => $user->email,
                        'date' => date("F j, Y, g:i a"),
                        'recipient_title' => $super_admin->displayname,
                        'object_title' => $user->displayname,
                        'object_link' => $user->getHref(),
                    );
                }
                break;

            case 1:
                // send welcome email
                $mailType = ($random ? 'core_welcome_password' : 'core_welcome');
                if ($emailadmin) {
                    $mailAdminType = 'notify_admin_user_signup';

                    $mailAdminParams = array(
                        'host' => $_SERVER['HTTP_HOST'],
                        'email' => $user->email,
                        'date' => date("F j, Y, g:i a"),
                        'recipient_title' => $super_admin->displayname,
                        'object_title' => $user->getTitle(),
                        'object_link' => $user->getHref(),
                    );
                }
                break;

            case 2:
                // verify email before enabling account
                $verify_table = Engine_Api::_()->getDbtable('verify', 'user');
                $verify_row = $verify_table->createRow();
                $verify_row->user_id = $user->getIdentity();
                $verify_row->code = md5($user->email
                        . $user->creation_date
                        . $settings->getSetting('core.secret', 'staticSalt')
                        . (string) rand(1000000, 9999999));
                $verify_row->date = $user->creation_date;
                $verify_row->save();

                $mailType = ($random ? 'core_verification_password' : 'core_verification');

                $mailParams['object_link'] = Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                    'action' => 'verify',
                    'email' => $user->email,
                    'verify' => $verify_row->code
                        ), 'user_signup', true);

                if ($emailadmin) {
                    $mailAdminType = 'notify_admin_user_signup';

                    $mailAdminParams = array(
                        'host' => $_SERVER['HTTP_HOST'],
                        'email' => $user->email,
                        'date' => date("F j, Y, g:i a"),
                        'recipient_title' => $super_admin->displayname,
                        'object_title' => $user->getTitle(),
                        'object_link' => $user->getHref(),
                    );
                }
                break;

            default:
                // do nothing
                break;
        }
    }

    protected function _resizeImages($file) {
        $name = basename($file);
        $path = dirname($file);

        // Resize image (main)
        $iMainPath = $path . '/m_' . $name;
        $image = Engine_Image::factory();
        $image->open($file)
                ->resize(720, 720)
                ->write($iMainPath)
                ->destroy();

        // Resize image (profile)
        $iProfilePath = $path . '/p_' . $name;
        $image = Engine_Image::factory();
        $image->open($file);
        
        $size = min($image->height, $image->width);
        $x = ($image->width - $size) / 2;
        $y = ($image->height - $size) / 2;

        $image->resample($x, $y, $size, $size, 200, 200)
                ->write($iProfilePath)
                ->destroy();

        // Resize image (icon.normal)
        $iNormalPath = $path . '/n_' . $name;
        $image = Engine_Image::factory();
        $image->open($file)
                ->resize(48, 120)
                ->write($iNormalPath)
                ->destroy();

        // Resize image (icon.square)
        $iSquarePath = $path . '/s_' . $name;
        $image = Engine_Image::factory();
        $image->open($file);
        $size = min($image->height, $image->width);
        $x = ($image->width - $size) / 2;
        $y = ($image->height - $size) / 2;
        $image->resample($x, $y, $size, $size, 48, 48)
                ->write($iSquarePath)
                ->destroy();

        // Cloud compatibility, put into storage system as temporary files
        $storage = Engine_Api::_()->getItemTable('storage_file');
        
        // Save/load from session
        if (empty($this->tmp_file_id)) {
            // Save
            $iMain = $storage->createTemporaryFile($iMainPath);
            $iProfile = $storage->createTemporaryFile($iProfilePath);
            $iNormal = $storage->createTemporaryFile($iNormalPath);
            $iSquare = $storage->createTemporaryFile($iSquarePath);

            $iMain->bridge($iProfile, 'thumb.profile');
            $iMain->bridge($iNormal, 'thumb.normal');
            $iMain->bridge($iSquare, 'thumb.icon');

            $this->tmp_file_id = $iMain->file_id;
        } else {
            // Overwrite
            
            /*
            $iMain = $storage->getFile($this->getSession()->tmp_file_id);
            $iMain->store($iMainPath);

            $iProfile = $storage->getFile($this->getSession()->tmp_file_id, 'thumb.profile');
            $iProfile->store($iProfilePath);

            $iNormal = $storage->getFile($this->getSession()->tmp_file_id, 'thumb.normal');
            $iNormal->store($iNormalPath);

            $iSquare = $storage->getFile($this->getSession()->tmp_file_id, 'thumb.icon');
            $iSquare->store($iSquarePath);
            */
            
        }

        // Save path to session?
        //$_SESSION['TemporaryProfileImg'] = $iMain->map();
        //$_SESSION['TemporaryProfileImgProfile'] = $iProfile->map();
        //$_SESSION['TemporaryProfileImgSquare'] = $iSquare->map();

        // Remove temp files
        @unlink($path . '/p_' . $name);
        @unlink($path . '/m_' . $name);
        @unlink($path . '/n_' . $name);
        @unlink($path . '/s_' . $name);
    }

    protected function _fetchImage($photo_url) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $photo_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_MAXREDIRS, 5);
        $data = curl_exec($ch);
        curl_close($ch);

        $tmpfile = APPLICATION_PATH_TMP . DS . md5($photo_url) . '.jpg';
        @file_put_contents($tmpfile, $data);

        $this->_resizeImages($tmpfile);
    }

    private function _updateFBPhoto($user, $fb_user_id){

        $photo_url = "https://graph.facebook.com/"
                            . $fb_user_id
                            . "/picture?type=large"
                    ;

        $this->_fetchImage($photo_url);
        
        $params = array(
            'parent_type' => 'user',
            'parent_id' => $user->user_id
        );

        // Save
        $storage = Engine_Api::_()->getItemTable('storage_file');

        // Update info
        $iMain = $storage->getFile($this->tmp_file_id);
        $iMain->setFromArray($params);
        $iMain->save();
        $iMain->updatePath();

        $iProfile = $storage->getFile($this->tmp_file_id, 'thumb.profile');
        $iProfile->setFromArray($params);
        $iProfile->save();
        $iProfile->updatePath();

        $iNormal = $storage->getFile($this->tmp_file_id, 'thumb.normal');
        $iNormal->setFromArray($params);
        $iNormal->save();
        $iNormal->updatePath();

        $iSquare = $storage->getFile($this->tmp_file_id, 'thumb.icon');
        $iSquare->setFromArray($params);
        $iSquare->save();
        $iSquare->updatePath();
        
        // Update row
        $user->photo_id = $iMain->file_id;
        $user->save();
    }

    private function _createAccount($facebook, $code){

        $facebook_data = $this->_getFBInfo();

        // user form

        $user = Engine_Api::_()->getDbtable('users', 'user')->createRow();

        $username = explode("@", $facebook_data['email']);
        $username = $username[0] . rand(1, 9999); 

        $data = array(
            "email" => $facebook_data['email'],
            "username" => $username,
            "profile_type" => 1,
            "timezone" => "Asia/Krasnoyarsk",
            "language" => "vi",
            "terms" => 1,
            "locale" => "vi",

        );

        $user->setFromArray($data);
        $user->save();

        $this->_updateFBPhoto($user, $facebook_data['id']);

        Engine_Api::_()->user()->setViewer($user);

        // Increment signup counter
        Engine_Api::_()->getDbtable('statistics', 'core')->increment('user.creations');

        if ($user->verified && $user->enabled) {
            // Create activity for them
            Engine_Api::_()->getDbtable('actions', 'activity')->addActivity($user, $user, 'signup');
            // Set user as logged in if not have to verify email
            Engine_Api::_()->user()->getAuth()->getStorage()->write($user->getIdentity());
        }

        //$this->_sendNewmail();

        try {
            $facebookTable = Engine_Api::_()->getDbtable('facebook', 'user');
            $facebook = $facebookTable->getApi();
            $settings = Engine_Api::_()->getDbtable('settings', 'core');
            if ($facebook && $settings->core_facebook_enable) {
                $facebookTable->insert(array(
                    'user_id' => $user->getIdentity(),
                    'facebook_uid' => $facebook->getUser(),
                    'access_token' => $facebook->getAccessToken(),
                    //'code' => $code,
                    'expires' => 0, // @todo make sure this is correct
                ));
            }
        } catch (Exception $e) {
            // Silence
            if ('development' == APPLICATION_ENV) {
                echo $e;
            }
        }



        // field form

        $fieldsSession = new User_Plugin_Signup_Fields();
        $form = $fieldsSession->getForm()->setItem($user);

        $fielddata = array(
            "1" => 1,
            "3" => $facebook_data['first_name'],
            "4" => $facebook_data['last_name'],
            "5" => ($facebook_data['gender'] == "female") ? 1 : 2,
            "6" => array(),
            "21" => 20,
            "47" => "cập nhật số điện thoại",
            "46" => "cập nhật nghề nghiệp hiện tại"
        );

        $form->setProcessedValues($fielddata);
        $form->saveValues();

        $aliasValues = Engine_Api::_()->fields()->getFieldsValuesByAlias($user);
        $user->setDisplayName($aliasValues);
        $user->save();

        // @todo: photo form

        // Get viewer
        $viewer = Engine_Api::_()->user()->getViewer();

        // Run post signup hook
        $event = Engine_Hooks_Dispatcher::getInstance()->callEvent('onUserSignupAfter', $viewer);
        $responses = $event->getResponses();
        if ($responses) {
            foreach ($event->getResponses() as $response) {
                if (is_array($response)) {
                    // Clear login status
                    if (!empty($response['error'])) {
                        Engine_Api::_()->user()->setViewer(null);
                        Engine_Api::_()->user()->getAuth()->getStorage()->clear();
                    }
                    // Redirect
                    if (!empty($response['redirect'])) {
                        return $this->_helper->redirector->gotoUrl($response['redirect'], array('prependBase' => false));
                    }
                }
            }
        }

        Engine_Api::_()->user()->getAuth()->getStorage()->write($viewer->getIdentity());
            Engine_Hooks_Dispatcher::getInstance()
                    ->callEvent('onUserEnable', $viewer);

        if ($viewer->getIdentity()) {
            $viewer->lastlogin_date = date("Y-m-d H:i:s");
            if ('cli' !== PHP_SAPI) {
                $ipObj = new Engine_IP();
                $viewer->lastlogin_ip = $ipObj->toBinary();
            }
            $viewer->save();
        }

        return $this->_helper->_redirector->gotoRoute(array('action' => 'home'), 'user_general', true);

    }

    public function facebookAction() {
        // Clear
        if (null !== $this->_getParam('clear')) {
            unset($_SESSION['facebook_lock']);
            unset($_SESSION['facebook_uid']);
        }

        $viewer = Engine_Api::_()->user()->getViewer();
        $facebookTable = Engine_Api::_()->getDbtable('facebook', 'user');
        $facebook = $facebookTable->getApi();
        $settings = Engine_Api::_()->getDbtable('settings', 'core');

        $db = Engine_Db_Table::getDefaultAdapter();
        $ipObj = new Engine_IP();
        $ipExpr = new Zend_Db_Expr($db->quoteInto('UNHEX(?)', bin2hex($ipObj->toBinary())));

        // Enabled?
        if (!$facebook || 'none' == $settings->core_facebook_enable) {
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        // Already connected
        if ($facebook->getUser()) {
            $code = $facebook->getPersistentData('code'); 


            // Attempt to login
            if (!$viewer->getIdentity()) {
                $facebook_uid = $facebook->getUser();
                //print_r($facebook_uid);die;
                if ($facebook_uid) {
                    $user_id = $facebookTable->select()
                            ->from($facebookTable, 'user_id')
                            ->where('facebook_uid = ?', $facebook_uid)
                            ->query()
                            ->fetchColumn();
                }

                $facebook_data = $this->_getFBInfo();

                if (isset($facebook_data) && isset($facebook_data['email'])) {
                    $userIdentity = $this->_isExistedUserEmail($facebook_data['email']);
                }

                if ($user_id &&
                        $viewer = Engine_Api::_()->getItem('user', $user_id)) {
                    Zend_Auth::getInstance()->getStorage()->write($user_id);

                    // Register login
                    $viewer->lastlogin_date = date("Y-m-d H:i:s");

                    if ('cli' !== PHP_SAPI) {
                        $viewer->lastlogin_ip = $ipExpr;

                        Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                            'user_id' => $user_id,
                            'ip' => $ipExpr,
                            'timestamp' => new Zend_Db_Expr('NOW()'),
                            'state' => 'success',
                            'source' => 'facebook',
                        ));
                    }

                    $viewer->save();
                } else if($userIdentity){
                    // Log user in.
                    $viewer = Engine_Api::_()->getItem('user', $userIdentity);

                    Zend_Auth::getInstance()->getStorage()->write($userIdentity);

                    // Register login
                    $viewer->lastlogin_date = date("Y-m-d H:i:s");

                    if ('cli' !== PHP_SAPI) {
                        $viewer->lastlogin_ip = $ipExpr;

                        Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                            'user_id' => $userIdentity,
                            'ip' => $ipExpr,
                            'timestamp' => new Zend_Db_Expr('NOW()'),
                            'state' => 'success',
                            'source' => 'facebook',
                        ));
                    }

                    $viewer->save();

                    // update table user_facebook
                    $facebookTable->insert(array(
                        'user_id' => $viewer->getIdentity(),
                        'facebook_uid' => $facebook->getUser(),
                        'access_token' => $facebook->getAccessToken(),
                        'code' => $code,
                        'expires' => 0, // @todo make sure this is correct
                    ));

                }else if ($facebook_uid) {
                    // They do not have an account

                    // User facebook information to create an account here
                    $this->_createAccount($facebook, $code);

                    // Then log the user in a

                    $_SESSION['facebook_signup'] = true;
                    return $this->_helper->redirector->gotoRoute(array(
                                    //'action' => 'facebook',
                                    ), 'user_signup', true);
                }
            } else {
                // Attempt to connect account
                $info = $facebookTable->select()
                        ->from($facebookTable)
                        ->where('user_id = ?', $viewer->getIdentity())
                        ->limit(1)
                        ->query()
                        ->fetch();
                if (empty($info)) {
                    $facebookTable->insert(array(
                        'user_id' => $viewer->getIdentity(),
                        'facebook_uid' => $facebook->getUser(),
                        'access_token' => $facebook->getAccessToken(),
                        'code' => $code,
                        'expires' => 0, // @todo make sure this is correct
                    ));
                } else {
                    //if( !empty($info['facebook_uid']) && $info['facebook_uid'] != $facebook->getUser() ) {
                    // Incorrect user
                    // Should we reconnect?
                    //} else {
                    // Save info to db
                    $facebookTable->update(array(
                        'facebook_uid' => $facebook->getUser(),
                        'access_token' => $facebook->getAccessToken(),
                        'code' => $code,
                        'expires' => 0, // @todo make sure this is correct
                            ), array(
                        'user_id = ?' => $viewer->getIdentity(),
                    ));
                    //}
                }
            }

            // Redirect to home
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        // Not connected
        else {
            // Okay
            if (!empty($_GET['code'])) {
                // This doesn't seem to be necessary anymore, it's probably
                // being handled in the api initialization
                return $this->_helper->redirector->gotoRoute(array(), 'default', true);
            }

            // Error
            else if (!empty($_GET['error'])) {
                // @todo maybe display a message?
                return $this->_helper->redirector->gotoRoute(array(), 'default', true);
            }

            // Redirect to auth page
            else {
                $url = $facebook->getLoginUrl(array(
                    'redirect_uri' => (_ENGINE_SSL ? 'https://' : 'http://')
                    . $_SERVER['HTTP_HOST'] . $this->view->url(),
                    'scope' => join(',', array(
                        'email',
                        'user_birthday',
                        'user_status',
                        'publish_stream',
                        'offline_access',
                    )),
                ));
                return $this->_helper->redirector->gotoUrl($url, array('prependBase' => false));
            }
        }
    }

    public function twitterAction() {
        // Clear
        if (null !== $this->_getParam('clear')) {
            unset($_SESSION['twitter_lock']);
            unset($_SESSION['twitter_token']);
            unset($_SESSION['twitter_secret']);
            unset($_SESSION['twitter_token2']);
            unset($_SESSION['twitter_secret2']);
        }

        if ($this->_getParam('denied')) {
            $this->view->error = 'Access Denied!';
            return;
        }

        // Setup
        $viewer = Engine_Api::_()->user()->getViewer();
        $twitterTable = Engine_Api::_()->getDbtable('twitter', 'user');
        $twitter = $twitterTable->getApi();
        $twitterOauth = $twitterTable->getOauth();

        $db = Engine_Db_Table::getDefaultAdapter();
        $ipObj = new Engine_IP();
        $ipExpr = new Zend_Db_Expr($db->quoteInto('UNHEX(?)', bin2hex($ipObj->toBinary())));

        // Check
        if (!$twitter || !$twitterOauth) {
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        // Connect
        try {

            $accountInfo = null;
            if (isset($_SESSION['twitter_token2'], $_SESSION['twitter_secret2'])) {
                // Try to login?
                if (!$viewer->getIdentity()) {
                    // Get account info
                    try {
                        $accountInfo = $twitter->account->verify_credentials();
                    } catch (Exception $e) {
                        // This usually happens when the application is modified after connecting
                        unset($_SESSION['twitter_token']);
                        unset($_SESSION['twitter_secret']);
                        unset($_SESSION['twitter_token2']);
                        unset($_SESSION['twitter_secret2']);
                        $twitterTable->clearApi();
                        $twitter = $twitterTable->getApi();
                        $twitterOauth = $twitterTable->getOauth();
                    }
                }
            }

            if (isset($_SESSION['twitter_token2'], $_SESSION['twitter_secret2'])) {
                // Try to login?
                if (!$viewer->getIdentity()) {

                    $info = $twitterTable->select()
                            ->from($twitterTable)
                            ->where('twitter_uid = ?', $accountInfo->id)
                            ->query()
                            ->fetch();

                    if (empty($info)) {
                        // They do not have an account
                        $_SESSION['twitter_signup'] = true;
                        return $this->_helper->redirector->gotoRoute(array(
                                        //'action' => 'twitter',
                                        ), 'user_signup', true);
                    } else {
                        Zend_Auth::getInstance()->getStorage()->write($info['user_id']);
                        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
                    }
                }
                // Success
                return $this->_helper->redirector->gotoRoute(array(), 'default', true);
            } else if (isset($_SESSION['twitter_token'], $_SESSION['twitter_secret'], $_GET['oauth_verifier'])) {
                $twitterOauth->getAccessToken('https://twitter.com/oauth/access_token', $_GET['oauth_verifier']);

                $_SESSION['twitter_token2'] = $twitter_token = $twitterOauth->getToken();
                $_SESSION['twitter_secret2'] = $twitter_secret = $twitterOauth->getTokenSecret();

                // Reload api?
                $twitterTable->clearApi();
                $twitter = $twitterTable->getApi();

                // Get account info
                $accountInfo = $twitter->account->verify_credentials();

                // Save to settings table (if logged in)
                if ($viewer->getIdentity()) {
                    $info = $twitterTable->select()
                            ->from($twitterTable)
                            ->where('user_id = ?', $viewer->getIdentity())
                            ->query()
                            ->fetch();

                    if (!empty($info)) {
                        $twitterTable->update(array(
                            'twitter_uid' => $accountInfo->id,
                            'twitter_token' => $twitter_token,
                            'twitter_secret' => $twitter_secret,
                                ), array(
                            'user_id = ?' => $viewer->getIdentity(),
                        ));
                    } else {
                        $twitterTable->insert(array(
                            'user_id' => $viewer->getIdentity(),
                            'twitter_uid' => $accountInfo->id,
                            'twitter_token' => $twitter_token,
                            'twitter_secret' => $twitter_secret,
                        ));
                    }

                    // Redirect
                    return $this->_helper->redirector->gotoRoute(array(), 'default', true);
                } else { // Otherwise try to login?
                    $info = $twitterTable->select()
                            ->from($twitterTable)
                            ->where('twitter_uid = ?', $accountInfo->id)
                            ->query()
                            ->fetch();

                    if (empty($info)) {
                        // They do not have an account
                        $_SESSION['twitter_signup'] = true;
                        return $this->_helper->redirector->gotoRoute(array(
                                        //'action' => 'twitter',
                                        ), 'user_signup', true);
                    } else {
                        Zend_Auth::getInstance()->getStorage()->write($info['user_id']);

                        // Register login
                        $viewer = Engine_Api::_()->getItem('user', $info['user_id']);
                        $viewer->lastlogin_date = date("Y-m-d H:i:s");

                        if ('cli' !== PHP_SAPI) {
                            $viewer->lastlogin_ip = $ipExpr;

                            Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                                'user_id' => $info['user_id'],
                                'ip' => $ipExpr,
                                'timestamp' => new Zend_Db_Expr('NOW()'),
                                'state' => 'success',
                                'source' => 'twitter',
                            ));
                        }

                        $viewer->save();

                        // Redirect
                        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
                    }
                }
            } else {

                unset($_SESSION['twitter_token']);
                unset($_SESSION['twitter_secret']);
                unset($_SESSION['twitter_token2']);
                unset($_SESSION['twitter_secret2']);

                // Reload api?
                $twitterTable->clearApi();
                $twitter = $twitterTable->getApi();
                $twitterOauth = $twitterTable->getOauth();

                // Connect account
                $twitterOauth->getRequestToken('https://twitter.com/oauth/request_token', 'http://' . $_SERVER['HTTP_HOST'] . $this->view->url());

                $_SESSION['twitter_token'] = $twitterOauth->getToken();
                $_SESSION['twitter_secret'] = $twitterOauth->getTokenSecret();

                $url = $twitterOauth->getAuthorizeUrl('http://twitter.com/oauth/authenticate');

                return $this->_helper->redirector->gotoUrl($url, array('prependBase' => false));
            }
        } catch (Services_Twitter_Exception $e) {
            if (in_array($e->getCode(), array(500, 502, 503))) {
                $this->view->error = 'Twitter is currently experiencing technical issues, please try again later.';
                return;
            } else {
                throw $e;
            }
        } catch (Exception $e) {
            throw $e;
        }
    }

    public function janrainAction() {
        // Exit if no token is posted
        if (!($token = $this->_getParam('token'))) {
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        // Get settings
        $settings = Engine_Api::_()->getDbtable('settings', 'core');
        $janrainSettings = $settings->core_janrain;
        if (empty($janrainSettings['key']) ||
                empty($janrainSettings['enable']) ||
                $janrainSettings['enable'] == 'none') {
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        // Get info
        $viewer = Engine_Api::_()->user()->getViewer();
        $janrainTable = Engine_Api::_()->getDbtable('janrain', 'user');

        $db = Engine_Db_Table::getDefaultAdapter();
        $ipObj = new Engine_IP();
        $ipExpr = new Zend_Db_Expr($db->quoteInto('UNHEX(?)', bin2hex($ipObj->toBinary())));

        $log = Zend_Registry::get('Zend_Log');

        // Call auth_info
        $post_data = array('token' => $token,
            'apiKey' => $janrainSettings['key'],
            'format' => 'json',
            'extended' => 'false'); //Extended is not available to Basic.

        $curl = curl_init();
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_URL, 'https://rpxnow.com/api/v2/auth_info');
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $post_data);
        curl_setopt($curl, CURLOPT_HEADER, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_FAILONERROR, true);
        $result = curl_exec($curl);
        if ($result == false) {
            $log->log(
                    'Janrain Error' . PHP_EOL .
                    'Curl error: ' . curl_error($curl) . PHP_EOL .
                    'HTTP code: ' . curl_errno($curl) . PHP_EOL .
                    var_export($post_data, true), Zend_Log::DEBUG);
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }
        curl_close($curl);

        // Decode json
        $auth_info = Zend_Json::decode($result, true);

        if ($auth_info['stat'] !== 'ok') {
            $log->log(
                    'Janrain Error' . PHP_EOL .
                    var_export($result, true) . PHP_EOL .
                    var_export($auth_info, true), Zend_Log::DEBUG);
            return $this->_helper->redirector->gotoRoute(array(), 'default', true);
        }

        $profile = $auth_info['profile'];
        if (!empty($auth_info['merged_poco'])) {
            $profile['merged_poco'] = $auth_info['merged_poco'];
        }
        $identifier = $profile['identifier'];
        $provider = $profile['providerName'];

        // Check if already exists
        $info = $janrainTable->select()
                ->from($janrainTable)
                ->where('identifier = ?', $identifier)
                ->limit(1)
                ->query()
                ->fetch();

        if ($info) {
            if ($viewer->getIdentity()) {
                // Already associated
                $this->view->error = 'That account has already been connected to ' .
                        'another member on this site.';
            } else {
                // Sign-in
                Zend_Auth::getInstance()->getStorage()->write($info['user_id']);

                // Register login
                $viewer = Engine_Api::_()->getItem('user', $info['user_id']);
                $viewer->lastlogin_date = date("Y-m-d H:i:s");

                if ('cli' !== PHP_SAPI) {
                    $viewer->lastlogin_ip = $ipExpr;

                    Engine_Api::_()->getDbtable('logins', 'user')->insert(array(
                        'user_id' => $info['user_id'],
                        'ip' => $ipExpr,
                        'timestamp' => new Zend_Db_Expr('NOW()'),
                        'state' => 'success',
                        'source' => 'janrain',
                    ));
                }

                $viewer->save();

                // Redirect
                return $this->_helper->redirector->gotoRoute(array(), 'default', true);
            }
        } else {
            if ($viewer->getIdentity()) {
                // Connect
                $janrainTable->insert(array(
                    'user_id' => $viewer->getIdentity(),
                    'identifier' => $identifier,
                    'provider' => $provider,
                    'token' => $token,
                ));

                // Redirect
                return $this->_helper->redirector->gotoRoute(array(), 'default', true);
            } else {
                // Sign-up
                $_SESSION['janrain_signup'] = true;
                $_SESSION['janrain_signup_info'] = $profile;
                $_SESSION['janrain_signup_token'] = $token;
                return $this->_helper->redirector->gotoRoute(array(), 'user_signup', true);
            }
        }
    }

    static protected function _version3PasswordCrypt($method, $salt, $password) {
        // For new methods
        if ($method > 0) {
            if (!empty($salt)) {
                list($salt1, $salt2) = str_split($salt, ceil(strlen($salt) / 2));
                $salty_password = $salt1 . $password . $salt2;
            } else {
                $salty_password = $password;
            }
        }

        // Hash it
        switch ($method) {
            // crypt()
            default:
            case 0:
                $user_password_crypt = crypt($password, '$1$' . str_pad(substr($salt, 0, 8), 8, '0', STR_PAD_LEFT) . '$');
                break;

            // md5()
            case 1:
                $user_password_crypt = md5($salty_password);
                break;

            // sha1()
            case 2:
                $user_password_crypt = sha1($salty_password);
                break;

            // crc32()
            case 3:
                $user_password_crypt = sprintf("%u", crc32($salty_password));
                break;
        }

        return $user_password_crypt;
    }

}
