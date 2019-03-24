document.addEventListener('DOMContentLoaded', () => {
  // Toogle menu hamburguer
  const burger = document.querySelector('.burger');
  const menu = document.querySelector('#' + burger.dataset.target);
  burger.addEventListener('click', () => {
    burger.classList.toggle('is-active');
    menu.classList.toggle('is-active');
  });

  // Close message
  const closeMessage = document.getElementById('close-message');
  if (closeMessage) {
    closeMessage.addEventListener('click', () => {
      let message = document.getElementById('message');
      if (message) {
        message.style.display = 'none';
      }
    });
  }

  // switch
  const switchInput = document.querySelector('.switch__input');
  switchInput.addEventListener('change', () => {
    let url = '';
    if (switchInput.checked) {
      url = document.querySelector('.switch__left').href;
    } else {
      url = document.querySelector('.switch__right').href;
    }
    // Se agrega este delay para que coincida con la transicion de css de 0.1
    setTimeout(() => {
      window.location = url;
    }, 100);
  });
});
