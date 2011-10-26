<div style="" id="login">
  <div id="messenger" class="dialogue-wrap">
    <div class="dialogue">
      <?php echo $form->create('User', array('onsubmit' => 'Login.submit(); return false;')); ?>
      <div class="dialogue-content" style="width:525px; min-width:500px;">
        <div class="bg">
          <header>
            <fieldset class="right">
            </fieldset>
          </header>
          <div class="dialogue-inner-wrap">
            <div class="drag-handle">
                <h1>Login</h1>
                <div class="flash">
                  <h3>Enter Username and Password</h3>
                </div>
              <div class="clearfix"></div>
            </div>
            <div class="dialogue-scroll">
              <fieldset>
                <div class="left">
                  <label>User</label>
                  <?php echo $form->input('username', array('label' => false, 'div' => false, 'autofocus' => 'autofocus')); ?>
                </div>
                <div class="left">
                  <label>Password</label>
                  <?php echo $form->input('password', array('label' => false, 'div' => false)); ?>
                </div>
              </fieldset>
            </div>
          </div>
          <footer>
            <span class="info"><label>no error messages</label></span
            <span>
              <fieldset>
                <?php echo $this->Form->button('Login', array('type'=>'submit', 'class' => 'light')); ?>
              </fieldset>
            </span>
          </footer>
        </div>
      </div>
      </form>
    </div>
  </div>
</div>

<script type="text/x-jquery-tmpl" id="flashTemplate">
  {{if flash}}
  <h3>{{html flash}}</h3>
  {{if success}}
  <img src="/img/ajax-loader-light.gif">
  {{/if}}
  {{/if}}
  {{if error}}
  <h3>Uuups... Error ${xhr.status} ${error}</h3>
  {{/if}}
</script>

<script type="text/x-jquery-tmpl" id="infoTemplate">
  {{if record}}
  <span style="display: block;">Record ${record.name} was not saved !</span>
  {{/if}}
</script>
<!--{json: {flash: ...}} {error: {record: {}, xhr: {}, statusText: {}, error:{}}}-->
