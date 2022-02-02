const fs = require("fs");
const htmlmin = require("html-minifier");
const path = require("path");

module.exports = function (eleventyConfig) {
  eleventyConfig.setLiquidOptions({
    dynamicPartials: false, // everything breaks
  });

  eleventyConfig.setBrowserSyncConfig({
    callbacks: {
      ready: function (err, bs) {
        bs.addMiddleware("*", (req, res) => {
          // enable 404 page and trying {url}.html for eleventy --serve
          alternativePath = `dist/${req._parsedOriginalUrl.pathname}.html`;
          var contentPath = "dist/404.html";
          if (fs.existsSync(alternativePath)) {
            contentPath = alternativePath;
          }
          res.writeHead(404, { "Content-Type": "text/html; charset=UTF-8" });
          res.write(fs.readFileSync(contentPath));
          res.end();
        });
      },
    },
  });

  eleventyConfig.addWatchTarget("./src/assets/");

  eleventyConfig.addShortcode("a_blank", function (link, text) {
    return `<a href="${link}" target="_blank" rel="noopener">${text}</a>`;
  });
  eleventyConfig.addShortcode("a_blank_text", function (link) {
    return `<a href="${link}" target="_blank" rel="noopener">${link}</a>`;
  });
  eleventyConfig.addShortcode("comment", function (text) {
    return `<span class="comment">&lt;!-- ${text} --&gt;</span>`;
  });
  eleventyConfig.addShortcode("generate_permalink", function (pageOutPath) {
    return pageOutPath + ".html";
  });
  eleventyConfig.addShortcode(
    "github_repository",
    function (username, repositoryName) {
      return `<a href="https://github.com/${username}/${repositoryName}" target="_blank" rel="noopener">github:${username}/${repositoryName}</a>`;
    }
  );
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

  return { dir: { input: "./src", output: "./dist" } };
};
