//integration button
let plugin = document.querySelector('#plugin');
let integr = document.querySelector('.integration');
let toggle = false;
integr.style.display = "none";

plugin.addEventListener('click', ()=>{
  if (toggle) integr.style.display = "none";
  else integr.style.display = "flex";
  toggle = !toggle;
});