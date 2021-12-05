const { readFileSync } = require("fs");

exports.data = {
  layout: "pagejs",
  title: "License",
};

exports.render = function (data) {
  return `<pre>${readFileSync("./LICENSE", "utf8")}</pre>`;
};
