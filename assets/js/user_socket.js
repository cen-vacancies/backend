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

// And connect to the path in "lib/cen_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/api/websocket/chats", {
  params: { token: token },
});

socket.connect();

let channel = socket.channel(`chat:${cv_id}:${vacancy_id}`);
channel
  .join()
  .receive("ok", (resp) => {
    console.log("Joined successfully", resp);
  })
  .receive("error", (resp) => {
    console.log("Unable to join", resp);
  });

let addMessage = (msg) => {
  console.log(msg);
  let messages = document.getElementById("messages");
  let message = document.createElement("div");
  message.innerText = JSON.stringify(msg);
  messages.appendChild(message);
};
channel.on("new_message", addMessage);

document.getElementById("chatInput").addEventListener("keypress", (e) => {
  if (e.key === "Enter") {
    const msg = { text: e.target.value };

    channel
      .push("new_message", msg)
      .receive("ok", (resp) => {
        console.log(resp);
        e.target.value = "";
      })
      .receive("error", (resp) => {
        console.log(resp);
      });
  }
});

export default socket;
