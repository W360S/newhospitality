<?php
$paginator = $this->paginator;
$keyword = $this->keyword;
$country_id = $this->country_id;
$city_id = $this->city_id;
$level = $this->level;
$language = $this->language;
$degree = $this->degree;
$values = $this->values;
$no_req = $this->no_req;
$industry = $this->industry;
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
<script type="text/javascript">
    window.addEvent('domready', function() {
        var keyword = "<?php echo $keyword ?>";
        //var country_id= "<?php echo $country_id ?>";
        var city_id = "<?php echo $city_id ?>";

        var level = "<?php echo $level ?>";
        var language = "<?php echo $language ?>";
        var degree = "<?php echo $degree ?>";
        var industry = "<?php echo $industry ?>";
        $('search_resume').set('value', keyword);
        var no_req = "<?php echo $no_req ?>";
        var temp_country_id = country_id = 230;
        if (no_req != 1) {
            //jQuery('#country_id option').each(function(){
            //if(country_id==jQuery(this).val()){
            //jQuery(this).attr('selected', 'selected');

            //}
            var url = "<?php echo $this->baseUrl() . '/resumes/index/city' ?>";


            new Request({
                url: url,
                method: "post",
                data: {
                    'country_id': country_id
                },
                onSuccess: function(responseHTML)
                {

                    $('city_id').set('html', responseHTML);
                    if (temp_country_id == 230 && city_id == 0) {

                        jQuery('#city_id').prepend("<option value='0'><?php echo $this->translate('All city') ?></option>");
                    }

                    jQuery('#city_id option').each(function() {
                        if (city_id == jQuery(this).val()) {
                            jQuery(this).attr('selected', 'selected');
                        }
                    });
                }
            }).send();

            //});

            jQuery('#level option').each(function() {
                if (level == jQuery(this).val()) {
                    jQuery(this).attr('selected', 'selected');
                }
            });
            //jQuery('#language option').each(function(){
            //if(language==jQuery(this).val()){
            //jQuery(this).attr('selected', 'selected');
            //} 
            //});
            //jQuery('#degree option').each(function(){
            //if(degree==jQuery(this).val()){
            //jQuery(this).attr('selected', 'selected');
            //} 
            //});
            jQuery('#industry option').each(function() {
                if (industry == jQuery(this).val()) {
                    jQuery(this).attr('selected', 'selected');
                }
            });
        }
        else {
            var str = "<?php echo $this->translate('Enter resume title,') ?>";
            $('search_resume').set('value', str);
        }
    });
</script>