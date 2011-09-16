<div class="galleries form">
<?php echo $this->Form->create('Gallery');?>
	<fieldset>
 		<legend><?php __('Add Gallery'); ?></legend>
	<?php
		echo $this->Form->input('name');
		echo $this->Form->input('author');
		echo $this->Form->input('description');
		echo $this->Form->input('Album');
	?>
	</fieldset>
<?php echo $this->Form->end(__('Submit', true));?>
</div>
<div class="actions">
	<h3><?php __('Actions'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('List Galleries', true), array('action' => 'index'));?></li>
		<li><?php echo $this->Html->link(__('List Albums', true), array('controller' => 'albums', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('New Album', true), array('controller' => 'albums', 'action' => 'add')); ?> </li>
	</ul>
</div>