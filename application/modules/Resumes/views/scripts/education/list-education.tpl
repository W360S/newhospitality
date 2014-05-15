<?php if (!empty($this->educations) && count($this->educations) >= 1) : ?>

    <?php foreach ($this->educations as $education): ?>
        <ol>
            <li><strong><?php echo $education->school_name; ?></strong></li>
        </ol>

        <?php 
            $month_start = date("m",strtotime($education->starttime));
            $month_end = date("m",strtotime($education->endtime));
            $year_start = date("Y",strtotime($education->starttime));
            $year_end = date("Y",strtotime($education->endtime));
        ?>
        
        <span><?php echo $education->major; ?>
             - Từ tháng <?php echo $month_start ?> <?php echo $year_start ?> đến 
             Tháng <?php echo $month_end ?> <?php echo $year_end ?>
        </span>
        <p>
            <a class="edit" title="<?php echo $this->translate('Edit') ?>" href="javascript:void(0);" onclick="edit_education('<?php echo $education->education_id ?>');">Edit</a> | 
            <a class="smoothbox" title="<?php echo $this->translate('Delete') ?>" href="javascript:void(0);" onclick="delete_education('<?php echo $education->education_id ?>');">Delete</a>
        </p>
        <div style="display:none">

            <input id="degree_level_edu_<?php echo $education->education_id ?>" value="<?php echo $education->degree_level_id ?>" />
            <input id="school_name_edu_<?php echo $education->education_id ?>" value="<?php echo $education->school_name ?>" />
            <input id="major_edu_<?php echo $education->education_id ?>" value="<?php echo $education->major ?>" />
            <input id="country_edu_<?php echo $education->education_id ?>" value="<?php echo $education->country_id ?>" />

            <input id="start_edu_<?php echo $education->education_id ?>" value="<?php echo $education->starttime ?>" />
            <input id="end_edu_<?php echo $education->education_id ?>" value="<?php echo $education->endtime ?>" />
            <div id="description_edu_<?php echo $education->education_id ?>"><?php echo $education->description ?></div>
        </div>
    <?php endforeach; ?>

<?php else: ?>
    <strong>Mô tả chi tiết:</strong>
    <ol>
        <li>Liệt kê bằng cấp chuyên môn, các khóa ngắn hạn hay những chương trình sau đại học bạn đã theo học.</li>
    </ol>
<?php endif; ?>