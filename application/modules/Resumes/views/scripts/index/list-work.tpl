<?php if (!empty($this->works) && count($this->works) >= 1) : ?>

    <?php foreach ($this->works as $work): ?>
        <ol>
            <li><strong><?php echo $work->title; ?></strong></li>
        </ol>
        <?php 
            $month_start = date("m",strtotime($work->starttime));
            $month_end = date("m",strtotime($work->endtime));
            $year_start = date("Y",strtotime($work->starttime));
            $year_end = date("Y",strtotime($work->endtime));
        ?>
        <span><?php echo $work->company_name; ?> - Từ tháng <?php echo $month_start ?> <?php echo $year_start ?> đến 
             Tháng <?php echo $month_end ?> <?php echo $year_end ?>
        </span>
        <p>
            <a class="edit" title="<?php echo $this->translate('Edit') ?>" href="javascript:void(0);" onclick="edit_work('<?php echo $work->experience_id ?>');">Edit</a> | 
            <a class="smoothbox" title="<?php echo $this->translate('Delete') ?>" href="javascript:void(0);" onclick="delete_work('<?php echo $work->experience_id ?>');">Delete</a>
        </p>

        <div style="display:none">

            <input id="num_year_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->num_year ?>" />
            <input id="title_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->title ?>" />
            <input id="company_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->company_name ?>" />
            <input id="job_level_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->level_id ?>" />
            <input id="category_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->category_id ?>" />
            <input id="country_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->country_id ?>"/>
            <input id="city_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->city_id ?>" />
            <input id="start_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->starttime ?>" />
            <input id="end_exp_<?php echo $work->experience_id ?>" value="<?php echo $work->endtime ?>" />
            <div id="description_exp_<?php echo $work->experience_id ?>"><?php echo $work->description ?></div>
        </div>

    <?php endforeach; ?>

<?php else: ?>
    <strong>Mô tả chi tiết:</strong>
    <ol>
        <li>Nhiệm vụ chính của từng vị trí bạn đảm trách</li>
        <li>Dự án đã tham gia hay quản lý (nếu có)</li>
        <li>Thành tích, kỹ năng đạt được</li>
    </ol>
<?php endif; ?>