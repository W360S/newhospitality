<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    School

 * @author     huynhnv
 */
class School_Form_Artical_Edit extends School_Form_Artical_Create
{
    public function init()
    {
        parent::init();
    
        
        $this->submit->setLabel('Save');
    }
}