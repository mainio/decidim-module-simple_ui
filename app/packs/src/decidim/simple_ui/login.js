document.addEventListener("DOMContentLoaded", () => {
  const revealButton = document.querySelector(".register__separator");
  if (!revealButton) {
    return;
  }

  const loginForm = document.getElementById("session_new_user");
  const svgIcon = revealButton.querySelector("svg");
  const alert = document.querySelector("header>.container>.flash.alert");

  if (alert) {
    loginForm.classList.toggle("hidden");
    svgIcon.classList.toggle("rotate-180");
  }

  revealButton.addEventListener("click", () => {
    loginForm.classList.toggle("hidden");
    svgIcon.classList.toggle("rotate-180");
  })
});
