let copyTextareaBtn = document.querySelector('#copy_button');

copyTextareaBtn.addEventListener('click', function(event) {
  let copyTextarea = document.querySelector('#to_copy');
  copyTextarea.select();

  try {
    var successful = document.execCommand('copy');
    var msg = successful ? 'successful' : 'unsuccessful';
    console.log('Copying text command was ' + msg);
  } catch (err) {
    console.log('Oops, unable to copy');
  }
});
