<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>
<style>

</style>
<div id="wd-header-line">
    <div class="wd-center">
        <div class="pt-header-line-left">
            <h2>Mạng Du lịch Khách sạn Việt Nam </h2>
            <p>Tương tác – Kết nối nhân sự ngành du lịch khách sạn</p>
            <div class="">
                <img src="application/themes/newhospitality/images/thumb/img-01.png" alt="Image">
            </div>
        </div>
        <div class="pt-header-line-right">
            <h2>Đăng ký ngay </h2>
            <div class="wd-form-registered">
                <form enctype="application/x-www-form-urlencoded" class="global_form" action="/signup" method="post">
                    <fieldset>  
                        <div class="wd-input wd-input-w ">
                            <label>Họ</label>
                            <input type="text" id="1_1_3" name="1_1_3" >
                        </div>
                        <div class="wd-input wd-input-wm">
                            <label>Tên</label>
                            <input type="text" id="1_1_4" name="1_1_4" >
                        </div>
                        <div class="wd-input">
                            <label>Email của bạn</label>
                            <input type="text" id="email" name="email">
                        </div>
                        
                        <div class="wd-input">
                            <label>Tạo mật khẩu</label>
                            <input id="password" name="password" type="password">
                        </div>
                        <div class="wd-input wd-register-submit">
                            <p>Khi nhấp chuột vào Đăng Ký, bạn đồng ý với Các điều khoản của chúng tôi </p>
                            <button type="submit" title="" class="button">Đăng ký</button>
                            <!--<span>Hoặc có thể</span>-->
                            <a href="/user/auth/facebook" class="facebook">Facebook</a>
                        </div>
                        <div style="display: none">
                            <!--<input type="hidden" id="timezone" name="timezone" value="">-->
                            <input type="text" name="username" id="username" value="">
                            <input type="password" name="passconf" id="passconf" value="">
                            <input type="hidden" id="timezone" name="timezone" value="Asia/Krasnoyarsk">
                            <input type="hidden" id="language" name="language" value="vi">
                            <input type="hidden" id="terms" name="terms" value="0">
                        </div>
                    </fieldset>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    function validateEmail(email) { 
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    } 
    jQuery(document).ready(function($) {
        console.log("Register form");
        $("input#password").blur(function() {
            $("input#passconf").attr("value", $(this).val());
        });
        $("input#email").blur(function() {
            var email = $(this).val();
            if(validateEmail(email)){
                var username = email.split("@");
                console.log(username);
                console.log(username[0]);
                username = username[0];
                username = username.replace(/[_\W]+/g, "");
                if(username[0]){
                    $("input#username").attr("value", username);
                }
                
            }
            
        });
    });
</script>