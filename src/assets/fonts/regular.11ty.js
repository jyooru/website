const { AssetCache } = require("@11ty/eleventy-cache-assets");
const generate = require("./generate");

module.exports = class {
  data() {
    return {
      permalink: "assets/fonts/regular.woff2",
    };
  }

  async render() {
    let cache = new AssetCache("font_regular");
    if (cache.isCacheValid("2w")) {
      return cache.getCachedValue();
    }

    let asset = generate.generate("Regular");
    asset.then((result) => {
      cache.save(result);
      return result;
    });
  }
};
