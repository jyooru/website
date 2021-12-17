module.exports = function () {
  return {
    nodePath: process.env.NODE_PATH,
    nodePathSet: JSON.parse(process.env.NODE_PATH_SET),
    reproducibleBuild: process.env.REPRODUCIBLE_BUILD == "1",
  };
};
