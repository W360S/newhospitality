<div class="subsection" style="border-top-left-radius:0px;">

    <?php if (count($this->industries)): ?>
        <ul class="pt-list-areas list_category jobs_category">
            <?php if (count($this->industries) < 3) {
                foreach ($this->industries as $item):
                    ?>

                    <li><a href="<?php echo $this->baseUrl() . '/recruiter/search/index/industry_id/' . $item["industry_id"] ?>"><?php echo $item["name"]; ?> (<span><?php echo $item["sum"] ?></span>)</a></li>

                <?php endforeach;
            } else {
                ?>
                <?php
                $i = 0;
                foreach ($this->industries as $item):
                    $i++;
                    ?>

                    <?php if ($i == 1 || ($i % 3 == 1 && $i != 3)) { ?>

            <?php } ?>
                    <li><a href="<?php echo $this->baseUrl() . '/recruiter/search/index/industry_id/' . $item["industry_id"] ?>"><?php echo $item["name"]; ?> <span><?php echo $item["sum"] ?></span></a></li>

                    <?php if ($i % 3 == 0 || (($i % 3 == 1 || $i % 3 == 2) && $i == count($this->industries))) { ?>

                    <?php } ?>


                <?php endforeach; ?>
                <?php
            }
            ?>
        </ul>
    <?php endif; ?>
</div>
