<?php

/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter
 * @author     huynhnv
 * @status     done
 */
class Recruiter_AdminManageController extends Core_Controller_Action_Admin {

    private function checkuser() {
        $check_users_string = "ducminhmauvang@yahoo.com.vn,thang.lm77@gmail.com,huent2510@gmail.com,golfclub@gmail.com,hr.hn@oneasia.biz,hr@cruisehalong.com,diem.bui@vtijs.com,hr@thegioianvat.com,hoangoanh@cta.com.vn,info@threeland.com,viethotel61hangthan@viethotel.vn,diem.bui@vtijs.com,hr.imexpan@gmail.com,bichngadlvn@yahoo.com,nnpjsc@yahoo.com,giang@dongphuong.vn,nxuanhuy@gmail.com,lehuutung84@gmail.com,newfamilyns@yahoo.com,frontoffice@vanchai-vn.com,info@vietrivertour.com,frontoffice@vanchai-vn.com,nhung.nguyen@vtijs.com,h7049-hr@accor.com,saigon@newworldshotels.com,hr@newpacific.vn,hr@newpacific.vn, minhan29hr@gmail.com,hrm@michelia.vn,info@dulichnetviet.net,Hn.Tuyendung@ggg.com.vn,recruitment@thediningroom.com.vn";
        $check_users = explode(",", $check_users_string);
        $count = 0;
        foreach ($check_users as $key => $user_email) {
            $table = Engine_Api::_()->getDbtable('users', 'user');
            $rName = $table->info('name');
            $select = $table->select()
                    ->from($rName)
                    ->where('email =? ', $user_email);
            $result = $table->fetchAll($select);
            foreach ($result as $user) {
                print_r($user["lastlogin_date"]);
                print_r("<hr>");
                $count++;
            }
        }
        print_r("total record found: " . $count);
    }
    private function deleteUserFromUserArray() {
        $user_array = array(233, 234, 235, 236, 237, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 254, 255, 256, 257, 258, 261, 262, 263, 264, 265, 268, 269, 270, 272, 273, 274, 275, 276, 279, 281, 282, 283, 284, 285, 286, 288, 289, 290, 291, 292, 293, 294, 296, 297, 298, 299, 300, 303, 304, 305, 306, 307, 308, 309, 310, 312, 314, 315, 316, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 332, 333, 334, 335, 336, 338, 339, 340, 341, 343, 345, 346, 347, 348, 349, 350, 351, 352, 353, 355, 356, 357, 358, 359, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 372, 373, 374, 375, 376, 377, 378, 380, 381, 382, 383, 384, 385, 387, 388, 389, 390, 392, 393, 394, 395, 396, 397, 399, 400, 401, 402, 403, 406, 407, 408, 409, 410, 411, 414, 415, 416, 417, 418, 421, 423, 424, 426, 427, 429, 430, 431, 432, 433, 434, 435, 436, 438, 439, 440, 441, 444, 445, 446, 447, 448, 450, 451, 452, 453, 454, 457, 458, 459, 462, 463, 464, 465, 466, 467, 468, 469, 470, 472, 473, 474, 475, 525, 526, 527, 528, 532, 533, 538, 539, 541, 545, 546, 549, 550, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 564, 565, 566, 567, 568, 570, 571, 573, 574, 575, 576, 579, 580, 582, 583, 586, 587, 591, 592, 601, 602, 607, 608, 612, 613, 618, 619, 620, 621, 622, 626, 627, 455, 311, 476, 30, 40, 44, 56, 63, 64, 68, 75, 90, 92, 99, 120, 122, 123, 132, 134, 135, 141, 144, 145, 149, 155, 157, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 172, 173, 174, 176, 177, 178, 179, 180, 181, 183, 186, 187, 188, 189, 190, 191, 192, 193, 194, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 212, 213, 214, 215, 216, 217, 219, 220, 222, 223, 224, 225, 227, 277, 278, 287, 295, 313, 412, 449, 486, 512, 530, 531, 588, 589, 594, 595, 600, 603, 604, 605, 609, 610, 611, 638, 651, 654, 776, 782, 817, 818);
        foreach ($user_array as $key => $user_id) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();
            try {
                $user = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
                if (isset($user)) {
                    $user->delete();
                }
                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }
    private function deleteJobsLessThanIds() {
        $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $rName = $table->info('name');
        $select = $table->select()
                ->from($rName)
                ->where('job_id <=? ', 499);
        $results = $table->fetchAll($select);
        foreach ($results as $job) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();
            try {
                Engine_Api::_()->getApi('job', 'recruiter')->deleteJob($job["job_id"]);
                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    // http://local.hospitality.vn/admin/recruiter/manage/mycustom
    // Modification by bangvn
    public function mycustomAction() {
        //$this->checkuser();
        //$this->deleteUserFromUserArray();
        //$this->deleteJobsLessThanIds();

            // Get table info
        // Get table info
        $table = Engine_Api::_()->getDbtable('users', 'user');
        $userTableName = $table->info('name');


        
        $searchTable = Engine_Api::_()->fields()->getTable('user', 'search');
        $searchTableName = $searchTable->info('name');

        $select = $table->select()
            //->setIntegrityCheck(false)
            ->from($userTableName)
            ->joinLeft($searchTableName, "`{$searchTableName}`.`item_id` = `{$userTableName}`.`user_id`", null)
            //->group("{$userTableName}.user_id")
            ->where("{$userTableName}.search = ?", 1)
            ->where("{$userTableName}.enabled = ?", 1)
            ->where("{$searchTableName}.gender = ?", 3);
            //->order("{$userTableName}.displayname ASC");

        $results = $table->fetchAll($select);
        $bangvn = Engine_Api::_()->getDbtable('users', 'user')->find(987)->current();
        foreach ($results as $user) {
            $this->addPoint($user, $bangvn);
        }

        
        $this->addPoint($bangvn, $bangvn);

        die;
    }

    private function addPoint($user, $admin){

        $api = Engine_Api::_()->getApi('core', 'activitypoints');
        $points = 500;
        $api->addPoints( $user->getIdentity(), $points );

        if(($user->getIdentity() != $admin->getIdentity())) {
            
            $subject = "8 Tháng 3 Free Credits";
            $message = "Bạn vừa nhận được 500 free credits từ Ban quản trị hospitality.vn nhân ngày Mùng 8 Tháng 3.";

            $conversation = Engine_Api::_()->getItemTable('messages_conversation')->send(
              $admin,
              array( $user->getIdentity() ),
              $subject,
              $message
            );

            Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification(
              $user,
              $admin,
              $conversation,
              'message_new'
            );
            
          }

    }

    public function indexAction() {
        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                ->getNavigation('recruiter_admin_main', array(), 'recruiter_admin_main_manage');
        $keyword = $this->_getParam('keyword');
        $status = $this->_getParam('status');
        $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $db = $table->getAdapter();
        $rName = $table->info('name');
        $industry_table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter')->info('name');
        $modules_table = Engine_Api::_()->getDbtable('modules', 'user')->info('name');
        $user_table = Engine_Api::_()->getDbtable('users', 'user')->info('name');
        //$status_keyword = ( $status == 'noassign' ? '0' : '1' );
        if ($status == 'noassign') {
            $status_keyword = 0;
            if (!empty($keyword)) {
                if (strlen($keyword) < 4) {
                    $select = $table->select()
                            ->from($rName)
                            ->where($rName . ".resolved_name LIKE ? OR " . $rName . ".position LIKE ? OR " . $rName . ".description LIKE ? OR " . $rName . ".salary LIKE ? OR " . $rName . ".contact_name LIKE ? OR " . $rName . ".contact_address LIKE ? OR " . $rName . ".skill LIKE ?", '%' . $keyword . '%')
                            ->order('creation_date DESC');
                } else {
                    //Zend_Debug::dump($keyword);exit;
                    $select = $table->select()
                            ->from($rName)
                            ->where(new Zend_Db_Expr($db->quoteInto('MATCH(' . $rName . '.`resolved_name`, ' . $rName . '.`position`, ' . $rName . '.`salary`, ' . $rName . '.`description`, ' . $rName . '.`skill`, ' . $rName . '.`contact_name`, ' . $rName . '.`contact_address`) AGAINST (? IN BOOLEAN MODE)', $keyword)))
                            ->order('creation_date DESC');
                }
            } else {
                $select = $table->select()
                        ->from($rName)
                        ->order('creation_date DESC');
            }
        } else if ($status == 'resolved') {
            $status_keyword = 2;

            if (!empty($keyword)) {

                $select = $table->select()
                        ->setIntegrityCheck(false)
                        ->from($rName)
                        ->joinLeft($user_table, $user_table . ".user_id = " . $rName . ".resolved_by")
                        //->where(new Zend_Db_Expr($db->quoteInto('MATCH('.$rName.'.`resolved_name`) AGAINST (? IN BOOLEAN MODE)', $keyword)))
                        ->where($user_table . ".displayname LIKE ? OR " . $user_table . ".username LIKE ?", '%' . $keyword . '%')
                ;
            } else {
                $select = $table->select()
                        ->from($rName)
                        ->order('creation_date DESC');
            }
        } else {
            $status_keyword = 1;
            if (!empty($keyword)) {
                /*
                  if(strlen($keyword)<4){
                  $select = $table->select()
                  ->from($rName)
                  ->where($rName.".resolved_name LIKE ?", '%'.$keyword.'%')
                  ->order('creation_date DESC');
                  }
                  else{
                 */
                //Zend_Debug::dump($keyword);exit;
                $select = $table->select()
                        ->setIntegrityCheck(false)
                        ->from($rName)
                        ->joinLeft($industry_table, $industry_table . ".job_id = " . $rName . ".job_id")
                        ->joinLeft($modules_table, $modules_table . ".industry_id = " . $industry_table . ".industry_id")
                        ->joinLeft($user_table, $user_table . ".user_id = " . $modules_table . ".user_id")
                        //->where(new Zend_Db_Expr($db->quoteInto('MATCH('.$rName.'.`resolved_name`) AGAINST (? IN BOOLEAN MODE)', $keyword)))
                        ->where($user_table . ".displayname LIKE ? OR " . $user_table . ".username LIKE ?", '%' . $keyword . '%')

                //->order($table.'.creation_date DESC')
                ;
                //}
            } else {
                $select = $table->select()
                        ->from($rName)
                        ->order('creation_date DESC');
            }
        }


        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator = $this->view->paginator = Zend_Paginator::factory($select);
        //Zend_Debug::dump($paginator);exit;
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($page);
        $this->view->status = $status_keyword;
    }

    public function deleteAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $this->view->job_id = $id;
        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                Engine_Api::_()->getApi('job', 'recruiter')->deleteJob($id);
                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }

            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => 10,
                'parentRefresh' => 10,
                'messages' => array('')
            ));
        }
        // Output
        $this->renderScript('admin-manage/delete.tpl');
    }

    public function deleteselectedAction() {
        $this->view->ids = $ids = $this->_getParam('ids', null);
        $confirm = $this->_getParam('confirm', false);
        $this->view->count = count(explode(",", $ids));

        // Save values
        if ($this->getRequest()->isPost() && $confirm == true) {
            $ids_array = explode(",", $ids);
            foreach ($ids_array as $id) {

                Engine_Api::_()->getApi('job', 'recruiter')->deleteJob($id);
            }

            $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }
    }

    public function approveAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $this->view->job_id = $id;
        $viewer = Engine_Api::_()->user()->getViewer();
        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                $job = Engine_Api::_()->getItem('job', $id);
                $job->status = 2;
                //find user resolved
                $resolved_id = $viewer->getIdentity();
                //$resolved_by= Engine_Api::_()->getDbtable('users', 'user')->find($resolved_id)->current();
                //$resolved_name= $resolved_by->displayname;
                $job->resolved_by = $resolved_id;
                //$job->resolved_name= $resolved_name;
                $job->save();

                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }

            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => 10,
                'parentRefresh' => 10,
                'messages' => array('Approve Success')
            ));
        }
        // Output
        $this->renderScript('admin-manage/approve.tpl');
    }

    /*
      Manage Industry
     */

    public function industriesAction() {

        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                ->getNavigation('recruiter_admin_main', array(), 'recruiter_admin_main_industries');
        $this->view->industries = Engine_Api::_()->getApi('core', 'recruiter')->getAdminIndustries();
    }

    //add new industry
    public function addIndustryAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');

        // Generate and assign form
        $form = $this->view->form = new Recruiter_Form_Admin_Industry();
        $form->setAction($this->getFrontController()->getRouter()->assemble(array()));
        // Check post
        if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) {
            // we will add the category
            $values = $form->getValues();

            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                // add category to the database
                // Transaction
                $table = Engine_Api::_()->getDbtable('industries', 'recruiter');
                $viewer = Engine_Api::_()->user()->getViewer();
                $user_id = $viewer->getIdentity();
                // insert the category into the database
                $row = $table->createRow();

                $row->name = $values["name"];
                $row->save();

                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => 10,
                'parentRefresh' => 10,
                'messages' => array('')
            ));
        }

        // Output
        $this->renderScript('admin-manage/form.tpl');
    }

    //edit industry
    public function editIndustryAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $form = $this->view->form = new Recruiter_Form_Admin_Industry();
        $form->setAction($this->getFrontController()->getRouter()->assemble(array()));

        // Check post
        if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) {
            // Ok, we're good to add field
            $values = $form->getValues();

            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                // edit category in the database
                // Transaction
                $row = Engine_Api::_()->getApi('core', 'recruiter')->getAdminIndustry($values["id"]);
                $viewer = Engine_Api::_()->user()->getViewer();
                $user_id = $viewer->getIdentity();
                $row->name = $values["name"];

                $row->save();
                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => 10,
                'parentRefresh' => 10,
                'messages' => array('')
            ));
        }

        // Must have an id
        if (!($id = $this->_getParam('id'))) {
            die('No identifier specified');
        }

        // Generate and assign form
        $category = Engine_Api::_()->getApi('core', 'recruiter')->getAdminIndustry($id);
        $form->setField($category);

        // Output
        $this->renderScript('admin-manage/form.tpl');
    }

    //delete industry
    public function deleteIndustryAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $this->view->industry_id = $id;

        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                // go through logs and see which events used this category id and set it to ZERO
                $newTable = $this->_helper->api()->getDbtable('industries', 'recruiter');
                $select = $newTable->select()->where('industry_id = ?', $id);

                $row = Engine_Api::_()->getApi('core', 'recruiter')->getAdminIndustry($id);
                //find industry in table reindustries
                $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
                $sl = $table->select()
                        ->where('industry_id =?', $id);
                $records = $table->fetchAll($sl);
                //delete industry
                if (count($records) > 0) {
                    foreach ($records as $rd) {
                        $rd->delete();
                    }
                }
                //update lại dữ liệu trong bảng kinh nghiệm của ứng viên(category_id)
                $table_exper = Engine_Api::_()->getDbtable('experiences', 'resumes');
                $select_exper = $table_exper->select()
                        ->where('category_id =?', $id);
                $record_exper = $table_exper->fetchAll($select_exper);
                if (count($record_exper)) {
                    foreach ($record_exper as $exper) {
                        $exper->category_id = 0;
                        $exper->save();
                    }
                }
                //delete data in table module core(if)
                $table_module = Engine_Api::_()->getDbtable('modules', 'user');
                $select_md = $table_module->select()
                        ->where('industry_id =?', $id);
                $record_md = $table_module->fetchAll($select_md);
                if (count($record_md)) {
                    foreach ($record_md as $md) {
                        $md->delete();
                    }
                }
                $row->delete();
                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => 10,
                'parentRefresh' => 10,
                'messages' => array('')
            ));
        }

        // Output
        $this->renderScript('admin-manage/delete-industry.tpl');
    }

    //Manage articals
    public function articalAction() {

        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                ->getNavigation('recruiter_admin_main', array(), 'recruiter_admin_main_articals');

        $articalsTable = Engine_Api::_()->getDbtable('articals', 'recruiter');
        $keyword = $this->_getParam('keyword');

        $db = $articalsTable->getAdapter();
        $rName = $articalsTable->info('name');
        if (!empty($keyword)) {
            if (strlen($keyword) < 4) {
                $select = $articalsTable->select()
                        ->from($rName)
                        ->where($rName . ".title LIKE ? OR " . $rName . ".content LIKE ? ", '%' . $keyword . '%')
                        ->order('created DESC');
            } else {
                //Zend_Debug::dump($keyword);exit;
                $select = $articalsTable->select()
                        ->from($rName)
                        ->where(new Zend_Db_Expr($db->quoteInto('MATCH(' . $rName . '.`title`, ' . $rName . '.`content`) AGAINST (? IN BOOLEAN MODE)', $keyword)))
                        ->order('created DESC');
            }
        } else {
            $select = $articalsTable->select()
                    ->from($rName)
                    ->order('created DESC');
        }
        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator = $this->view->paginator = Zend_Paginator::factory($select);
        //Zend_Debug::dump($paginator);exit;
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($page);
    }

    public function deleteArticalAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $this->view->artical_id = $id;

        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                $artical = Engine_Api::_()->getItem('artical', $id);

                if ($artical->photo_id) {
                    Engine_Api::_()->getApi('job', 'recruiter')->deleteFileArtical($artical->photo_id);
                }
                $artical->delete();
                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }

            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => 10,
                'parentRefresh' => 10,
                'messages' => array('')
            ));
        }
        // Output
        $this->renderScript('admin-manage/delete-artical.tpl');
    }

    public function deletearticalselectedAction() {
        $this->view->ids = $ids = $this->_getParam('ids', null);
        $confirm = $this->_getParam('confirm', false);
        $this->view->count = count(explode(",", $ids));

        // Save values
        if ($this->getRequest()->isPost() && $confirm == true) {
            $ids_array = explode(",", $ids);
            foreach ($ids_array as $id) {

                $artical = Engine_Api::_()->getItem('artical', $id);
                $artical->delete();
                if ($artical->photo_id) {
                    Engine_Api::_()->getApi('job', 'recruiter')->deleteFileArtical($artical->photo_id);
                }
            }

            $this->_helper->redirector->gotoRoute(array('action' => 'artical'));
        }
    }

}