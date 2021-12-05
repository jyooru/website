const { readFileSync } = require("fs");

exports.data = {
  layout: "page",
  title: "keys",
};

exports.render = function (data) {
  const gpg = readFileSync("./src/keys/gpg", "utf8");
  const ssh = readFileSync("./src/keys/ssh", "utf8");

  return `<h2>gpg</h2>
  <pre><code class="hljs">curl https://joel.tokyo/keys/gpg | gpg --import</code></pre>
  <pre><code class="hljs">${gpg}</code></pre>

  <h2>ssh</h2>
  <pre><code class="hljs">curl https://joel.tokyo/keys/ssh | ~/.ssh/authorized_keys</code></pre>
  <pre><code class="hljs">${ssh}</code></pre>
  `;
};
