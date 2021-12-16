const { AssetCache } = require("@11ty/eleventy-cache-assets");
const fetch = require("node-fetch");
const ttf2woff2 = require("ttf2woff2");

const nerdFontRevision = "v2.1.0";
const nerdFontURL = `https://raw.githubusercontent.com/ryanoasis/nerd-fonts/${nerdFontRevision}/patched-fonts/`;

function getNerdFontStyleURL(font, style) {
  return encodeURI(
    nerdFontURL +
      font.replace(" ", "") +
      `/${style}/complete/${font} ${style} Nerd Font Complete.otf`
  );
}

function convertNerdFontToWoff2(font, style) {
  return fetch(getNerdFontStyleURL(font, style)).then(async (res) => {
    const content = await res.buffer();
    return ttf2woff2(content);
  });
}

module.exports.createFunction = function (font, style) {
  return function render() {
    let cache = new AssetCache(`font-${font}-${style}`);
    if (cache.isCacheValid("2w")) {
      return cache.getCachedValue();
    }

    let asset = convertNerdFontToWoff2(font, style);
    asset.then((result) => {
      cache.save(result);
      return result;
    });
  };
};
