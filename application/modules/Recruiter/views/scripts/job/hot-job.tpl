<div id="ajax_hot_job">
<?php 
    if( $this->paginator->getTotalItemCount() ): 
?>
<ul class="jobs_management">
    <?php foreach ($this->paginator as $item): ?>
    <li>
        <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->position);?>
        <?php echo $this->htmlLink(array('route' => 'view-job', 'id' => $item->job_id, 'slug'=>$slug), $item->position) ?>
        <div>
             <p><?php echo $this->company($item->user_id)->company_name;?></p>
        				<p>
                            <?php echo $this->city($item->city_id)->name?> - <?php echo $this->country($item->country_id)->name;?>,
                            <?php echo $this->translate('Salary: ')?><?php echo $item->salary;?><br />
                            <?php echo $this->translate('Date Posted: ')?><?php echo date('d F Y', strtotime($item->creation_date));?> 
                       
                       </p>
            

        </div>
    </li>
    <?php endforeach; ?>
</ul>
<?php 
    if( $this->paginator->count() > 1 ): 
?>
<div class="paging">
    <?php echo $this->paginationControl($this->paginator, null, "application/modules/Recruiter/views/scripts/hot_pagination.tpl"); ?>
</div>
<?php endif; ?>
<?php endif; ?>
</div>
