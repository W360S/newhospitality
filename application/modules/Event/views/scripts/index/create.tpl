<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: create.tpl 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */
?>
<style type="text/css">
    .global_form > div {
        padding: 0 0 9px 0px;
    }
    #event_create_form .form-wrapper{
        *padding-top: 5px;
    }
    #event_create_form button{
        *padding:3px 0px;
    }
    table#description_tbl{
        width: 443px !important;
    } 
</style>
<?php
$this->headScript()
        ->appendFile($this->baseUrl() . '/externals/calendar/calendar.compat.js');
$this->headLink()
        ->appendStylesheet($this->baseUrl() . '/externals/calendar/styles.css');
?>

<div class="">
    <style>
        .global_form > div {
            padding: 0 0 9px !important;
            width: 100%;
        }
        .global_form > div > div {
            background: none repeat scroll 0 0 #FFFFFF;
            padding: 12px;
            width: 100%;
            border:none;
        }
    </style>
    <div class=""> 
        <div class="wd-content-event">
            <div class="pt-title-event">
                <ul class="pt-menu-event">
                    <li class="">
                        <a href="<?php echo $this->baseUrl(); ?>/events"><?php echo $this->translate('Upcoming Events') ?></a>
                    </li>
                    <li>
                        <a href="<?php echo $this->baseUrl(); ?>/events/past"><?php echo $this->translate('Past Events') ?></a>
                    </li>
                    <li>
                        <a href="<?php echo $this->baseUrl(); ?>/events/manage"><?php echo $this->translate('My Events') ?></a>
                    </li>
                </ul>
                <a href="<?php echo $this->baseUrl(); ?>/events/create" class="pt-registering-event"><span></span><?php echo $this->translate('Create New Event') ?></a>
            </div>
            <?php
            $form = $this->form;
            echo $form->render();
            ?>
        </div>
    </div>
</div>