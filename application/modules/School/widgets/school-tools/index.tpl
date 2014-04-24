<div class="subsection">
    <h2><?php echo $this->translate("Manage Articles Tools");?></h2>
    <div class="subcontent">
		<ul class="jobs_management">
			<li style="border-bottom: 1px solid #E6E6E6"><a href="<?php echo $this->baseUrl().'/school/article/at-status/st/approve' ?>"><?php echo $this->translate('Approved Articles')?> (<?php echo $this->article_approved ?>)</a></li>
    
            <li style="border-bottom: 1px solid #E6E6E6"><a href="<?php echo $this->baseUrl().'/school/article/at-status/st/pending'?>"><?php echo $this->translate('Pending Articles')?> (<?php echo $this->article_pending ?>)</a></li>
            <li><a href="<?php echo $this->baseUrl().'/school/article/at-status/st/reject'?>"><?php echo $this->translate('Cancelled Articles')?> (<?php echo $this->article_reject ?>)</a></li>
    
		</ul>
		
    </div>
</div> 