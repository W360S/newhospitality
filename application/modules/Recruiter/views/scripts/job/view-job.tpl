<?php
$job = $this->job;
$industries = $this->industries;
$categories = $this->categories;
$types = $this->types;
$contactvias = $this->contact_vias;
$contact = $this->contact;
$user_id = $this->user_id;
//thay \n bằng br
$des = str_replace("\n", "<br />", $job->description);
$skill_des = str_replace("\n", "<br />", $job->skill);
?>
<div class="pt-job-detail">
    <h3><?php echo $job->position; ?></h3>

    <!--COMPANY INFO-->
    <div class="pt-job-detail-title">
        <img src="img/thumb/img-avatar-07.jpg" alt="Image">
        <h4>Paradise Cruises</h4>
        <span>uan Chau Island</span>
        <p>Paradise Cruises launched their first vessel in 2008. However, the foundations of the company were laid a few years ahead with the building of the bridge linking Tuan Chau Island to the main land and the ensuing possibility to bring passengers to a private pier, a service never yet offered by cruise companies of Halong bay.
            The concept of the company came along, to offer a unique cruising exp... <a href="#">Xem thêm</a></p>
        <p>Qui mô công ty: 100-499<br>
            Tên người liên hệ: Ms. Cat Tuong</p>
    </div>

    <!--JOB INFO-->
    <ul class="pt-list-content">
        <li>
            <strong>Hạn chót nộp hồ sơ</strong>
            <span>
                <?php echo date('d F Y', strtotime($job->deadline)); ?>
                <?php
                if ($job->deadline < date('Y-m-d')) {
                    echo " - <b style='color: red'>Expired</b>";
                }
                ?>
            </span>
        </li>
        <li>
            <strong>Nơi làm việc</strong>
            <a href="javascript:void(0)"><?php echo $this->city($job->city_id)->name ?> - <?php echo $this->country($job->country_id)->name; ?></a>
        </li>
        <li>
            <strong>Cấp bậc</strong>
            <?php echo $job->position; ?>
        </li>
        <li>
            <strong>Ngành nghề</strong>
            <?php
            $i = 0;
            foreach ($industries as $industry) {
                $i++;
                if ($i == count($industries)) {
                    echo $this->industry($industry->industry_id)->name;
                } else {
                    echo $this->industry($industry->industry_id)->name . " - ";
                }
            }
            ?>
        </li>
        <li>
            <strong>Ngôn ngữ trình bày hồ sơ</strong>
            <span>Tiếng Việt</span>
        </li>
    </ul>
    <h4>Mô tả công việc</h4>
    <p>
<?php echo $skill_des ?>
<?php echo $des ?>
    </p>
    <h4>Yêu cầu công việc</h4>
    <p>
<?php echo $skill_des ?>
    </p>
    <h4>Thông tin liên hệ</h4>
    <p><span>Liên Hệ</span>: <strong><?php echo $job->contact_name; ?></strong></p>
    <p><span>Địa Chỉ</span>: <?php echo $job->contact_address; ?></p>
    <p><span>Liên lạc qua</span>: 
        <?php
        $i = 0;
        if (count($contactvias) > 0) {
            foreach ($contactvias as $contactvia) {
                $i++;
                if ($i == count($contactvias)) {
                    echo $this->contact($contactvia->contact_id)->name;
                } else {
                    echo $this->contact($contactvia->contact_id)->name . " - ";
                }
            }
        }
        ?>
    </p>
    <p><span>Số điện thoại</span>: <?php echo $job->contact_phone;?></p>
    <p><span>Thư điện tử</span>: <?php echo $job->contact_email;?></p>
    
    <!--TEMPORARY TURN OFF-->
    
<!--    <div class="pt-info-coupon">		
        <ul>
            <li><a href="#"><img src="img/front/icon-001.png" alt="Image"></a></li>
            <li><a href="#"><img src="img/front/icon-002.png" alt="Image"></a></li>
            <li><a href="#"><img src="img/front/icon-003.png" alt="Image"></a></li>
            <li><a href="#"><img src="img/front/icon-004.png" alt="Image"></a></li>
            <li class="last"><span>9</span></li>
        </ul>
    </div>-->

    <div class="pt-lv-02">
        <button type="submit" title="" class="button icon-01" onclick="save_job('<?php echo $job->job_id;?>')"><span></span>Lưu việc này</button>
        <button type="submit" title="" class="button icon-02" onclick="apply_job('<?php echo $job->job_id;?>')"><span></span>Nộp đơn</button>
        <img src="application/themes/newhospitality/images/thumb/img-submit-oky1.png" alt="Image">
    </div>
</div>
<script type="text/javascript">
function apply_job(job_id){
    var url= "<?php echo $this->baseUrl().'/recruiter/job/apply-job/job_id/'?>"+ job_id;
    window.location.href= url;
}
function save_job(job_id){
    var url= "<?php echo $this->baseUrl().'/recruiter/job/save-job/job_id/'?>"+ job_id;
    window.location.href= url;
}
</script>