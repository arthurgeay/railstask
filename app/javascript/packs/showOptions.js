if (document.querySelector('body').contains(document.querySelector('.options'))) {
    
  let options = document.querySelectorAll('.options');
  for (let i = 0; i < options.length; i++) {
    let container = document.createElement('div');
    let edit = document.createElement('a');
    let del = document.createElement('a');
    
    edit.textContent = "Éditer";
    edit.href = options[i].parentElement.getAttribute('data-edit');
    edit.setAttribute("rel","nofollow");
    del.textContent = "Supprimer";
    del.href = options[i].parentElement.getAttribute('data-delete');
    del.setAttribute("rel","nofollow");
    del.setAttribute("data-method","delete");
    container.classList.add('window');
    container.classList.add('hide');
    
    container.appendChild(edit);
    container.appendChild(del);
    options[i].parentElement.appendChild(container);
  }
  
  for (let y = 0; y < options.length; y++) {
    options[y].addEventListener('click', () => {
      if (document.querySelectorAll('.window')[y].classList.contains('hide'))  document.querySelectorAll('.window')[y].classList.remove('hide');
      else document.querySelectorAll('.window')[y].classList.add('hide');
    })
  }


}