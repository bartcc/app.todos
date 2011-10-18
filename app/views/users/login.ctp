<div style="" id="login">
  <div id="messenger" class="dialogue-wrap transparent">
    <div class="dialogue">
      <div id="morph_messenger-wrap" class="morph dialogue-content" style="width:525px; min-width:500px;">
        <div id="draggable-messenger-wrap" class="bg verticaltop">
          <header>
            <fieldset class="right">
              <button class="_close light window input">x</button>
            </fieldset>
          </header>
          <div class="dialogue-inner-wrap">
            <div class="drag-handle">
              <div>
                <h1>Login</h1>
                <p class="flash"><span>
                    Enter Username and Password
                  </span></p>
              </div>
              <div class="clearfix"></div>
            </div>
            <div class="dialogue-scroll">
              <fieldset>
                <div class="left">
                  <label>User</label>
                  <?php echo $form->input('username', array('label' => false, 'autofocus' => 'autofocus')); ?>
                </div>
                <div class="left">
                  <label>Password</label>
                  <?php echo $form->input('password', array('label' => false)); ?>
                </div>
              </fieldset>
            </div>
          </div>
          <footer>
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


