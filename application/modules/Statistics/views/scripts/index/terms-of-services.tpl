
<?php $data = $this->data ?>
<style type="text/css">
    #global_content{
        width: auto;
        margin: 0;
    }
</style>
<div class="pt-about pt-subpage">
    <div class="pt-banner-about">
        <img src="img/thumb/img-about.png" alt="Image">
    </div>
    <div class="pt-content-about">
        <div class="wd-center">
            <div class="pt-left-aobut">
                <ul>
                    <li><a href="/statistics/index/about-us" >Giới thiệu</a></li>
                    <li><a href="/statistics/index/terms-of-services" class="active">Điều khoản sử dụng</a></li>
                    <li><a href="/statistics/index/privacy">Chính sách bảo mật</a></li>
                    <li><a href="/statistics/index/coupon">Coupon</a></li>
                </ul>
            </div>
            <div class="pt-right-about">
                <?php 
                    if($data){
                        echo $data['body'];
                    }
                ?>

            </div>
        </div>
    </div>
</div>