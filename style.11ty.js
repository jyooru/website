const util = require("util");
const sass = require("sass");
const renderSass = util.promisify(sass.render);

const inputFile = "assets/sass/style.scss";
const outputFile = "assets/style.css";

module.exports = class {
  data() {
    return {
      permalink: outputFile,
      eleventyExcludeFromCollections: true,
    };
  }
  async render() {
    const result = await renderSass({
      file: inputFile,
      includePaths: ["node_modules/terminal.css/dist"],
      outputStyle: "compressed",
    });

    return result.css;
  }
};