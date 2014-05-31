<style type="text/css">
    .content_online_resume p{color:#262626;text-align:center;margin:10px 0;font-size:13px}
    .content_online_resume a.bt_create{display:block;width:198px;height:43px;background:url(application/modules/Job/externals/images/bg-btn-3.gif) no-repeat;color:#fff;font-size:14px;font-weight:bold;line-height:43px;margin-left:34px;text-align:center}
    .content_online_resume a:hover.bt_create{background-position:0 -43px}
    .content_online_resume select{border:1px solid #e5e5e5;padding:5px 5px 5px 16px ;margin:10px 0 10px 34px;color:#262626;width:198px}
    .pt-block {
        background-color: #FFFFFF;
        margin-bottom: 20px;
        overflow: hidden;
    }
    .pt-contents-response {
        overflow: hidden;
        padding: 20px;
        text-align: center;
    }
    .pt-contents-response a {
        background-color: #48CFAD;
        border-radius: 3px;
        color: #FFFFFF;
        display: inline-block;
        font-size: 14px;
        margin-top: 10px;
        padding: 8px 10px;
    }
    .pt-contents-response {
        overflow: hidden;
        padding: 20px;
        text-align: center;
    }
    .pt-contents-response p {
        color: #404040;
        font-size: 13px;
    }

    .pt-contents-response a:hover {
        background-color: #068162;
    }

</style>

<div class="pt-block">
    <div class="pt-contents-response">

        <p><?php echo $this->translate("Get spotted by your dream employer!"); ?></p>			
        <a style="color: #fff;font-size: 14px;text-decoration: none;text-transform: uppercase;"  href="<?php echo $this->baseUrl() . '/resumes/index/resume-info' ?>"><?php echo $this->translate("Create a Resume ") ?>(<?php $re = 3 - count($this->sum_resume);
echo $re . $this->translate(" Left"); ?>)</a>

        <select id="resume" onchange="view_resume();" style="border:1px solid #CCCCCC;margin-top:5px;padding:10px;">
            <option value="0"><?php echo $this->translate("Choose resume"); ?></option>
            <?php foreach ($this->sum_resume as $resume) { ?>
                <option value="<?php echo $resume->resume_id; ?>"><?php echo $resume->title; ?></option>
<?php } ?>
        </select>           

    </div>
</div>

<script type="text/javascript">
    function view_resume() {
        var value = $('resume').get('value');
        if (value != 0) {
            window.location.href = "<?php echo $this->baseUrl() . '/resumes/index/preview/resume_id/' ?>" + value;
        }
    }

    var TOTAL_RESUMES = <?php echo count($this->sum_resume) ?>;
    var APPROVED_RESUMES = <?php echo count($this->approved_resumes) ?>;

    jQuery(document).ready(function($){
        if (TOTAL_RESUMES == 0) {
            $("button.icon-02").attr("onclick","alert('Bạn phải tạo hồ sơ trước khi ứng tuyển')");
            $("button.icon-01").attr("onclick","alert('Bạn phải tạo hồ sơ trước khi ứng tuyển')");
        }else{
            if(APPROVED_RESUMES == 0){
                $("button.icon-02").attr("onclick","alert('Hồ sơ của bạn đang được duyệt, bạn có thể nộp hồ sơ ngay sau khi hồ sơ được duyệt hoặc gọi ngay cho bộ phận admin')");
                $("button.icon-01").attr("onclick","alert('Hồ sơ của bạn đang được duyệt, bạn có thể nộp hồ sơ ngay sau khi hồ sơ được duyệt hoặc gọi ngay cho bộ phận admin')");
            }
        }
    });

</script>
