<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: IndexController.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Bang_IndexController extends Core_Controller_Action_Standard {

    public function init() {
        $this->view->viewer_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $this->view->navigation = $this->getNavigation();
    }

    public function createAction() {

        //FIND LOGGED IN USER INFORMATION
        $viewer = $this->_helper->api()->user()->getViewer();
        $this->view->viewer_id = $viewer_id = $viewer->getIdentity();

        $this->view->form = $form = new Bang_Form_Ad_Request_Create();

        if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) {

            $table = Engine_Api::_()->getItemTable('bang_request');
            $db = $table->getAdapter();
            $db->beginTransaction();

            try {
                if (!empty($viewer_id)) {
                    $values = array_merge($form->getValues(), array(
                        'owner_type' => $viewer->getType(),
                        'owner_id' => $viewer_id,
                    ));
                } else {
                    $values = array_merge($form->getValues(), array(
                        'owner_type' => 'null',
                        'owner_id' => 0,
                    ));
                }
                
                
                
                $request = $table->createRow();
                $request->setFromArray($values);

                $request->save();
                
                if (!empty($values['ad_file'])) {
                    $request->setPhoto($form->ad_file);
                }

                $db->commit();

                if (!empty($request->owner_id)) {
                    $owner_id = $request->owner_id;
                    $owner = Engine_Api::_()->getItem('user', $owner_id);
                    $owner_name = $owner->username;
                } else {
                    $owner_name = 'Anonymous user';
                }
                
                $email = Engine_Api::_()->getApi('settings', 'core')->core_mail['from'];
                
                /*
                Engine_Api::_()->getApi('mail', 'core')->sendSystem($email, 'notify_request_create', array(
                    'ad_title' => $request->ad_title,
                    'ad_name' => $owner_name,
                    'ad_subtitle' => $request->ad_subtitle,
                    'ad_email' => $request->ad_email,
                    'ad_phone' => $request->ad_phone
                ));
                */

                $url = $this->_helper->url->url(array(), 'home');

                $this->_forward('success', 'utility', 'core', array(
                    'smoothboxClose' => true,
                    'parentRedirect' => $url,
                    'parentRedirectTime' => '15',
                    'format' => 'smoothbox',
                    'messages' => Zend_Registry::get('Zend_Translate')->_('You have successfully send Advertisement to our staff.')
                ));
            } catch (Exception $ex) {
                $db->rollBack();
                throw $ex;
            }
        }
    }

    //CREATING TABS
    protected $_navigation;

    public function getNavigation() {
        if ($this->_helper->api()->user()->getViewer()->getIdentity()) {
            $tabs = array();

            //CHECK THAT FEEDBACK FORUM TAB SHOULD BE VISIBLE OR NOT
            $show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;
            if (!empty($show_browse)) {
                $tabs[] = array(
                    'label' => 'Browse Feedbacks',
                    'route' => 'feedback_browse',
                    'action' => 'browse',
                    'controller' => 'index',
                    'module' => 'feedback'
                );
            }

            $tabs[] = array(
                'label' => 'My Feedbacks',
                'route' => 'feedback_manage',
                'action' => 'manage',
                'controller' => 'index',
                'module' => 'feedback'
            );

            $tabs[] = array(
                'label' => 'Create New Feedback',
                'route' => 'feedback_create',
                'action' => 'create',
                'controller' => 'index',
                'module' => 'feedback',
                'class' => 'smoothbox',
                'width' => '',
            );

            if (is_null($this->_navigation)) {
                $this->_navigation = new Zend_Navigation();
                $this->_navigation->addPages($tabs);
            }
            return $this->_navigation;
        }
    }

}

?>
