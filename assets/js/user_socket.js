// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket } from "phoenix";

const queryParams = new Proxy(new URLSearchParams(window.location.search), {
  get: (searchParams, prop) => searchParams.get(prop),
});

const token = queryParams.token;
const cv_id = queryParams.cv_id;
const vacancy_id = queryParams.vacancy_id;

const renderResponse = (msg) => {
  console.log(msg);
  const messages = document.getElementById("messages");
  const message = document.createElement("div");
  message.innerText = JSON.stringify(msg);
  messages.appendChild(message);
};

// And connect to the path in "lib/cen_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
const socket = new Socket("/api/socket", {
  params: { token: token },
});

socket.onClose((e) => console.log("Closed", e));
socket.connect();

const channel = socket.channel(`chat:${cv_id}:${vacancy_id}`);
channel.join().receive("error", renderResponse);

channel.on("new_message", renderResponse);

document.getElementById("chatInput").addEventListener("keypress", (e) => {
  if (e.key === "Enter") {
    const msg = { text: e.target.value };

    channel
      .push("new_message", msg)
      .receive("ok", () => {
        e.target.value = "";
      })
      .receive("error", renderResponse);
  }
});

export default socket;
