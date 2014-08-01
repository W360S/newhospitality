<?php  $request = Zend_Controller_Front::getInstance()->getRequest(); ?>
<script type="text/javascript">
	
        function ajaxPaginagation(page)
        {  
            var cat_id= "<?php echo $request->getParam('cat_id'); ?>";
            var keyword= "<?php echo $request->getParam('keyword');?>";
            var order= "<?php echo $request->getParam('order');?>";
            $('library_loading_book').style.display= 'block';
            new Request({
                url: '<?php echo $this->baseUrl() . '/library/index/ajax-book' ?>',
                method: "post",
                data : {
                		page : page, 
                        cat_id: cat_id,
                        keyword: keyword,
                        order: order
                	},
                onSuccess : function(responseHTML)
                {
                    $('ajax_book').set('html', responseHTML);;
                    
                		
                }
            }).send();
            
        }    
</script>

<div class="paging-home-library">

<?php if ($this->pageCount): ?> 
 
   <!-- Previous page link -->
  <?php if (isset($this->previous)): ?>
    <span>
    <a href="javascript:void(0);" onclick="javascript:ajaxPaginagation( '<?php echo $this->previous; ?>')">
      <?php echo $this->translate('&laquo;  Previous'); ?>
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
    <?php echo $this->translate('Next &raquo;'); ?>
     </a>
    </span>
  <?php endif; ?>
  
<?php endif; ?>

</div>