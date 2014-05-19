<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/ * @version    $Id: index.tpl 9987 2013-03-20 00:58:10Z john $
 * @author     John
 */
?>

<?php $subject = $this->subject; //print_r($subject);die;?>

<div class="pt-boss">
    <a href="#"><span class="pt-avatar"><?php echo $this->itemPhoto($subject) ?></span></a>
    <div class="pt-how-info-boss">
            <h3><a href="javascript:void(0)"><?php echo $subject->getTitle() ?></a></h3>
            <p><?php echo $subject->getFieldByAlias("occupation") ?></p>
            <p><a><span></span></a><?php echo $subject->getFieldByAlias("from") ?></p>
    </div>
    <div class="pt-how-link">
            <!--<a href="#" class="pt-friends"><span></span>Bạn bè</a>-->
            <?php echo $this->userFriendship($subject, null, " pt-friends") ?>
            <a href="/messages/compose/to/<?php echo $subject->user_id ?>" class="pt-message-boss"><span></span></a>
            <div class="pt-none">
                    <div id="pt-fancybox-message" class="pt-info-message">
                            <h3>Gửi tin nhắn</h3>
                            <form name="frm_contact" method="post" accept-charset="utf-8">
                                    <fieldset>
                                            <ul>
                                                    <li>
                                                            <label>Đến</label>
                                                            <input type="text" name="name">
                                                            <div class="wd-adap-tag-composercitytagger">
                                                                    <span>Backstreet Boys</span>
                                                                    <a href="#">Delete</a>
                                                            </div>
                                                    </li>
                                                    <li>
                                                            <div class="pt-textarea-01"><textarea></textarea></div>
                                                    </li>
                                                    <li class="last">
                                                            <a href="#" class="pt-file"><span class="pt-icon-list"></span>Đính kèm<input type="file" title="" multiple="1" name="composer-unpublished-photo[]" aria-label=""></a>
                                                            <button type="submit" title="" class="button">Gửi</button>
                                                    </li>
                                            </ul>
                                    </fieldset>
                            </form>
                    </div>
            </div>
            <a href="#" class="pt-editing">Editing</a>
            <div class="pt-toggle-layout">
                    <div class="pt-icon-arrow"><span></span></div>
                    <div class="pt-toggle-layout-content">
                            <ul class="pt-edit">
                                    <li>
                                            <a href="#"><span class="pt-icon-01"></span>Tặng coupon</a>
                                    </li>
                                    <li>
                                            <a href="#"><span class="pt-icon-02"></span>Thông báo</a>
                                    </li>
                                    <li>
                                            <a href="#"><span class="pt-icon-03"></span>Chặng thành viên</a>
                                    </li>
                            </ul>
                    </div>
            </div>
    </div>
    <div class="clear-both"></div>
</div>

<?php /*
<ul>
    <?php if (!empty($this->memberType)): ?>
        <li>
            <?php echo $this->translate('Member Type:') ?>
            <?php echo $this->translate($this->memberType) ?>
        </li>
    <?php endif; ?>
    <?php if (!empty($this->networks) && count($this->networks) > 0): ?>
        <li>
            <?php echo $this->translate('Networks:') ?>
            <?php echo $this->fluentList($this->networks) ?>
        </li>
    <?php endif; ?>
    <li>
        <?php echo $this->translate('Profile Views:') ?>
        <?php echo $this->translate(array('%s view', '%s views', $this->subject->view_count), $this->locale()->toNumber($this->subject->view_count))
        ?>
    </li>
    <li>
        <?php $direction = Engine_Api::_()->getApi('settings', 'core')->getSetting('user.friends.direction');
        if ($direction == 0):
            ?>
            <?php echo $this->translate('Followers:') ?>  
            <?php echo $this->translate(array('%s follower', '%s followers', $this->subject->member_count), $this->locale()->toNumber($this->subject->member_count))
            ?>      
        <?php else: ?>  
            <?php echo $this->translate('Friends:') ?>
            <?php echo $this->translate(array('%s friend', '%s friends', $this->subject->member_count), $this->locale()->toNumber($this->subject->member_count))
            ?>
<?php endif; ?>
    </li>
    <li>
        <?php echo $this->translate('Last Update:'); ?>
<?php echo $this->timestamp($this->subject->modified_date) ?>
    </li>
    <li>
        <?php echo $this->translate('Joined:') ?>
    <?php echo $this->timestamp($this->subject->creation_date) ?>
    </li>
<?php if (!$this->subject->enabled && $this->viewer->isAdmin()): ?>
        <li>
            <em>
                <?php echo $this->translate('Enabled:') ?>
    <?php echo $this->translate('No') ?>
            </em>
        </li>
<?php endif; ?>
</ul>

<script type="text/javascript">
    $$('.core_main_user').getParent().addClass('active');
</script>
*/ ?>