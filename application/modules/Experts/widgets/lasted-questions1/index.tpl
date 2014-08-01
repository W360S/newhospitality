<div class="pt-block">
    <h3 class="pt-title-right">Chuyên gia <a href="#">Tất cả</a></h3>
    <?php if (count($this->data)): ?>
        <ul class="pt-list-right">
            <?php foreach ($this->data as $item): ?>
                <li>
                    <div class="pt-user-post">
                        <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title); ?>
                        <?php $poster = $item->getUser(); ?>
                        <?php $question_link = $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'detail', 'question_id' => $item->question_id, 'slug' => $slug), 'default', true); ?>
                        <a href="<?php echo $poster->getHref() ?>">
                            <span class="pt-avatar">
                                <?php echo $this->itemPhoto($poster, 'thumb.icon') ?>
                            </span>
                        </a>
                        <div class="pt-how-info-user-post">
                            
                            <h3><a href="<?php echo $question_link ?>" class="title"><?php echo $item->title; ?></a></h3>
                            <p><?php echo $this->translate('Asked by') ?>:<a href="<?php echo $this->baseUrl("/") . "profile/" . $item->username; ?>"> <?php echo $item->username; ?> </a> - <?php echo $this->timestamp($item->created_date, array('notag'=>1)); ?></p>
                            <div class="pt-how-add-views">
                                <a href="<?php echo $question_link ?>" class="pt-views"><span></span><?php echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)); ?></a>
                                <?php $rating = $item->rating;?>
                                <a href="<?php echo $question_link ?>" class="pt-commnet"><span></span><?php echo $this->translate(array('%s rating', '%s ratings', intval($item->total)), intval($item->total)); ?></a>
                            </div>
                        </div>
                        <a href="<?php echo $question_link ?>" class="pt-link-add">Xem</a>
                    </div>
                </li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
</div>
<?php /*
<h2><?php echo $this->translate('latest questions'); ?></h2>
<?php if (count($this->data)): ?>
    <ul class="list_questions">
        <?php $cnt = 1; ?>
        <?php foreach ($this->data as $item): ?>
            <li>
                <div class="list_number">
                    <?php echo $cnt; ?>
                </div>
                <div class="content_questions">
                    <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title); ?>
                    <a href="<?php echo $this->url(array('module' => 'experts', 'controller' => 'index', 'action' => 'detail', 'question_id' => $item->question_id, 'slug' => $slug), 'default', true); ?>" class="title"><?php echo $item->title; ?></a>
                    <p>
                        <?php echo $this->translate('Asked by') ?>: <a href="<?php echo $this->baseUrl("/") . "profile/" . $item->username; ?>"> <?php echo $item->username; ?> </a>
                        - 
                        <?php echo $this->timestamp($item->created_date); ?>-
                        <?php echo $this->translate(array('%s view', '%s views', intval($item->view_count)), intval($item->view_count)); ?>&nbsp;
                        <span> 
                            -
                            <?php
                            $rating = $item->rating;
                            if ($rating > 0) {
                                for ($x = 1; $x <= $rating; $x++) {
                                    ?>
                                    <span class="rating_star_generic rating_star"></span>
                                    <?php
                                }


                                $remainder = round($rating) - $rating;
                                if (($remainder <= 0.5 && $remainder != 0)):
                                    ?><span class="rating_star_generic rating_star_half"></span><?php
                                endif;
                                if (($rating <= 4)) {
                                    for ($i = round($rating) + 1; $i <= 5; $i++) {
                                        ?>
                                        <span class="rating_star_generic rating_star_disabled"></span> 	
                                        <?php
                                    }
                                }
                            } else {
                                for ($x = 1; $x <= 5; $x++) {
                                    ?>
                                    <span class="rating_star_generic rating_star_disabled"></span> 
                                    <?php
                                }
                            }
                            ?>
                            <?php echo $this->translate(array('%s rating', '%s ratings', intval($item->total)), intval($item->total)); ?>
                        </span> 
                    </p>
                </div>
            </li>
            <?php $cnt = $cnt + 1; ?>
        <?php endforeach; ?>
    </ul>	
<?php endif; ?>
<!-- <a class="view_more" href="#">View More...</a> -->
 * 
 */?>