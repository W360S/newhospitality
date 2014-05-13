<div class="pt-content-searching">
    <form id="recruiter_job_search_form" method="post" action="<?php echo $this->form->getAction();?>" enctype="application/x-www-form-urlencoded">
        <fieldset>
            <ul>
                <li>
                    <input id="search_job" type="text" name="search_job" title="Sign up for our newsletter" class="input-text required-entry validate-email" value="Nội dung cần tìm..." onfocus="javascript:if(this.value=='Nội dung cần tìm...') this.value=''" onblur="if(this.value=='') this.value='Nội dung cần tìm...'"/>
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
                        <?php echo $this->form->level;?>
                    </div>
                </li>
                <li class="last">
                    <!--<button type="submit" title="" class="button"><span></span>Tìm kiếm ngay</button>-->
                    <button id="search_book" type="submit" title="" class="button" value="<?php echo $this->translate('Search now');?>"><span></span><?php echo $this->translate("Search Now"); ?></button>
                </li>
            </ul>
        </fieldset>
    </form>
</div>
<?php /*
<div id="recruiter_search">
    <div id="jobs-search">
        <div class="section">
            <form id="recruiter_search_resume_form" method="post" action="<?php echo $this->form->getAction(); ?>" enctype="application/x-www-form-urlencoded">

                <fieldset>
                    <div class="input">
                        <?php echo $this->form->search_resume; ?>
                    </div>
                    <div class="input">
                        <?php //echo $this->form->country_id;?>
                        <?php echo $this->form->city_id; ?>
                    </div>
                    <div class="input">
                        <?php echo $this->form->level; ?>
                        <?php //echo $this->form->degree;?>
                        <?php echo $this->form->industry; ?>
                    </div>
                    <div class="input">
                        <?php //echo $this->form->language;?>

                    </div>

                    <div class="submit">
                        <input type="submit" value="<?php echo $this->translate('Find Candidates') ?>" />
                        <!--<input type="reset" onclick="reset_search();" value="<?php //echo $this->translate('Reset') ?>" class="min" />-->
                    </div>
                </fieldset>
            </form>
        </div>
    </div>
</div>
*/ ?>
<script type="text/javascript">
    function reset_search() {
        $('recruiter_search_resume_form').reset();
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

        var defaultVal = jQuery('#search_resume').val();
        jQuery('#search_resume').focus(function() {
            if (jQuery('#search_resume').val() == defaultVal) {
                jQuery('#search_resume').val('');
            }
        }).blur(function() {
            if (jQuery.trim(jQuery('#search_resume').val()) == '') {
                jQuery('#search_resume').val(defaultVal);
            }
        });
        list_city();
    });
</script>