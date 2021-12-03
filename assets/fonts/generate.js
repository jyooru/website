const fetch = require("node-fetch");
const ttf2woff2 = require("ttf2woff2");

const nerdFontRevision = "v2.1.0";
const nerdFontFont = "FiraCode";
const nerdFontURL = `https://raw.githubusercontent.com/ryanoasis/nerd-fonts/${nerdFontRevision}/patched-fonts/${nerdFontFont}/`;

function getNerdFontStyleURL(style) {
  return encodeURI(
    nerdFontURL + `${style}/complete/Fira Code ${style} Nerd Font Complete.otf`
  );
}

module.exports.generate = function generate(style) {
  return fetch(getNerdFontStyleURL(style)).then(async (res) => {
    const content = await res.buffer();
    return ttf2woff2(content);
  });
};
