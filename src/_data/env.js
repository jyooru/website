module.exports = function () {
  return {
    nodePath: process.env.hasOwnProperty("NODE_PATH")
      ? process.env.NODE_PATH
      : "node_modules",
    reproducibleBuild: process.env.REPRODUCIBLE_BUILD == "1",
  };
};
