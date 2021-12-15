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
        `${data.path}/terminal.css/dist`,
        `${data.path}/normalize.css`,
      ],
      outputStyle: "compressed",
    });

    return result.css;
  }
};
