const render = require("./render");

module.exports = class {
  data() {
    return {
      permalink: "assets/fonts/fira-code-nerd-font-regular.woff2",
    };
  }

  render = render.createFunction("Fira Code", "Regular");
};
