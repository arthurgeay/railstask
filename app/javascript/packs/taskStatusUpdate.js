 // Checkbox 
 const csrfToken = document.querySelector("[name='csrf-token']").content;
 const checkboxTasks = document.querySelectorAll('.task-complete-check');

/**
* Edit task status (In progress or done)
*/
 const editTask = (editTaskRoute, statusValue, target) => {
   fetch(editTaskRoute, {
         method: 'PUT',
         headers: {
           "X-CSRF-Token": csrfToken,
           'Content-type': 'application/json',
         },
         body: JSON.stringify({status: statusValue})
       })
       .then(res => res.json())
       .then(res => {
           const taskContainer = target.parentElement.parentElement.parentElement;
           taskContainer.children[0].innerHTML = res.status;
       })
       .catch(error => console.log(error))
 };

 for(let checkbox of checkboxTasks) {
   checkbox.addEventListener('click', (e) => {
     const editTaskRoute = checkbox.getAttribute('data-edit-task');
     
     if(!checkbox.checked) {
       editTask(editTaskRoute, "In progress", e.target);
     } else {
       editTask(editTaskRoute, "Done", e.target)
     }

   });
 }