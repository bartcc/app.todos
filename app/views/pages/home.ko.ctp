
<div class="tests index">
	<h2><?php __('Tests');?></h2>
	
    <div id="fullNameView" class="start startbody">The name is <span data-bind="text: fullName"></span></div>

    <div id="formView">
        <form data-bind="submit: addItem">
        New item:
        <input data-bind='value: itemToAdd, valueUpdate: "afterkeydown"' />
        <input data-bind='value: getModus, valueUpdate: "afterkeydown"' />
        <fieldset>
            <button type="submit" data-bind="enable: itemToAdd().length > 0">Add</button>
            <button type="submit" data-bind="enable: multiSelectedOptionValues().length > 0">Duplicate</button>
            <button id="loader" type="submit" onclick="myApp.loadSystems(); return false;">Load</button>
        </fieldset>
        <p>Your items:</p>
        <select multiple="multiple" width="50" data-bind="options: items, selectedOptions: multiSelectedOptionValues"> </select>
    </form>
    </div>
    <div id="templateView" data-bind='template: "personTemplate"'> </div>

</div>


<script id='personTemplate' type='text/html'>
    ${ name } is ${ age } years old
    <button data-bind='click: makeOlder'>Make older</button>
</script>


