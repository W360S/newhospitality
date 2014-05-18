<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: login.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>
<style type="text/css">
    #global_page_user-auth-login #global_content .layout_middle{min-height: inherit;width: inherit;float: none; padding: 0; border: none;}
    #global_page_user-auth-login #global_content .layout_middle #wd-content-container{margin: 30px 0px}
    #global_page_user-auth-login .layout_page_header .layout_main{width: 990px}
    #global_page_user-auth-login .layout_page_footer .layout_main{width: 990px}
    #global_page_user-auth-login input[type='password']{width: inherit;}
    #global_page_user-auth-login .form-element input{width: inherit;}
    #global_page_user-auth-login .form-wrapper{height: 45px;margin: 15px 0px}
    #global_page_user-auth-login .form-element {width: 275px}
    #global_page_user-auth-login .form-label {font-size: 12px}
    #global_page_user-auth-login .form-errors {display: none;}
</style>
<div id="wd-content-container">
    <div class="wd-center">
        <div class="pt-signin">
            <div class="pt-signin-title">
                <h2>Thành viên đăng nhập</h2>
                <p>If you already have an account, please enter your details below. If you don't have one yet, please sign up first.</p>
            </div>
            <div class="pt-signin-reported" style="display: none">
                <p><span></span><strong>Email</strong> hoặc <strong>mật khẩu</strong> của bạn không đúng</p>
            </div>
            <div class="pt-how-login-checkout">
                <div class="login-checkout">
                    <?php echo $this->form->render($this)  ?>
                </div>
                <div class="pt-link-networking">
                    <p>Hoặc có thể</p>
                    <a href="/user/auth/facebook" class="facebook">Facebook</a>
                    <!--<a href="#" class="twitter">Twitter</a>-->
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    jQuery(document).ready(function($){
        console.log("ready");
        if($("ul.form-errors")){
            console.log($("ul.form-errors").html());
            $("div.pt-signin-reported p").html($("ul.form-errors").html());
            $("div.pt-signin-reported").show();
        }
    });
</script>