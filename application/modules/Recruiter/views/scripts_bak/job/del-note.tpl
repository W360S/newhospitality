<table>
    <tr>
        <th style="width: 150px;"><?php echo $this->translate('Created Date')?></th>
        <th><?php echo $this->translate('Note')?></th>
        <th></th>
    </tr>
    
    <?php
    if(!empty($this->notes)){
        foreach($this->notes as $note){?>
        <tr>
            <td><?php echo date('d F Y', strtotime($note->creation_date)) ?></td>
            <td><?php echo $note->description;?></td>
            <td><a class="smoothbox" href="javascript:void(0);" onclick="delete_note('<?php echo $note->note_id ?>');"></a></td>
        </tr>
        <?php }
    }
    ?>
</table>