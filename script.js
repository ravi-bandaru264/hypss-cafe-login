const DEMO_USERNAME = "admin";
const DEMO_PASSWORD = "cafe123";

const form = document.getElementById("loginForm");
const usernameInput = document.getElementById("username");
const passwordInput = document.getElementById("password");
const message = document.getElementById("message");
const loginPanel = document.getElementById("loginPanel");
const dashboard = document.getElementById("dashboard");
const loggedUser = document.getElementById("loggedUser");

// Restore a remembered username for this browser, if requested earlier.
const remembered = localStorage.getItem("hypssCafeUsername");
if (remembered) {
  usernameInput.value = remembered;
  document.getElementById("rememberMe").checked = true;
}

document.getElementById("togglePassword").addEventListener("click", () => {
  const isHidden = passwordInput.type === "password";
  passwordInput.type = isHidden ? "text" : "password";
  document.getElementById("togglePassword").textContent = isHidden ? "◌" : "◉";
  document.getElementById("togglePassword").setAttribute("aria-label", isHidden ? "Hide password" : "Show password");
});

document.getElementById("forgotPassword").addEventListener("click", () => {
  alert("For this demo, please contact the cafe administrator to reset your password.");
});

form.addEventListener("submit", (event) => {
  event.preventDefault();
  const username = usernameInput.value.trim();
  const password = passwordInput.value;

  if (username === DEMO_USERNAME && password === DEMO_PASSWORD) {
    if (document.getElementById("rememberMe").checked) {
      localStorage.setItem("hypssCafeUsername", username);
    } else {
      localStorage.removeItem("hypssCafeUsername");
    }
    message.textContent = "Login successful! Welcome to Hypss-Cafe.";
    message.classList.add("success");
    loggedUser.textContent = username;
    setTimeout(() => {
      loginPanel.hidden = true;
      document.querySelector(".cafe-panel").hidden = true;
      document.querySelector(".page-shell").hidden = true;
      dashboard.hidden = false;
    }, 450);
  } else {
    message.textContent = "Incorrect username or password. Please try again.";
    message.classList.remove("success");
    passwordInput.focus();
  }
});

document.getElementById("logoutButton").addEventListener("click", () => {
  dashboard.hidden = true;
  document.querySelector(".page-shell").hidden = false;
  document.querySelector(".cafe-panel").hidden = false;
  loginPanel.hidden = false;
  form.reset();
  message.textContent = "You have logged out.";
  message.classList.remove("success");
  if (localStorage.getItem("hypssCafeUsername")) {
    usernameInput.value = localStorage.getItem("hypssCafeUsername");
    document.getElementById("rememberMe").checked = true;
  }
});
