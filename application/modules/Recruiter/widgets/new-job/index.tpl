<div class="pt-list-job">
    <ul class="pt-list-job-ul">
        <?php foreach ($this->paginator as $item): ?>
            <li class="news">
                <div class="pt-lv1"><span class="pt-fulltime">Full Time</span></div>
                <div class="pt-lv2">
                    <h3>
                        <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position); ?>
                        <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug' => $slug), $item->position) ?>
                    </h3>
                    <span><?php if ($this->company($item->user_id)) echo $this->company($item->user_id)->company_name; ?></span>
                </div>
                <div class="pt-lv3">
                    <p class="pt-address"><span></span><?php echo $this->city($item->city_id)->name ?> - <?php echo $this->country($item->country_id)->name; ?></p>
                </div>
                <div class="pt-lv4">
                    <div class="pt-user-name">
                        <a href="#" class="pt-avatar"><img src="img/thumb/img-05.jpg" alt="Image"></a>
                        <strong>Đăng bởi:</strong>
                        <p><a href="#">Vinh Bui</a><span>- 2 giờ trước</span></p><p></p>
                    </div>
                </div>
            </li>
        <?php endforeach;?>
    </ul>
    <div class="pt-paging">
        <ul class="pagination-flickr">
            <li class="previous-off">«Previous</li>
            <li class="active">1</li>
            <li><a href="?page=2">2</a></li>
            <li><a href="?page=3">3</a></li>
            <li class="next"><a href="?page=2">Next »</a></li>
        </ul>
    </div>
</div>
<?php /*
<div class="block_content gutter">
    <div class="subsection">
        <h2><?php echo $this->translate('Latest Jobs'); ?></h2>
        <div id="ajax_job">
            <?php
            if ($this->paginator->getTotalItemCount()):
                ?>
                <ul class="jobs_management">
                    <?php foreach ($this->paginator as $item): ?>
                        <li>
                            <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position); ?>
                            <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug' => $slug), $item->position) ?>
                            <div>
                                <p><?php if ($this->company($item->user_id)) echo $this->company($item->user_id)->company_name; ?></p>
                                <p>
                                    <?php echo $this->city($item->city_id)->name ?> - <?php echo $this->country($item->country_id)->name; ?>,
                                    <?php echo $this->translate('Salary: ') ?><?php echo $item->salary; ?>, <br />
                                    <?php echo $this->translate('Date Posted: ') ?><?php echo date('d F Y', strtotime($item->creation_date)); ?> 
                                </p>


                            </div>
                        </li>
                    <?php endforeach; ?>
                </ul>
                <?php
                if ($this->paginator->count() > 1):
                    ?>
                    <div class="paging">
                        <?php echo $this->paginationControl($this->paginator, null, "application/modules/Recruiter/views/scripts/pagination.tpl"); ?>
                    </div>
                <?php endif; ?>
            <?php endif; ?>
        </div>
    </div>
</div>
 * 
 */?>