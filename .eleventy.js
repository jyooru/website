const fs = require("fs");
const htmlmin = require("html-minifier");
const path = require("path");

module.exports = function (eleventyConfig) {
  eleventyConfig.setBrowserSyncConfig({
    callbacks: {
      ready: function (err, bs) {
        bs.addMiddleware("*", (req, res) => {
          // enable 404 page for eleventy --serve
          const content_404 = fs.readFileSync("_site/404.html");
          res.writeHead(404, { "Content-Type": "text/html; charset=UTF-8" });
          res.write(content_404);
          res.end();
        });
      },
    },
  });

  eleventyConfig.addWatchTarget("./assets/sass/");

  eleventyConfig.addShortcode("now", function () {
    now = new Date().toISOString();
    date = now.split("T")[0];
    time = now.split("T")[1].split(".")[0];
    return date + " " + time;
  });

  eleventyConfig.addFilter("get_extension", function (string) {
    return string.split(".").pop();
  });
  eleventyConfig.addFilter("remove_extension", function (string) {
    let parsed = path.parse(string);
    return path.join(parsed.dir, parsed.name);
  });
  eleventyConfig.addFilter("reverse", function (string) {
    return string.split("").reverse().join("");
  });

  eleventyConfig.addTransform("htmlmin", function (content, outputPath) {
    if (outputPath && outputPath.endsWith(".html")) {
      let minified = htmlmin.minify(content, {
        useShortDoctype: true,
        removeComments: true,
        collapseWhitespace: true,
      });
      return minified;
    }
    return content;
  });
};
