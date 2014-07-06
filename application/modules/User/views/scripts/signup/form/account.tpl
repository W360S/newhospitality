<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: account.tpl 9765 2012-08-20 21:42:23Z matthew $
 * @author     John
 */
?>
<div class="pt-sigup form-account">
    <div class="pt-title-sigup-first">
    </div>
    <script type="text/javascript">
    //<![CDATA[
        window.addEvent('load', function() {
            if ($('username') && $('profile_address')) {
                $('profile_address').innerHTML = $('profile_address')
                        .innerHTML
                        .replace('<?php echo /* $this->translate( */'yourname'/* ) */ ?>',
                                '<span id="profile_address_text"><?php echo $this->translate('yourname') ?></span>');

                $('username').addEvent('keyup', function() {
                    var text = '<?php echo $this->translate('yourname') ?>';
                    if (this.value != '') {
                        text = this.value;
                    }

                    $('profile_address_text').innerHTML = text.replace(/[^a-z0-9]/gi, '');
                });
                // trigger on page-load
                if ($('username').value.length) {
                    $('username').fireEvent('keyup');
                }
            }
        });
        <?php if(isset($_POST['password'])): ?>
            var password = '<?php echo $_POST['password'] ?>';
            jQuery(document).ready(function($){
                $("input#password").val(password);
                $("input#passconf").val(password);
            });
        <?php endif; ?>
        
        jQuery(document).ready(function($){
            $("#submit-element button#submit").html("<span></span>Tiếp tục");
            
            $("#1_1_4-wrapper").hide();
            $("#1_1_3-wrapper").hide();
            
            jQuery('.form-errors>li').each(function(el){
                var inner_li = jQuery(this);
                //console.log(inner_li);
                var inner_li_text = (inner_li[0].childNodes[0].nodeValue);
                var inner_li_value = inner_li[0].childNodes[1].innerText;
                switch (inner_li_text){
                    case "Địa chỉ email":
                        {   
                            jQuery('#email-element').append("<p class='form-error'>" + inner_li_value + "</p>");
                        }
                        break;
                    case "Mật khẩu":
                        {   
                            jQuery('#password-element').append("<p class='form-error'>" + inner_li_value + "</p>");
                        }
                        break;
                    case "Nhập lại mật khẩu":
                        {   
                            jQuery('#passconf-element').append("<p class='form-error'>" + inner_li_value + "</p>");
                        }
                        break;
                    case "Địa chỉ profile":
                        {   
                            jQuery('#username-element').append("<p class='form-error'>" + inner_li_value + "</p>");
                        }
                        break;
                    case "Điều khoản sử dụng":
                        {   
                            jQuery('#terms-element').append("<p class='form-error'>" + inner_li_value + "</p>");
                        }
                        break;
                    default:
                        {
                            
                        }
                } 
            }); 
            
            jQuery('.form-errors').hide();
        });
    //]]>
    </script>
    <style>
        p.form-error{color: red}
    </style>

    <?php echo $this->form->render($this) ?>
</div>