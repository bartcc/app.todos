<div class="tests form">
<?php echo $this->Form->create('Test');?>
	<fieldset>
 		<legend><?php __('Add Test'); ?></legend>
	<?php
		echo $this->Form->input('name');
	?>
	</fieldset>
<?php echo $this->Form->end(__('Submit', true));?>
</div>
<div class="actions">
	<h3><?php __('Actions'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('List Tests', true), array('action' => 'index'));?></li>
	</ul>
</div>