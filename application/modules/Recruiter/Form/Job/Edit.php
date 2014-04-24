<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter

 * @author     huynhnv
 */
class Recruiter_Form_Job_Edit extends Recruiter_Form_Job_Create
{
    public function init()
    {
        parent::init();
    
        
        $this->submit->setLabel('Save');
    }
}