let projectsColor = document.querySelectorAll('.project-item-color');


  projectsColor.forEach(element => {
      let color = element.getAttribute('color');
      element.style.background = color;
  });