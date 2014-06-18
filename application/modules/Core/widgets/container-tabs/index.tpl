<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Weblego Developments
 * @license    http://www.sacialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<script type="text/javascript">
    en4.core.runonce.add(function() {
        var tabContainerSwitch = window.tabContainerSwitch = function(element) {
            if (element.tagName.toLowerCase() == 'a') {
                element = element.getParent('li');
            }

            var myContainer = element.getParent('.tabs_parent').getParent();

            myContainer.getChildren('div:not(.tabs_alt)').setStyle('display', 'none');
            myContainer.getChildren('div:not(.tabs_alt)').removeClass('ui-state-active');
            myContainer.getElements('ul > li').removeClass('ui-state-active');
            element.get('class').split(' ').each(function(className) {
                className = className.trim();
                if (className.match(/^tab_[0-9]+$/)) {
                    myContainer.getChildren('div.' + className).setStyle('display', null);
                    myContainer.getChildren('div.' + className).addClass('ui-state-active');
                    element.addClass('ui-state-active');
                }
            });
        }
        var moreTabSwitch = window.moreTabSwitch = function(el) {
            el.toggleClass('tab_open');
            el.toggleClass('tab_closed');
        }
    });
</script>

<div class='tabs_alt tabs_parent'>
    <ul id='main_tabs'>
        <?php foreach ($this->tabs as $key => $tab): ?>
            <?php
            $class = array();
            $class[] = 'tab_' . $tab['id'];
            $class[] = 'tab_' . trim(str_replace('generic_layout_container', '', $tab['containerClass']));
            if ($this->activeTab == $tab['id'] || $this->activeTab == $tab['name'])
                $class[] = 'ui-state-active';
//          $class[] = 'active';
            $class = join(' ', $class);
            ?>
            <?php if ($key < $this->max): ?>
                <li class="<?php echo $class ?>"><a href="javascript:void(0);" onclick="tabContainerSwitch($(this), '<?php echo $tab['containerClass'] ?>');"><?php echo $this->translate($tab['title']) ?></a><?php if (!empty($tab['childCount'])): ?><span><?php echo $tab['childCount'] ?></span><?php endif; ?></li>
            <?php endif; ?>
        <?php endforeach; ?>
        <?php if (count($this->tabs) > $this->max): ?>
            <li class="tab_closed more_tab" onclick="moreTabSwitch($(this));">
                <div class="tab_pulldown_contents_wrapper">
                    <div class="tab_pulldown_contents">
                        <ul>
                            <?php foreach ($this->tabs as $key => $tab): ?>
                                <?php 
                                $class = array();
                                $class[] = 'tab_' . $tab['id'];
                                $class[] = 'tab_' . trim(str_replace('generic_layout_container', '', $tab['containerClass']));
                                if ($this->activeTab == $tab['id'] || $this->activeTab == $tab['name'])
                                    $class[] = 'active';
                                $class = join(' ', array_filter($class));
                                ?>
        <?php if ($key >= $this->max): ?>
                                    <li class="<?php echo $class ?>" onclick="tabContainerSwitch($(this), '<?php echo $tab['containerClass'] ?>')"><?php echo $this->translate($tab['title']) ?><?php if (!empty($tab['childCount'])): ?>
                                            <span> (<?php echo $tab['childCount'] ?>)</span><?php endif; ?></li>
                                <?php endif; ?>
    <?php endforeach; ?>
                        </ul>
                    </div>
                </div>
                <a href="javascript:void(0);"><?php echo $this->translate('More +') ?><span></span></a>
            </li>
<?php endif; ?>
    </ul>
</div>

<?php echo $this->childrenContent ?>