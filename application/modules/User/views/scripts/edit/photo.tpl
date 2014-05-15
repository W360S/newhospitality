<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: photo.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>
<div class="generic_layout_container layout_right">
    <div class="generic_layout_container layout_resumes_check_list"><div class="pt-right-job"> 
            <div class="pt-block">
                <h3 class="pt-title-right">Thong Tin Ca Nhan</h3>
                <ul class="pt-list-cbth">
                    <li><span class="pt-number-1">1</span><span class="pt-text"><a href="/members/edit/profile">Thong tin</a></span><span class="pt-icon-oky"></span></li>
                    <li  class="pt-active"><span class="pt-number-1">2</span><span class="pt-text"><a >Avatar</a></span><span class="pt-icon-oky"></span></li>
                </ul>
            </div>	
        </div></div>
</div>
<div class="generic_layout_container layout_middle">
    <div class="generic_layout_container layout_core_content">
        <div class="pt-title-event">
            <ul class="pt-menu-event pt-menu-libraries">
                <li>
                    <a href="/resumes/">Người tìm việc</a>
                </li>
                <li>
                    <span>Chỉnh sửa thông tin cá nhân</span>
                </li>
            </ul>
        </div>

        <?php
        /* Include the common user-end field switching javascript */
        echo $this->partial('_jsSwitch.tpl', 'fields', array(
            'topLevelId' => (int) @$this->topLevelId,
            'topLevelValue' => (int) @$this->topLevelValue
        ))
        ?>

        <?php
        $this->headTranslate(array(
            'Everyone', 'All Members', 'Friends', 'Only Me',
        ));
        ?>
        <script type="text/javascript">
            window.addEvent('domready', function() {
                en4.user.buildFieldPrivacySelector($$('.global_form *[data-field-id]'));
            });
        </script>
        <div class="pt-content">
            <?php echo $this->form->render($this) ?>
        </div>

    </div>

</div>
