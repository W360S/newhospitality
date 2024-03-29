<div class="pt-content-searching">
    <form id="recruiter_job_search_form" method="post" action="<?php echo $this->form->getAction(); ?>" enctype="application/x-www-form-urlencoded">
        <fieldset>
            <ul>
                <li>
                    <input id="search_job" type="text" name="search_job" title="Sign up for our newsletter" class="input-text required-entry validate-email" value="<?php Zend_Registry::get('Zend_Translate')->_('Enter jobs title, position') ?>" onfocus="javascript:if (this.value == 'Nội dung cần tìm...')
                                this.value = ''" onblur="if (this.value == '')
                                            this.value = '<?php Zend_Registry::get('Zend_Translate')->_('Enter jobs title, position') ?>'"/>
                </li>
                <li>
                    <div class="wd-adap-select">
                        <span class="wd-adap-icon-select"></span>
                        <select name="city_id" id="city_id">
                            <option value="0">All city</option>
                        </select>
                    </div>
                </li>
                <li>
                    <div class="wd-adap-select">
                        <?php echo $this->form->industry;?>
                    </div>
                </li>
                <li>
                    <div class="wd-adap-select">
                        <?php echo $this->form->category;?>
                    </div>
                </li>
                <li class="last">
                    <!--<button type="submit" title="" class="button"><span></span>Tìm kiếm ngay</button>-->
                    <button id="search_book" type="submit" title="" class="button" value="<?php echo $this->translate('Search now'); ?>"><span></span><?php echo $this->translate("Search Now"); ?></button>
                </li>
            </ul>
        </fieldset>
    </form>
</div>
<script type="text/javascript">
    function reset_search() {
        $('recruiter_job_search_form').reset();
        list_city();
    }
    function list_city() {
        var url = "<?php echo $this->baseUrl() . '/resumes/index/city' ?>";
        //var country_id= $('country_id').get('value');
        var temp_country_id = country_id = 230;
        if (country_id == 0) {
            //country_id=1;
        }
        var city_id = $('city_id').get('value');

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
                    var st = "<option value='0'>" + "<?php echo $this->translate('All city') ?>" + "</option>";
                    jQuery('#city_id').prepend(st);
                }
            }
        }).send();
    }
    window.addEvent('domready', function() {

        var defaultVal = jQuery('#search_job').val();
        jQuery('#search_job').focus(function() {
            if (jQuery('#search_job').val() == defaultVal) {
                jQuery('#search_job').val('');
            }
        }).blur(function() {
            if (jQuery.trim(jQuery('#search_job').val()) == '') {
                jQuery('#search_job').val(defaultVal);
            }
        });
        //choose location default(vietnam=230)

        list_city();
    });
</script>
