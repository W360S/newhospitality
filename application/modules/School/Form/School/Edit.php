<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    School

 * @author     huynhnv
 */
class School_Form_School_Edit extends School_Form_School_Create
{
    public function init()
    {
        parent::init();
    
        
        $this->submit->setLabel('Save');
    }
}