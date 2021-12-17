const util = require("util");
const sass = require("sass");
const renderSass = util.promisify(sass.render);

const inputFile = "src/assets/sass/style.scss";
const outputFile = "assets/style.css";

module.exports = class {
  data() {
    return {
      permalink: outputFile,
      eleventyExcludeFromCollections: true,
    };
  }
  async render(data) {
    const result = await renderSass({
      file: inputFile,
      includePaths: [
        `${data.env.nodePathSet["terminal.css"]}/terminal.css/dist`,
        `${data.env.nodePathSet["normalize.css"]}/normalize.css`,
      ],
      outputStyle: "compressed",
    });

    return result.css;
  }
};
