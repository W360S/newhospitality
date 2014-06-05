<?php

class Resumes_ResumeController extends Core_Controller_Action_Standard {

    public function manageAction() {
        //list resume
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $this->view->viewer_id = $user_id;
        $resumes = Engine_Api::_()->getApi('core', 'resumes')->getListResume($user_id);

        $this->view->resumes = $resumes;
        //list job save
        $rows = Engine_Api::_()->getApi('job', 'recruiter')->ListJobSave($user_id);
        if (count($rows) > 0) {
            $job_ids = array();
            foreach ($rows as $row) {
                $job_ids[$row['job_id']] = $row['job_id'];
            }

            $table = Engine_Api::_()->getItemTable('job');
            $select = $table->select()->where('job_id IN(?)', $job_ids);
            $this->view->page = $page = $this->_getParam('page', 1);
            $paginator = $this->view->paginator = Zend_Paginator::factory($select);
            //Zend_Debug::dump($paginator);exit;
            $paginator->setItemCountPerPage(10);
            $paginator->setCurrentPageNumber($page);
            $this->view->viewer_id = $user_id;
        }
        //jobs matching resumes
        //chỉ matching những resumes mà được approved nên không thể sử dụng hàm getListResume($user_id).
        $table_rs = Engine_Api::_()->getDbtable('resumes', 'resumes');
        $match_resumes = $table_rs->fetchAll($table_rs->select()->where('user_id=?', $user_id)->where('approved =?', 1));
        $resume_title = array();
        $title = "";
        if (count($match_resumes) > 0) {
            foreach ($match_resumes as $resume) {
                $resume_title[$resume->resume_id] = $resume->title;
                $title = $title . " " . $resume->title;
            }

            $table = Engine_Api::_()->getItemTable('job');
            $db = $table->getAdapter();
            $sName = $table->info('name');
            $select = $table->select()
                    ->where('status =?', 2)
                    ->where('reject =?', 0)
                    ->where('deadline >?', date('Y-m-d H:i:s'))
                    //->where("position LIKE ? OR "."description LIKE ? OR "."skill LIKE ?", '%'.$title.'%')
                    //->orWhere('position IN(?)', $resume_title)
                    //->orWhere('description IN(?)', $resume_title)
                    //->orWhere('skill IN(?)', $resume_title)
                    ->where(new Zend_Db_Expr($db->quoteInto('MATCH(' . $sName . '.`position`, ' . $sName . '.`description`, ' . $sName . '.`skill`) AGAINST (? IN BOOLEAN MODE)', $title)))

            ;

            $this->view->page = $page = $this->_getParam('page', 1);
            $paginator_jobs = $this->view->paginator_jobs = Zend_Paginator::factory($select);
            //Zend_Debug::dump($paginator);exit;
            $paginator_jobs->setItemCountPerPage(10);
            $paginator_jobs->setCurrentPageNumber($page);
        }
        
        $this->_helper->content
                ->setContentName(43) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    public function listAction() {
        $this->_helper->layout->disableLayout();
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $resumes = Engine_Api::_()->getApi('core', 'resumes')->getListResume($user_id);
        $this->view->resumes = $resumes;
    }

    public function deleteAction() {

        //get resume_id
        $resume_id = $this->getRequest()->getPost('resume_id');
        try {
            //delete skill other if exist
            Engine_Api::_()->getApi('core', 'resumes')->deleteSkillOther($resume_id);
            //delelte skill language
            Engine_Api::_()->getApi('core', 'resumes')->deleteSkillLanguage($resume_id);
            //delete reference
            Engine_Api::_()->getApi('core', 'resumes')->deleteReference($resume_id);
            //delete Education
            Engine_Api::_()->getApi('core', 'resumes')->deleteEducation($resume_id);
            //delete Experience
            Engine_Api::_()->getApi('core', 'resumes')->deleteExperience($resume_id);
            //delete search
            Engine_Api::_()->getApi('core', 'resumes')->deleteSearch($resume_id);
            //increase num_apply of job
            Engine_Api::_()->getApi('core', 'resumes')->decreaseNumApplyJob($resume_id);
            //delete job if applied
            Engine_Api::_()->getApi('core', 'resumes')->deleteJobApplied($resume_id);

            //delete resume
            Engine_Api::_()->getApi('core', 'resumes')->deleteResume($resume_id);
            $this->dateAction(1);
        } catch (Exception $e) {
            throw $e;
        }
    }

    public function dateAction($error) {

        echo $error;
        exit;
    }

    public function viewAction() {

        if (!$this->_helper->requireUser()->isValid())
            return;
        $viewer = Engine_Api::_()->user()->getViewer();

        $this->view->user_id = $viewer->user_id;

        $resume_id = $this->_getParam('resume_id');

        //list resume
        $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);

        $this->view->resume = $resume;
        $this->view->user_resume = $resume->user_id;

        //list work experience
        $works = Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
        //total years
        $total_year = 0;
        foreach ($works as $work) {
            $total_year+= $work->num_year;
        }
        $this->view->total_year = $total_year;
        $this->view->works = $works;
        //list education
        $education = Engine_Api::_()->getApi('core', 'resumes')->getListEducation($resume_id);
        $this->view->educations = $education;
        //list language
        $languages = Engine_Api::_()->getApi('core', 'resumes')->getListLanguageSkill($resume_id);
        $this->view->languages = $languages;
        //list other skill
        $group_skills = Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
        $this->view->group_skill = $group_skills;
        //list reference
        $references = Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
        $this->view->references = $references;
        //save view count resume
        if ($resume->user_id != $viewer->user_id) {
            $resume->view_count+=1;
            $resume->save();
        }
        
        $user_inform = Engine_Api::_()->getDbtable('users', 'user')->find($resume->user_id)->current();
        $this->view->user_inform = $user_inform;
        
        $field_id_from = Engine_Api::_()->getApi('core', 'recruiter')->getMetaFromAlias('from');
        $from = Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_from, $resume->user_id);
        $from = Engine_Api::_()->getApi('core', 'recruiter')->getOption($field_id_from, $from);
        
        $field_id_phone = Engine_Api::_()->getApi('core', 'recruiter')->getMetaFromAlias('phone');
        if ($field_id_phone) {
            $phone = Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_phone, $resume->user_id);
        }else{
            $phone = "";
        }
        
        
        $this->view->from = $from;
        $this->view->phone = $phone;
        
        //birthday
        $field_id_birthday = Engine_Api::_()->getApi('core', 'recruiter')->getMeta('birthdate');
        $birthday = Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_birthday, $resume->user_id);
        $this->view->birthday = $birthday;
        
        $this->_helper->content
                ->setContentName(47) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    public function newsResumeAction() {
        $this->_helper->layout->disableLayout();
        if ($this->_request->isXmlHttpRequest()) {
            $table = Engine_Api::_()->getDbtable('resumes', 'resumes');
            $select = $table->select()
                    ->where('enable_search > ?', 0)
                    ->where('approved =?', 1)
                    ->order('resume_id DESC')
            //->limit(6);
            ;

            $this->view->paginator = $paginator = Zend_Paginator::factory($select);
            $request = Zend_Controller_Front::getInstance()->getRequest();
            $paginator->setItemCountPerPage(10);
            $paginator->setCurrentPageNumber($request->getParam('page'));
        }
    }

    public function pdfAction() {
        //$this->_helper->layout->disableLayout();
        //$this->_helper->viewRenderer->setNoRender();
        require_once APPLICATION_PATH . '/application/libraries/Zend/dompdf/dompdf_config.inc.php';
        require_once APPLICATION_PATH . '/application/libraries/Zend/Loader.php';
        //Zend_Loader::registerAutoload();
        spl_autoload_register('DOMPDF_autoload');
        //tcpdf
        require_once APPLICATION_PATH . '/application/libraries/Zend/tcpdf/config/lang/eng.php';
        require_once APPLICATION_PATH . '/application/libraries/Zend/tcpdf/tcpdf.php';

        $viewer = Engine_Api::_()->user()->getViewer();

        $this->view->user_id = $viewer->user_id;

        $resume_id = $this->_getParam('resume_id');
        //list resume
        $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);

        $this->view->resume = $resume;
        $this->view->user_resume = $resume->user_id;
        //check if user has profile image
        if (!empty($resume->path_image)) {
            $this->view->path_image = $resume->path_image;
        }
        $user_inform = Engine_Api::_()->getDbtable('users', 'user')->find($resume->user_id)->current();
        $this->view->user_inform = $user_inform;

        //gender
        $field_id_gender = Engine_Api::_()->getApi('core', 'recruiter')->getMeta('gender');
        $option = Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_gender, $resume->user_id);
        if ($option != null) {
            $gender = Engine_Api::_()->getApi('core', 'recruiter')->getOption($field_id_gender, $option);
        }
        //birthday
        $field_id_birthday = Engine_Api::_()->getApi('core', 'recruiter')->getMeta('birthdate');
        $birthday = Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_birthday, $resume->user_id);
        //list work experience
        $works = Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
        //total years
        $total_year = 0;
        foreach ($works as $work) {
            $total_year+= $work->num_year;
        }
        $this->view->total_year = $total_year;
        $this->view->works = $works;
        //list education
        $education = Engine_Api::_()->getApi('core', 'resumes')->getListEducation($resume_id);
        $this->view->educations = $education;
        //list language
        $languages = Engine_Api::_()->getApi('core', 'resumes')->getListLanguageSkill($resume_id);
        $this->view->languages = $languages;
        //list other skill
        $group_skills = Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
        $this->view->group_skill = $group_skills;
        //list reference
        $references = Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
        $this->view->references = $references;
        $this->render();


        //Zend_Debug::dump($src);exit;
        if (!empty($resume->path_image)) {
            $dir = APPLICATION_PATH . DIRECTORY_SEPARATOR . 'public/profile_recruiter';
            $src = $dir . "/" . $resume->path_image;
            //Zend_Debug::dump($src);exit;
        } else {
            $output = $this->getResponse()->getBody();
            //Zend_Debug::dump($output);exit;
            //$output='<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head><body>'.$output.'</body></html>';

            $output = str_replace('"', "'", $output);
            $output = str_replace("src='", "src='" . APPLICATION_PATH, $output);
            $output = str_replace("Send a message", " ", $output);
            $output = str_replace("Go to network profile", " ", $output);
            $output = str_replace("Save this candidate", " ", $output);

            $h_image = $output;
            $src_pos = strpos($h_image, 'src');
            $alt_pos = strpos($h_image, 'alt');
            //$this->topdf($html);
            $alt_pos = $alt_pos - 3;
            $src_temp = substr($h_image, 1, $alt_pos);
            //$src= substr($src_temp, 10);
            //$html = file_get_contents('http://localhost/social4051/public/recruiter/pdf.html');
            //Zend_Debug::dump($src_temp);
            //Zend_Debug::dump($src);exit;
            $src = str_replace("<img src='", " ", $output);
            $src = trim(str_replace("' alt='' class='thumb_profile item_photo_user  thumb_profile' />", " ", $src));
            //$src= "/home/".$src;
        }
        //Zend_Debug::dump($src);exit;
        if (!empty($resume->username)) {
            $username = $resume->username;
        } else {
            $username = $user_inform->displayname;
        }
        if (!empty($resume->email)) {
            $email = $resume->email;
        } else {
            $email = $user_inform->email;
        }
        $pdf = new HGQPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
        // set document information
        $pdf->SetCreator(PDF_CREATOR);
        $pdf->SetAuthor('huynhnv');
        $pdf->SetTitle('Profile');
        $pdf->SetSubject('Resumes');
        $pdf->SetKeywords('profile, cv, resumes');

        // set default header data
        $pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE, PDF_HEADER_STRING);

        // set header and footer fonts
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        //set margins
        $pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        //set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        //set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        //set some language-dependent strings
        $pdf->setLanguageArray($l);

        // ---------------------------------------------------------
        // set font
        $pdf->SetFont('freeserif', '', 12);
        // add a page
        $pdf->AddPage();
        //Zend_Debug::dump($src);exit;
        $pdf->Image($src, '', 40, 40, 60, '', '', '', false, 300);

        $pdf->writeHTMLCell(100, 5, 70, 40, "<strong>" . $username . "</strong>", 0, 0, 0, 0, 'L', true);

        $pdf->writeHTMLCell(100, 5, 70, 50, "<strong>Gender: </strong>" . $gender, 0, 0, 0, 0, 'L', true);
        $pdf->writeHTMLCell(100, 5, 70, 60, "<strong>Birthday: </strong>" . $birthday, 0, 0, 0, 0, 'L', true);
        $pdf->writeHTMLCell(100, 5, 70, 70, "<strong>Email: </strong>" . $email, 0, 0, 0, 0, 'L', true);

        $src_word = $_SERVER['SERVER_NAME'] . "/application/modules/Resumes/externals/images/icon_word.jpg";
        $html = <<<EOF
    <br />
    <br />
    <br />
    <div id="container">
	
	<div id="content">
		<div class="table">
			<table cellspacing="0" cellpadding="1">
                
                <br />
                <br />
                <br />
                <br />
                
				<tr>
					<td style="background-color: #EAEDF4; height:43px;">
						<b> Kinh nghiệm làm việc </b><br />
						<em>Total: $total_year năm</em>
					</td>
                </tr>
                <tr>
                    <br />
                   
					<td>
                     <table>
                        
                        
EOF;
        $level = new Resumes_View_Helper_Level();

        $cat = new Resumes_View_Helper_Category();
        $city = new Resumes_View_Helper_City();
        $country = new Resumes_View_Helper_Country();
        foreach ($works as $work) {
            $level_name = $level->level($work->level_id)->name;
            $cat_name = $cat->category($work->category_id)->name;
            $city_name = $city->city($work->city_id)->name;
            $country_name = $country->country($work->country_id)->name;
            $startime = date('n-Y', strtotime($work->starttime));
            $endtime = date('n-Y', strtotime($work->endtime));
            $description = str_replace("<br />", "<br /><img>", $work->description);
            //Zend_Debug::dump($description);exit;
            //$description= str_replace("<img>", '<img src="hospitality.vn/application/modules/Resumes/externals/images/icon_word.jpg" /> &nbsp;', $description);
            $description = str_replace("<img>", ' &nbsp;', $description);
            $description = str_replace('<p>', " ", $description);
            $description = str_replace('</p>', " ", $description);

            $html .= <<<EOF
                            
                            <tr>
                                <td colspan="2"> <strong> $startime / $endtime </strong></td>
                            </tr>
                            <tr>
                                <td><strong> $work->title </strong></td>
                                <td style="text-align: right;"><strong> $level_name - $cat_name </strong></td>
                            </tr>
                            <tr>
                                <td> $work->company_name</td>
                                <td style="text-align: right;">($city_name - $country_name )</td>
                                
                            </tr>
                            <tr>
                                
                                <td colspan="2">
                                
                                <!--<img src="hospitality.vn/application/modules/Resumes/externals/images/icon_word.jpg" />-->
								$description </td>
                                
                            
                            </tr>
EOF;
        }
        $html .= <<<EOF
                    </table>
					</td>
				</tr>
                
                <br />
			    <tr>
					<td style="background-color: #EAEDF4; height:43px;" >
						<b style="line-height:10px;"> Trình độ học vấn </b>
						
					</td>
                </tr>
                <tr>
                    <br />
					<td>
                    <table>
                        
EOF;
        $degree = new Resumes_View_Helper_Degree();
        //$country= new Resumes_View_Helper_Country();
        foreach ($education as $edu) {
            $degree_name = $degree->degree($edu->degree_level_id)->name;
            $country_name = $country->country($edu->country_id)->name;
            $startime = date('n-Y', strtotime($edu->starttime));
            $endtime = date('n-Y', strtotime($edu->endtime));
            $description = str_replace("<br />", "<br /><img>", $edu->description);
            //Zend_Debug::dump($description);exit;
            //$description= str_replace("<img>", '<img src="hospitality.vn/application/modules/Resumes/externals/images/icon_word.jpg" /> &nbsp;', $description);
            $description = str_replace("<img>", ' &nbsp;', $description);
            $description = str_replace('<p>', " ", $description);
            $description = str_replace('</p>', " ", $description);

            $html .= <<<EOF
                                <tr>
                                    
                                    
                                    <td> <strong>$startime/$endtime</strong> </td>
                                    <td>
                                        <strong>$degree_name </strong> <em>($edu->major)</em>
                                        <br />
                                        &nbsp; $edu->school_name ($country_name)
                                    </td>
                                </tr>
                                
								<tr>
                                    
                                    <td colspan="2"> 
                                        <!--<img src="hospitality.vn/application/modules/Resumes/externals/images/icon_word.jpg" />-->
                                         $description
                                    </td>
                            
                                </tr>
EOF;
        }

        $html .= <<<EOF
                    </table>
					</td>
				</tr>
                <br />
EOF;
        if (count($languages) > 0) {
            $html .= <<<EOF
                
                <tr >
					<td style="background-color: #EAEDF4; height:43px;">
						<b style="line-height:10px;"> Kỹ năng(Ngoại ngữ)</b>
						
					</td>
                </tr>
                <tr>
                    <br />
					<td>
                    <table>
                        
EOF;
            $lang = new Resumes_View_Helper_Language();
            $gr_skills = new Resumes_View_Helper_GroupSkill();
            foreach ($languages as $language) {
                $language_name = $lang->language($language->language_id)->name;
                $gr_skill = $gr_skills->groupSkill($language->group_skill_id)->name;
                $html .= <<<EOF
                            <tr>
                                <td colspan="2"> $language_name ($gr_skill)</td>
                                
                            </tr>
                            
EOF;
            }
            $html .= <<<EOF
                    </table>
					</td>
                    
				</tr>
                <br />
EOF;
        }
        //Zend_Debug::dump($group_skills);exit;
        if (count($group_skills) > 0) {
            $html .= <<<EOF
                
                <tr>
					<td style="background-color: #EAEDF4;height:43px;">
						<b style="line-height:10px;"> Kỹ năng khác </b>
						
					</td>
                </tr>
                <tr>
                <br />
					<td>
				    <table>
                        
EOF;

            foreach ($group_skills as $group_skill) {

                $description = str_replace("<br />", "<br /><img>", $group_skill->description);
                //Zend_Debug::dump($description);exit;
                //$description= str_replace("<img>", '<img src="hospitality.vn/application/modules/Resumes/externals/images/icon_word.jpg" /> &nbsp;', $description);
                $description = str_replace("<img>", ' &nbsp;', $description);
                $description = str_replace('<p>', " ", $description);
                $description = str_replace('</p>', " ", $description);
                $html .= <<<EOF
                            <tr>
                                <td colspan="2"> <strong>$group_skill->name </strong></td>
                                
                            </tr>
                            <tr>
                            <td colspan="2"> 
                                <!--<img src="hospitality.vn/application/modules/Resumes/externals/images/icon_word.jpg" />-->
                                $description
                                
                            </td>
                            </tr>
							
EOF;
            }
            $html .= <<<EOF
                    </table>
					</td>
				</tr>
                <br />
EOF;
        }
        if (count($references) > 0) {
            $html .= <<<EOF
                <tr>
					<td style="background-color: #EAEDF4; height:43px;">
						<b style="line-height:10px;"> Thông tin tham khảo </b>
						
					</td>
                </tr>
                <tr>
                <br />
					<td>
                    <table>
                        
EOF;

            foreach ($references as $reference) {

                $description = str_replace("<br />", "<br /><img>", $reference->description);
                //Zend_Debug::dump($description);exit;
                //$description= str_replace("<img>", '<img src="hospitality.vn/application/modules/Resumes/externals/images/icon_word.jpg" /> &nbsp;', $description);
                $description = str_replace("<img>", ' &nbsp;', $description);
                $description = str_replace('<p>', " ", $description);
                $description = str_replace('</p>', " ", $description);
                $html .= <<<EOF
                                <tr>
                                    <td colspan="2"><strong> $reference->name </strong></td>
                                    
                                </tr>
                                <tr>
                                    <td colspan="2"> <em>$reference->title </em></td>
                                </tr>
                                <tr>
                                    <td colspan="2"> Điện thoại: $reference->phone - Email: $reference->email</td>
                                    
                                </tr>
                                <tr>
                                    
                                    <td colspan="2"> 
                                        <!--<img src="hospitality.vn/application/modules/Resumes/externals/images/icon_word.jpg" />-->
                                        $description
                                         
                                    </td>
                                </tr>
EOF;
            }
            $html .= <<<EOF
                    </table> 
					</td>
				</tr>
EOF;
        }
        $html .= <<<EOF
           
			</table>			
		</div>
	</div>
</div>
EOF;
        //$htmls= file_get_contents('/application/modules/Resumes/views/scripts/resume/pdf.tpl');
        //background image
        //$img_file_bk = K_PATH_IMAGES.'background.jpg';
        //$pdf->Image($img_file_bk, 0, 0, 210, 297, '', '', '', false, 300, '', false, false, 0);
        $pdf->writeHTML($html, true, false, true, false, '');

        //Zend_Debug::dump($html);exit;
        // reset pointer to the last page
        $pdf->lastPage();

        // ---------------------------------------------------------
        //Close and output PDF document
        $pdf->Output("cv_" . $user_inform->username . "_" . date('Y') . "_" . date('m') . "_" . date('d') . ".pdf", 'I');
        exit;

        /*
          $this->_helper->viewRenderer->setNoRender();
          // create PDF
          $pdf = new Zend_Pdf();

          // create A4 page
          $page = new Zend_Pdf_Page(Zend_Pdf_Page::SIZE_A4);

          // define font resource
          $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_HELVETICA);

          // set font for page
          // write text to page
          $page->setFont($font, 24)
          ->drawText('That which we call a rose,', 72, 720)
          ->drawText('By any other name would smell as sweet.', 72, 620);

          // add page to document
          $pdf->pages[] = $page;
          $filename = "abc.pdf";
          // save as file
          //$pdf->save('example.pdf');

          header('Content-type: application/pdf');
          header('Content-disposition: attachment; filename=' . $filename);
          $pdfData = $pdf->render();
          echo $pdfData;exit;
         */
    }

    public function topdf($html) {
        //http://www.mediawiki.org/wiki/Extension:Pdf_Export_Dompdf
        //
    //$dompdf = new DOMPDF();
        //$html=  iconv('UTF-8','Windows-1250',$html);
        //$html= mb_convert_encoding($html, "UTF-8", "auto");
        //$dompdf->set_paper("a4","landscape");
        //Zend_Debug::dump($html);exit;
        //$dompdf->load_html($html);
        //$dompdf->set_base_path($_SERVER['DOCUMENT_ROOT']);
        //$dompdf->render();
        //$pdfdata = $dompdf->output();
        //Zend_Debug::dump($pdfdata);exit;
        //$dompdf->stream("cv.pdf");
        //tcpdf
        $pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
        // set document information
        $pdf->SetCreator(PDF_CREATOR);
        $pdf->SetAuthor('Nicola Asuni');
        $pdf->SetTitle('TCPDF Example 061');
        $pdf->SetSubject('TCPDF Tutorial');
        $pdf->SetKeywords('TCPDF, PDF, example, test, guide');

        // set default header data
        $pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE . ' 061', PDF_HEADER_STRING);

        // set header and footer fonts
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        //set margins
        $pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        //set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        //set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        //set some language-dependent strings
        $pdf->setLanguageArray($l);

        // ---------------------------------------------------------
        // set font
        $pdf->SetFont('helvetica', '', 10);

        // add a page
        $pdf->AddPage();
        $html = <<<EOF
    <div id="container">
	
	<div id="content">
		<div class="private-infor" >
            <strong>Nguyen Van Huynh</strong><br />
            <hr />
			<b> Gender:</b>Male<br />
			<b> Address:</b> 24 Lê Đình Dương, Hải Châu, Đà Nẵng<br />
			<b> Mobile:</b> 0935928298<br />
			<b> Email: </b>huynhnv@toancauxanh.vn
			
		</div>
		<div class="table">
			<table border="1" cellspacing="0" cellpadding="1">
				<tr>
					<td>
						<b> Work Experience </b><br />
						<em>Total: $total_year. year(s)</em>
					</td>
                </tr>
                <tr>
					<td>
EOF;
        foreach ($works as $work) {
            $level = $this->view->getHelper('level');
            $cat = $this->view->getHelper('category');
            $city = $this->view->getHelper('city');
            $country = $this->view->getHelper('country');
            $html .= <<<EOF
                            <p> $work->title </p>
							<p> $level->level($work->level_id)->name; - $cat->category($work->category_id)->name </p>
							<p> $work->company_name </p>
							<p> $city->city($work->city_id)->name;  -  $country->country($work->country_id)->name</p>
							<p><em>Related Information:</em> $work->description </p>
EOF;
        }
        $html .= <<<EOF
					</td>
				</tr>
			    
		
			</table>			
		</div>
	</div>
</div>
EOF;

        $pdf->writeHTML($html, true, false, true, false, '');
        //Zend_Debug::dump($html);exit;
        // reset pointer to the last page
        $pdf->lastPage();

        // ---------------------------------------------------------
        //Close and output PDF document
        $pdf->Output("cv.pdf", 'I');
    }

    public function rsStatusAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $user = Engine_Api::_()->user()->getViewer();
        $status = $this->_getParam('st');
        $this->view->status = $status;
        //dem so cong viec duoc giai quyet
        $table_module = Engine_Api::_()->getDbtable('modules', 'user');
        $select_module = $table_module->select()->where('user_id = ?', $user->getIdentity())
                ->where('name_module =?', 'resume')
        ;
        $module_resumes = $table_module->fetchRow($select_module);
        if (count($module_resumes)) {

            $table = Engine_Api::_()->getItemTable('resume');
            if ($status == 'pending') {
                $select_pending = $table->select()->where('approved =?', 2)->where('reject =?', 0)->order('modified_date DESC');
                $this->view->page = $page = $this->_getParam('page', 1);
                //jobs pending
                $resumes = $this->view->resumes = Zend_Paginator::factory($select_pending);

                $resumes->setItemCountPerPage(20);
                $resumes->setCurrentPageNumber($page);
            } else if ($status == 'approve') {
                //jobs approved
                $select_approved = $table->select()->where('resolved_by =?', $user->getIdentity())->where('approved =?', 1)->where('reject =?', 0)->order('modified_date DESC');
                $this->view->page = $page = $this->_getParam('page', 1);
                $resumes = $this->view->resumes = Zend_Paginator::factory($select_approved);
                $resumes->setItemCountPerPage(20);
                $resumes->setCurrentPageNumber($page);
            } else {
                //jobs reject
                $select_reject = $table->select()->where('reject =?', $user->getIdentity())->order('modified_date DESC');
                $this->view->page = $page = $this->_getParam('page', 1);
                $resumes = $this->view->resumes = Zend_Paginator::factory($select_reject);

                $resumes->setItemCountPerPage(20);
                $resumes->setCurrentPageNumber($page);
            }
        }
    }

    //approve resume từ người quản lý
    public function approveAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $this->view->resume_id = $id;
        $viewer = Engine_Api::_()->user()->getViewer();
        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                $resume = Engine_Api::_()->getItem('resume', $id);
                $resume->approved = 1;
                //find user resolved
                $resolved_id = $viewer->getIdentity();
                $resume->resolved_by = $resolved_id;

                $resume->save();

                $db->commit();
                //gửi mail cho người tạo resume
                $link = 'http://'
                        . $_SERVER['HTTP_HOST']
                        . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                            'module' => 'resumes',
                            'controller' => 'resume',
                            'action' => 'view',
                            'resume_id' => $resume->resume_id
                                ), 'default', true);
                $link = "<h2><a href='{$link}'>Click to view detail.</a></h2>";

                $user_data = Engine_Api::_()->getDbtable('users', 'user')->find($resume->user_id)->current();
                $from = $user_data['email'];
                $from_name = $user_data['displayname'];

                $content = "Your resume has been approved.";

                $body = $content;
                // Main params
                $defaultParams = array(
                    'host' => $_SERVER['HTTP_HOST'],
                    'email' => $user_data->email,
                    'date' => time(),
                    'sender_title' => $user_data->displayname,
                    'object_link' => $link,
                    'object_description' => $body
                );
                // Send
                try {
                    Engine_Api::_()->getApi('mail', 'core')->sendSystem($user_data, 'approve_resume', $defaultParams);
                } catch (Exception $e) {
                    // Silence exception
                }
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
        $this->renderScript('resume/approve.tpl');
    }

    //reject resume
    public function rejectAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $reason = $this->_getParam('reason_reject');
        $this->view->resume_id = $id;
        $viewer = Engine_Api::_()->user()->getViewer();
        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                $resume = Engine_Api::_()->getItem('resume', $id);
                $resume->reject = $viewer->getIdentity();
                $resume->reason = $reason;
                //lưu thông tin người reject để liệt kê trong cancelled jobs(resolved_by)
                $resume->resolved_by = $viewer->getIdentity();
                $resume->save();

                $db->commit();
                $link = 'http://'
                        . $_SERVER['HTTP_HOST']
                        . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                            'module' => 'resumes',
                            'controller' => 'resume',
                            'action' => 'view',
                            'resume_id' => $id
                                ), 'default', true);
                $link = "<h2><a href='{$link}'>Click to view detail resume.</a></h2>";
                $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
                $user_data = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
                $from = $user_data['email'];
                $from_name = $user_data['displayname'];

                $body = $reason;
                //get admin
                $tableUser = Engine_Api::_()->getDbtable('users', 'user');
                $select = $tableUser->select()
                        ->where('level_id =?', 1);
                $users = $tableUser->fetchAll($select);
                foreach ($users as $user) {
                    // Main params
                    $defaultParams = array(
                        'host' => $_SERVER['HTTP_HOST'],
                        'email' => $user->email,
                        'date' => time(),
                        'sender_title' => $user_data->displayname,
                        'object_link' => $link,
                        'object_description' => $body
                    );
                    // Send
                    try {
                        Engine_Api::_()->getApi('mail', 'core')->sendSystem($user, 'reject_resume', $defaultParams);
                    } catch (Exception $e) {
                        // Silence exception
                    }
                }
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }

            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                'parentRefresh' => 10,
                'messages' => array('You have been reject resolve this resume.')
            ));
        }
        // Output
        $this->renderScript('resume/reject.tpl');
    }

    public function updateAction() {
        $this->_helper->layout->disableLayout();
        if ($this->_request->isXmlHttpRequest()) {
            $request = Zend_Controller_Front::getInstance()->getRequest();
            $resume_id = $request->getParam('resume_id');
            $username = $request->getParam('username');
            $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);
            $resume->username = $username;
            if ($resume->save()) {
                echo 1;
                exit;
            } else {
                echo 0;
                exit;
            }
        }
    }

    public function emailAction() {
        $this->_helper->layout->disableLayout();

        if ($this->_request->isXmlHttpRequest()) {
            $request = Zend_Controller_Front::getInstance()->getRequest();
            $resume_id = $request->getParam('resume_id');
            $email = $request->getParam('emailUpdate');
            $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);
            $resume->email = $email;
            if ($resume->save()) {
                echo 1;
                exit;
            } else {
                echo 0;
                exit;
            }
        }
    }

    /* upload image to change profile */

    public function imageAction() {
        $this->_helper->layout->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
        $resume_id = $this->getRequest()->getPost('fr_resume');

        $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);
        $check_file = true;

        if ($this->_request->isPost()) {
            if (isset($_FILES['fileImage']['size'])) {
                //echo '{"message": "file"}';exit;
                $adapter = new Zend_File_Transfer_Adapter_Http();
                $adapter->addValidator('Extension', false, array('extension' => 'png,pneg,jpg,jpeg,gif', 'case' => true));
                $check_file = $adapter->isValid();
                if ($check_file == false) {
                    echo '{"message": "extension"}';
                    exit();
                } else {
                    if ($_FILES['fileImage']['size'] > 5242880) {
                        echo '{"message": "file"}';
                        exit();
                    }
                }
                $file_name = '';
                $filename = $_FILES['fileImage']['name'];
                $filetype = $_FILES['fileImage']['type'];
                $filesize = $_FILES['fileImage']['size'];
                if ($filename != '') {
                    if ($filetype == "image/gif" || $filetype == "image/jpg" || $filetype == "image/png" || $filetype == "image/jpeg" || $filetype == "image/bmp" || $filetype == "image/pjpeg") {
                        if ($filesize > 1000000) {
                            //$error['IMAGE']='File size must less than 1Mb.';
                        } else {
                            for ($i = 0; $i < 10; $i++) {
                                $ran = rand(1, 30) % 2;
                                $file_name .= $ran ? chr(rand(65, 90)) : chr(rand(48, 57));
                            }
                            $file_name .= str_replace('image/', '.', $filetype);
                            //$dir = realpath("../webroot/img/articles");
                            $dir = APPLICATION_PATH . DIRECTORY_SEPARATOR . 'public/profile_recruiter';
                            if (!empty($resume->path_image)) {
                                @unlink($dir . "/" . $resume->path_image);
                            }
                            move_uploaded_file($_FILES['fileImage']['tmp_name'], $dir . "/" . $file_name);
                            // Resize image (normal)
                            $image = Engine_Image::factory();
                            $file = $dir . "/" . $file_name;
                            $image->open($file)
                                    ->resize(151, 227)
                                    ->write($file)
                                    ->destroy();

                            $resume->path_image = $file_name;
                            $resume->save();
                        }
                    } else {
                        //$error['IMAGE']='Format file invalid.';
                    }
                }
                echo '{"message": "success"}';
                exit();
            }
        }
    }

    public function imageUpdateAction() {
        $this->_helper->layout->disableLayout();
        if ($this->_request->isXmlHttpRequest()) {
            $request = Zend_Controller_Front::getInstance()->getRequest();
            $resume_id = $request->getParam('resume_id');
            $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);
            $path_image = $resume->path_image;
            if (!empty($path_image)) {
                echo $path_image;
                exit;
            } else {
                echo 0;
                exit;
            }
        }
    }

}
