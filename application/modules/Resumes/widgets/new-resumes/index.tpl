
<?php if(count($this->paginator)){?>
<div class="subsection">
    <h2><?php echo $this->translate("New Resumes");?></h2>
    <div id="new_resume">
    <div class="resume-group">
    
    <ul class="articles_jobs">
    <?php 
        $i=0;
        foreach($this->paginator as $paginator){
            $i++;
        ?>
        <li>
            <?php $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($paginator->title);?>
            <?php echo $this->itemPhoto($this->user($paginator->user_id), "thumb.icon");?>
            <div class="link_jobs"><a href="<?php echo $this->baseUrl().'/resumes/resume/view/resume_id/'.$paginator->resume_id.'/'.$slug ?>"><?php echo $paginator->title;?></a>
            
            <p class="new_resume"><?php echo $this->user($paginator->user_id)?></p>
            </div>
        </li>
    <?php } ?>
    <?php if($i%5==0 || $i==$this->paginator->count()){?>
        </ul>
    <?php }?>
    </div>
    <?php 
    if( $this->paginator->count() > 1 ): 
    ?>
    <div class="paging">
        <?php echo $this->paginationControl($this->paginator, null, "application/modules/Resumes/views/scripts/pagination.tpl"); ?>
    </div>
    <?php endif; ?>
    </div>
    
</div>
<?php } ?>