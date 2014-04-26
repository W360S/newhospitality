<div class="pt-block">
    <h3 class="pt-title-right">Điểm của tôi <a href="#">Tất cả</a></h3>
    <ul class="pt-list-no">
        <?php if ($this->userpoints_enable_topusers): ?>
            <li><span>Xếp hạng:</span><strong><?php echo $this->user_rank ?></strong></li>
            <li></li>
        <?php endif; ?>
        <li><span>Đang sỡ hữu:</span><strong><?php echo $this->user_points_totalearned ?></strong><span>Coupon</span></li>
        <li></li>
    </ul>
</div>
<?php
/*
  <div class="subsection">
  <h2><?php echo $this->translate("My Point"); ?></h2>
  <ul>
  <?php if ($this->userpoints_enable_topusers): ?>
  <li>
  <?php echo $this->translate('100016726') ?>  <a href="<?php echo $this->url(array(), 'topusers') ?>"> <span style="font-weight:bold"><?php if ($this->user_points_totalearned != 0): ?> <?php echo $this->user_rank ?> <?php else: ?> <?php echo $this->translate('100016731') ?> <?php endif; ?></span> </a>
  </li>
  <?php endif; ?>
  <?php if ($this->userpoints_enable_pointrank): ?>
  <li>
  <?php echo $this->translate('100016730') ?> <span style="font-weight:bold"><?php echo $this->user_rank_title ?></span>
  </li>
  <?php endif; ?>
  <li>
  <?php echo $this->translate('100016729') ?> <span style="font-weight:bold" id="voter_points_count"><?php echo $this->user_points_totalearned ?></span> <?php echo $this->translate('100016728') ?>
  </li>
  </ul>
  </div>
 * 
 */?>