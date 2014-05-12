<div class="pt-block">
    <h3 class="pt-title-right">Hồ sơ gợi ý</h3>
    <ul class="pt-list-right pt-list-right-fix">
        <?php foreach ($this->paginator as $paginator) : ?>
            <li>
                <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($paginator->title); ?>
                <div class="pt-user-post">
                    <a href="#"><span class="pt-avatar"><?php echo $this->itemPhoto($this->user($paginator->user_id), "thumb.icon"); ?></span></a>
                    <div class="pt-how-info-user-post">
                        <h3><a href="<?php echo $this->baseUrl() . '/resumes/resume/view/resume_id/' . $paginator->resume_id . '/' . $slug ?>"><?php echo $paginator->title; ?></a></h3>
                        <?php echo $this->user($paginator->user_id) ?>
                    </div>
                </div>
            </li>
        <?php endforeach; ?>
    </ul>
</div>