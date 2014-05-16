<?php
$paginator = $this->paginator;
$category_id = $this->category_id;
?>
<div class="subsection">
    <?php if (count($paginator) > 0): ?>
        <div class="pt-list-table pt-list-table-first">
            <table cellspacing="0" cellpadding="0">
                <thead>
                    <tr>
                        <th><strong>Tiêu đề hồ sơ</strong></th>
                        <th><strong>Tỉnh / Thành Phố</strong></th>
                        <th><strong>Trình Độ / Kinh Nghiệm</strong></th>
                    </tr>
                </thead>
                <tbody>
                    <?php $cnt = 1; ?>
                    <?php foreach ($paginator as $item): ?>

                        <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title); ?>
                        <tr class="odd">
                            <td>
                                <?php $user = $item->getUser(); ?>
                                <?php $avatar = $this->itemPhoto($user, 'thumb.icon', $user->getTitle()) ?>

                                <div class="pt-user-name">
                                    <a href="<?php echo $user->getHref() ?>" class="pt-avatar">
                                        <?php echo $avatar ?>
                                    </a>
                                    <h2>
                                        <a href="<?php echo $this->baseUrl() . '/resumes/resume/view/resume_id/' . $item->resume_id . '/' . $slug ?>">
                                            <?php echo $item->title; ?>
                                        </a>
                                    </h2>
                                    <p><a href="javascript:void(0)"><?php echo $this->user($item->user_id) ?></a></p>
                                </div>
                            </td>
                            <?php
                            $userOptions = Engine_Api::_()->fields()
                                    ->getFieldsValuesByAlias($user);
                            
                            $from_option_id = $userOptions['from'];

                            $fieldOptions = Engine_Api::_()->fields()
                                    ->getFieldsObjectsByAlias($user, "from");
                            $fieldOption = $fieldOptions['from'];
                            $options = $fieldOption->getOptions();
                            foreach ($options as $option) {
                                $multiOptions[$option->option_id] = $option->label;
                            }
                            $from = ($multiOptions[$from_option_id]);
                            
                            ?>
                            <td><?php echo $from ?></td>
                            <?php
                            $works = Engine_Api::_()->getApi('core', 'resumes')->getListWork($item->resume_id);
                            $total_year = 0;
                            foreach ($works as $work) {
                                $total_year+= $work->num_year;
                            }
                            $educations = Engine_Api::_()->getApi('core', 'resumes')->getListEducation($item->resume_id);
                            foreach ($educations as $education) {
                                $viewer_education = $education;
                                break;
                            }
                            ?>
                            <td>

                        <?php echo $this->degree($viewer_education->degree_level_id)->name; ?> / <?php echo $total_year ?> năm</td>
                        </tr>
                        <?php $cnt = $cnt + 1; ?>
    <?php endforeach; ?>

                </tbody>
            </table>

        </div>

<?php else: ?>
        <div style="margin-top: 5px; margin-left: 5px;" class="tip">
            <span>
    <?php echo $this->translate("Haven't resumes in this category.") ?>
            </span>
        </div>

<?php endif; ?>
</div>
<?php
if (count($paginator) > 0) {
    echo $this->paginationControl($paginator);
}
?>