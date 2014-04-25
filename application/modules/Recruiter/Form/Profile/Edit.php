<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter

 * @author     huynhnv
 */
class Recruiter_Form_Profile_Edit extends Recruiter_Form_Profile_Create
{
    public function init()
    {
        parent::init();
    
        
        $this->submit->setLabel('Save');
    }
}