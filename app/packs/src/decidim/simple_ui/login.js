$(() => {
  const revealButton = document.querySelector(".register__separator");
  const loginForm = document.getElementById("session_new_user");
  const svgIcon = revealButton.querySelector("svg");

  revealButton.addEventListener("click", () => {
    loginForm.classList.toggle("hidden");
    svgIcon.classList.toggle("rotate-180");
  })
})
