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
});
