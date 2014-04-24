<style type="text/css">
#global_wrapper{background: none;}
</style>
<?php
    $paginator= $this->paginator; 
    $category_id= $this->category_id;
    
?>
<div id="content">
    <div class="section recruiter">
    <div class="layout_right">
        <?php echo $this->content()->renderWidget('recruiter.sub-menu');?>
        <?php echo $this->content()->renderWidget('recruiter.manage-recruiter');?>
        <?php echo $this->content()->renderWidget('resumes.suggest-resume');?>
        <!-- insert some advertising -->
        <?php include 'ads/right-column-ads.php'; ?>
    </div>
        <div class="layout_middle">
    
            <div class="recruiter_main">
                
                <?php echo $this->content()->renderWidget('recruiter.search-resumes');?>
                <div id="breadcrumb">
                    <div class="section">
                        <a href="<?php echo $this->baseUrl();?>"><?php echo $this->translate("Home");?></a> <span>&gt;</span> <a href="<?php echo $this->baseUrl().'/recruiter'?>"><?php echo $this->translate("Recruiter");?></a> <span>&gt;</span> <strong><?php echo $this->category($category_id)->name;?></strong>
                    </div>
                </div>
                <div class="subsection">
                <?php if( count($paginator)>0 ): ?>
               
                <ul class="list_questions">
                	<?php $cnt = 1; foreach($paginator as $item): ?>
                    <li>
                		<div class="list_number">
                			<?php echo $cnt; ?>
                		</div>
                		<div class="content_questions">
                			<?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($item->title);?>
                            <h3><a class="list_resume_category" href="<?php echo $this->baseUrl().'/resumes/resume/view/resume_id/'.$item->resume_id.'/'.$slug ?>"><?php echo $item->title;?></a></h3>
                
                            <p><?php echo $this->user($item->user_id)?></p>
                        </div>
                	</li>
                <?php $cnt = $cnt + 1; endforeach; ?>
                </ul>
                
                <?php else: ?>
                <div style="margin-top: 5px; margin-left: 5px;" class="tip">
                    <span>
                      <?php echo $this->translate("Haven't resumes in this category.") ?>
                    </span>
                </div>
                
                <?php endif; ?>
            </div>
            <?php  if(count($paginator)>0 ){
                echo $this->paginationControl($paginator);
                }
            ?>
            </div>
                 
            </div>
        </div>
    </div>
</div>
