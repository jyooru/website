const { readFileSync } = require("fs");

exports.data = {
  layout: "page",
  title: "keys",
  permalink: "/keys",
};

exports.render = function (data) {
  const gpg = readFileSync("./keys/gpg", "utf8");
  const ssh = readFileSync("./keys/ssh", "utf8");

  return `<h2>gpg</h2>
  <pre><code>curl https://joel.tokyo/keys/gpg | gpg --import</code></pre>
  <pre><code>${gpg}</code></pre>

  <h2>ssh</h2>
  <pre><code>curl https://joel.tokyo/keys/ssh | ~/.ssh/authorized_keys</code></pre>
  <pre><code>${ssh}</code></pre>
  `;
};
