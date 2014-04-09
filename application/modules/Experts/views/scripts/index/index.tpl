<div class="section">
    <div class="layout_right">
        <?php
               echo $this->content()->renderWidget('experts.my-accounts'); 
        ?>
        <div class="subsection">
            <?php
               echo $this->content()->renderWidget('experts.featured-experts'); 
            ?>
        </div>
        <div class="subsection">
            <?php echo $this->content()->renderWidget('group.ad'); ?>
        </div>
    </div>
    <div class="layout_middle">
       <div >
			<div class="search_my_question">
				<?php echo $this->content()->renderWidget('experts.search'); ?>
            </div>	
			<div class="subsection">
				<?php echo $this->content()->renderWidget('experts.categories'); ?>
            </div>
            <div class="subsection">
    			<?php echo $this->content()->renderWidget('experts.lasted-questions'); ?>
    		</div>
		</div>
        <div class="block_content">
            <div class="subsection">
				<?php echo $this->content()->renderWidget('experts.top-views'); ?>
            </div>
        </div>
        <div class="block_content top_rating">
            <div class="subsection">
				<?php echo $this->content()->renderWidget('experts.top-rating'); ?>
            </div>
        </div>
		<div class="clear"></div>
    </div>

    <div class="clear"></div>

</div>
