// const Cache = require("@11ty/eleventy-cache-assets");
// var ttf2woff2 = require("ttf2woff2");

// exports.data = {
//   pagination: { data: "fontStyles", size: 1 },
//   fontStyles: ["Regular", "A", "b"],
// };

// exports.render = function (data) {
//   return data.pagination.items.join("");
// };

const generate = require("./generate");

module.exports = class {
  data() {
    return {
      permalink: "assets/fonts/regular.woff2",
    };
  }

  render() {
    return generate.generate("Regular");
  }
};
