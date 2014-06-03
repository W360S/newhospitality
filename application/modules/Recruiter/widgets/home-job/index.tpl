<div class="block_content">

    <div class="pt-block">

        <h3 style="border-bottom: 1px solid #E5E5E5;color: #262626;font-size: 14px; font-weight: normal; margin: 0 10px;overflow: hidden; padding: 10px 0;  text-transform: uppercase;"><?php echo $this->translate('Hot Jobs'); ?></h3><a style="color: rgb(79, 193, 233); display: inline-block; float: right; font-size: 12px; text-transform: none; position: relative; margin-right: 21px; margin-top: -28px;" ><?php echo $this->translate('All'); ?></a>
        <div id="ajax_hot_job">
            <?php if ($this->hot_paginator->getTotalItemCount()): ?>
                <ul class="pt-list-right">
                    <?php foreach ($this->hot_paginator as $item): ?>
                        <li>
                            <div class="pt-user-post">
                                <a href="#">
                                    <span class="pt-avatar">
                                        <?php $recruiter = $this->company($item->user_id); ?>
                                        <?php echo $this->itemPhoto($recruiter, 'thumb.icon') ?>
                                    </span>
                                </a>
                                <div class="pt-how-info-user-post">
                                    <h3>
                                        <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position); ?>
                                        <?php $text = $item->position; ?>
                                        <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug' => $slug), $text) ?>
                                        
                                    </h3>
                                    Hết hạn: <?php echo $item->deadline ?>
                                    <p>
                                        <?php //echo date('d F Y', strtotime($item->creation_date)); ?> 
                                        Đăng ngày <?php echo $this->timestamp($item->creation_date, array("notag" => 1)) ?> - <?php echo $this->city($item->city_id)->name ?></p>

                                </div>
                            </div>
                        </li>
                    <?php endforeach; ?>
                </ul>
                <?php if ($this->hot_paginator->count() > 1): ?>
                    <div class="paging">
                        <?php //echo $this->paginationControl($this->hot_paginator, null, "application/modules/Recruiter/views/scripts/hot_pagination.tpl"); ?>
                    </div>
                <?php endif; ?>
            <?php endif; ?>
        </div>
    </div>
</div>
<style>
    .block_content{width:273px;}
    #global_page_user-index-home .block_content{width:auto;}
    .pt-user-post .pt-how-info-user-post h3 a{font-size:12px;}
</style>