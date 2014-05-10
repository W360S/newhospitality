<style>
    .filter .input select {
        float: left !important;
    }
    .search_library .filter .input label {
        float: left !important;
    }
    .search_my_question {
        border: 0px !important;
    }
</style>
<script type="text/javascript">
    window.addEvent('domready', function() {
        var input_text = "<?php echo Zend_Controller_Front::getInstance()->getRequest()->text; ?>";

        if (input_text.length > 0) {
            $('text').set('value', input_text);
        }

        jQuery('#search_book').click(function() {
            jQuery('#search_text_form').submit();
        });
    });
</script>

<div class="pt-content-searching">
    <form method="get" action="<?php echo $this->url(); ?>/" id="search_text_form" accept-charset="utf-8">
        <fieldset>
            <ul>
                <li>
                    <input id="text" type="text" name="text" title="Sign up for our newsletter" class="input-text required-entry validate-email" value="Nội dung cần tìm..." onfocus="javascript:if (this.value == 'Nội dung cần tìm...')
                                this.value = ''" onblur="if (this.value == '')
                                            this.value = 'Nội dung cần tìm...'"/>
                </li>
                <li>
                    <div class="wd-adap-select">
                        <span class="wd-adap-icon-select"></span>
                        <?php
                        $view = Zend_Controller_Front::getInstance()->getRequest()->view;
                        $order = Zend_Controller_Front::getInstance()->getRequest()->order;
                        ?>
                        <select name="order" id="order">
                            <option <?php if ($order == 'starttime ASC') echo "selected='selected'"; ?> value="starttime ASC" label="<?php echo $this->translate("Start Time"); ?>"><?php echo $this->translate("Start Time"); ?></option>
                            <option <?php if ($order == 'creation_date DESC') echo "selected='selected'"; ?> value="creation_date DESC" label="<?php echo $this->translate("Recently Created"); ?>"><?php echo $this->translate("Recently Created"); ?></option>
                            <option <?php if ($order == 'member_count DESC') echo "selected='selected'"; ?> value="member_count DESC" label="<?php echo $this->translate("Most Popular"); ?>"><?php echo $this->translate("Most Popular"); ?></option>
                        </select>
                    </div>
                </li>
                <li>
                    <div class="wd-adap-select">
                        <span class="wd-adap-icon-select"></span>
                        <select name="view" id="view">
                            <option <?php if ($view == 'everyone') echo "selected='selected'"; ?> value="everyone" label="<?php echo $this->translate("Everyone's Events:"); ?>"><?php echo $this->translate("Everyone's Events:"); ?></option>
                            <option <?php if ($view == 'friends') echo "selected='selected'"; ?> value="friends" label="<?php echo $this->translate("Only My Friends' Events"); ?>"><?php echo $this->translate("Only My Friends' Events"); ?></option>
                        </select>
                    </div>
                    <input type="hidden" name="category_id" id="search-category" value="<?php echo $this->category_id ?>" />
                </li>
                <li class="last">
                    <button id="search_book" type="submit" title="" class="button" value="<?php echo $this->translate("Search"); ?>"><span></span><?php echo $this->translate("Search Now"); ?></button>
                </li>
            </ul>
        </fieldset>
    </form>

</div>
<style>
    .wd-adap-text-select{
        display:none;
    }
</style>
<script type="text/javascript">
    function submitenter(myfield, e)
    {
        var keycode;
        if (window.event)
            keycode = window.event.keyCode;
        else if (e)
            keycode = e.which;
        else
            return true;

        if (keycode == 13) {
            jQuery('#search_text_form').submit();
            return false;
        } else {
            return true;
        }
    }
</script>
