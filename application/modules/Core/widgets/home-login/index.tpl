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

<div id="wd-header-line">
    <div class="wd-center">
        <div class="pt-header-line-left">
            <h2>Mạng nhân lực du lịch khách sạn Việt Nam</h2>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
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
                            <input type="text">
                        </div>
                        <div class="wd-input wd-input-wm">
                            <label>Tên</label>
                            <input type="text">
                        </div>
                        <div class="wd-input">
                            <label>Email của bạn</label>
                            <input type="text" id="email" name="email">
                        </div>
                        <div class="wd-input">
                            <label>Nhập lại email</label>
                            <input type="text">
                        </div>
                        <div class="wd-input">
                            <label>Tạo mật khẩu</label>
                            <input id="password" name="password" type="text">
                        </div>
                        <div class="wd-input">
                            <p>Khi nhấp chuột vào Đăng Ký, bạn đồng ý với Các điều khoản của chúng tôi </p>
                            <button type="submit" title="" class="button">Đăng ký</button>
                        </div>
                        <div style="display: none">
                            <input type="hidden" id="timezone" name="timezone" value="Asia/Krasnoyarsk">
                            <input type="hidden" id="language" name="language" value="vi">
                            <input type="hidden" id="terms" name="terms" value="1">
                        </div>
                    </fieldset>
                </form>

            </div>
        </div>
    </div>
</div>