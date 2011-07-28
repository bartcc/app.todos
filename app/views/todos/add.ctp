<div class="todos form">
<?php echo $this->Form->create('Todo');?>
	<fieldset>
 		<legend><?php __('Add Todo'); ?></legend>
	<?php
		echo $this->Form->input('isDone');
		echo $this->Form->input('description');
	?>
	</fieldset>
<?php echo $this->Form->end(__('Submit', true));?>
</div>
<div class="actions">
	<h3><?php __('Actions'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('List Todos', true), array('action' => 'index'));?></li>
	</ul>
</div>