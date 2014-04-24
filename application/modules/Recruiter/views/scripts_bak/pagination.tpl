<style type="text/css">
.paging-home-library{
    text-align: right;
    margin: 3px;
}
.paging-home-library span {
    margin: 1px;
}
</style>
<script type="text/javascript">
	
        function ajaxPaginagation(page)
        {  
        
        $('library_loading').style.display= 'block';
        jQuery.post
                    ('<?php echo $this->baseUrl() . '/recruiter/job/news-job' ?>',
                    { 
                        page : page
                       
                    },
                    function (data){                       
                        jQuery('#ajax_job').html(data);
                    }
                    );
        }    
</script>
<div id="library_loading" style="display: none;">
  <img src='application/modules/Core/externals/images/loading.gif' style='float:left;margin-right: 5px;' />
  <?php echo $this->translate("Loading ...") ?>
</div>
<div class="paging-home-library">
 <?php if ($this->pageCount): ?>  
   <!-- Previous page link -->
  <?php if (isset($this->previous)): ?>
  
    <span>
    <a href="javascript:void(0);" onclick="javascript:ajaxPaginagation( '<?php echo $this->previous; ?>')">
      <?php echo $this->translate('Prev'); ?>
    </a>
    </span> 
        
  <?php endif; ?>       
  <!-- Numbered page links -->
  <?php foreach ($this->pagesInRange as $page): ?>
    <?php if ($page != $this->current): ?> 
      <span>
      <a href="javascript:void(0);" onclick="javascript:ajaxPaginagation( '<?php echo $page; ?>')">
          <?php echo $page; ?>
      </a>
      </span> 
    <?php else: ?> 
      <span class="current"><?php echo $page; ?></span>
    <?php endif; ?>
   <?php endforeach; ?>
  <!-- Next page link -->
  <?php if (isset($this->next)): ?>
  
    <span>
    <a href="javascript:void(0);" onclick="javascript:ajaxPaginagation('<?php echo $this->next; ?>')">
    <?php echo $this->translate('Next'); ?>
     </a>
    </span>
    
  <?php endif; ?>
  <?php endif; ?>
</div>