<div class="tests form">
<?php echo $this->Form->create('Test');?>
	<fieldset>
 		<legend><?php __('Edit Test'); ?></legend>
	<?php
		echo $this->Form->input('id');
		echo $this->Form->input('name');
	?>
	</fieldset>
<?php echo $this->Form->end(__('Submit', true));?>
</div>
<div class="actions">
	<h3><?php __('Actions'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('Delete', true), array('action' => 'delete', $this->Form->value('Test.id')), null, sprintf(__('Are you sure you want to delete # %s?', true), $this->Form->value('Test.id'))); ?></li>
		<li><?php echo $this->Html->link(__('List Tests', true), array('action' => 'index'));?></li>
	</ul>
</div>