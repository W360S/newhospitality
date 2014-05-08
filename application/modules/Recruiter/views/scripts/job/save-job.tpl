<script type="text/javascript">
    en4.core.runonce.add(function() {
        $$('th.admin_table_short input[type=checkbox]').addEvent('click', function() {
            $$('input[type=checkbox]').set('checked', $(this).get('checked', false));
        })
    });

    var delectSelected = function() {
        var checkboxes = $$('input[type=checkbox]');
        var selecteditems = [];

        checkboxes.each(function(item, index) {
            var checked = item.get('checked', false);
            var value = item.get('value', false);
            if (checked == true && value != 'on') {
                selecteditems.push(value);
            }
        });

        $('ids').value = selecteditems;
        $('delete_selected').submit();
    }
</script>
<?php
$paginator = $this->paginator;
$viewer_id = $this->viewer_id;
?>
<div class="job_main_manage">
    <div class="bt-loading-detele pt-fix-title">
        <a class="pt-loading" href="<?php echo $this->baseUrl() . '/recruiter/job/save-job' ?>"></a>
        <a class="pt-detele" href="javascript:void(0)" onclick="javascript:delectSelected();"></a>
    </div>
    <?php if (count($paginator)): ?>
        <div class="pt-list-table">
            <table cellspacing="0" cellpadding="0">
                <thead>
                    <tr>
                        <th><input type='checkbox' class='checkbox' /></th>
                        <th><strong><?php echo $this->translate("Position") ?></strong></th>
                        <th><strong><?php echo $this->translate("Company") ?></strong></th>
                        <th style="width:100px"><strong><?php echo $this->translate("Date Saved") ?></strong></th>
                        <th style="width:100px"><strong><?php echo $this->translate("Status") ?></strong></th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $i = 0;
                    foreach ($paginator as $item):
                        $i++;
                        if ($i % 2 == 0) {
                            $class = "odd";
                        } else {
                            $class = "";
                        }
                        ?>
                        <tr class="<?php echo $class ?>">
                            <td><input type='checkbox' value="<?php echo $item->job_id ?>"/></td>
                            <td>
                                <?php $slug = Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position); ?>
                                <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug' => $slug), $item->position, array('target' => '_blank')) ?>
                            </td>
                            <td><?php echo $this->company($item->user_id)->company_name; ?></td>
                            <td><?php echo date('d F Y', strtotime($this->saveJob($item->job_id, $viewer_id)->date_saved)); ?></td>
                            <td>
                                <?php
                                $status = $this->saveJob($item->job_id, $viewer_id)->status;
                                if ($status == 0) {
                                    ?>
                                    <a class="button" target="_blank" href="<?php echo $this->baseUrl() . '/recruiter/job/apply-job/job_id/' . $item->job_id ?>" ><?php echo $this->translate('Apply'); ?></a>
                                    <?php
                                } else {
                                    echo $this->translate('Applied') . '<br>';
                                    echo '(' . date('d F Y', strtotime($this->saveJob($item->job_id, $viewer_id)->date_saved)) . ')';
                                }
                                ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
        <br />
        <form id='delete_selected' method='post' action='<?php echo $this->url(array('action' => 'deleteselected')) ?>'>
            <input type="hidden" id="ids" name="ids" value=""/>
        </form>
        <br/>
    <?php else: ?>
        <div style="margin-top: 5px; margin-left: 5px;" class="tip">
            <span>
                <?php echo $this->translate("There are no jobs saved.") ?>
            </span>
        </div>
    <?php endif; ?>
</div>
<?php if (count($paginator) > 0) { ?>
    <div>
        <?php echo $this->paginationControl($paginator); ?>
    </div>

<?php } ?>
