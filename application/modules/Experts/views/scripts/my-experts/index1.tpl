<style> 
    div, td {
        color:#555555;
        font-size: 12px;
    }
    .subsection {
        -moz-border-radius:3px 3px 3px 3px;
        background-color:#E9F4FA;
        border:1px solid #D0E2EC;
        margin-bottom:10px;
        margin-top: 0px;
    }
    .list_my_questions table th {
        padding:12px 8px;
    }
</style>
<div class="section">
    <div class="layout_right">
        <div class="subsection">
            <div class="bt_function_question">
                <a class="create" href="<?php echo $this->baseUrl('/').'experts/my-questions/compose/'; ?>">Create New Question</a>
                <a class="my_question" href="<?php echo $this->baseUrl('/').'experts/my-questions/index/status/1/'; ?>">My Questions</a>
            </div>
        </div>
        <div class="subsection">
            <?php
                $data = $this->data; 
                echo $this->content()->renderWidget('experts.featured-experts');
            ?>
        </div>
        <div class="subsection">
            <?php echo $this->content()->renderWidget('group.ad'); ?>
        </div>
    </div>
    <div class="layout_middle">
        <div class="layout_middle_question">
			<div class="search_my_question">
				<?php echo $this->content()->renderWidget('experts.search'); ?>
            </div>	
			<div class="list_my_questions">
                
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr align="left" style="height: 20px; background-color: #F2FAFF;">
                      <th style="width:15%"><?php echo $this->translate("Expert") ?></th>
                      <th style="width:40%"><?php echo $this->translate("Categories") ?></th>
                      <th style="width:15%"><?php echo $this->translate("Pending count") ?></th>
                      <th style="width:15%"><?php echo $this->translate("Question count") ?></th>
                      <th style="width:15%"><?php echo $this->translate("Action") ?></th>
                    </tr>
                    <?php if(count($data)): ?>
                    <?php $cnt = 1; foreach($data as $value): ?>
                    <tr align="center" class="<?php if($cnt%2 != 0) echo "background_gray"; ?>">
						<td  >
                            <?php echo $value['object']->name; ?>
                        </td>
						<td >
                            <?php if(count($value['cat'])): ?>
                            <?php foreach($value['cat'] as $item): ?>
                            <?php echo $item->category_name; ?><br />
                            <?php endforeach; ?>
                            <?php endif; ?>
                        </td>
                        <td><?php echo intval($value['cnt_pending']); ?></td>
						<td><?php echo $value['object']->cnt_question;?></td>
                        <td>
                            <?php echo $this->htmlLink($this->baseUrl("/")."experts/my-experts/manage/expert_id/".$value['object']->expert_id, $this->translate('Manage'), array()) ?>
                        </td>
					</tr>
                    <?php $cnt++; endforeach; ?>
                    <?php else: ?>
                    <tr class="container_func">
                        <td colspan="5">
							<p><strong><?php echo "You haven't any experts"; ?></strong></p>						
                        </td>
					</tr>
                    <?php endif; ?>
                </table>
            </div>
		</div>
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
