<div class="subsection">
    <?php if (count($this->categories)): ?>
        <ul class="pt-list-areas list_category jobs_category">
            <?php if (count($this->categories) < 3) {
                foreach ($this->categories as $item):
                    ?>
                    <li><a href="<?php echo $this->baseUrl() . '/resumes/search/index/category_id/' . $item['occup_id'] ?>"><?php echo $item['name']; ?> <span><?php echo $item['sum']; ?></span></a></li>
                <?php endforeach;
            } else {
                ?>
                <?php
                $i = 0;
                foreach ($this->categories as $item):
                    $i++;
                    ?>
                    <?php if ($i == 1 || ($i % 3 == 1 && $i != 3)) { ?>
            <?php } ?>
                    <li><a href="<?php echo $this->baseUrl() . '/resumes/search/index/category_id/' . $item['occup_id'] ?>"><?php echo $item['name']; ?> <span><?php echo $item['sum']; ?></span></a></li>
                    <?php if ($i % 3 == 0 || (($i % 3 == 1 || $i % 3 == 2) && $i == count($this->categories))) { ?>
                    <?php } ?>
                <?php endforeach; ?>
                <?php if (empty($this->category)) { ?>
                <?php
                }
            }
            ?>
        </ul>
<?php endif; ?>
</div>