module.exports = function () {
  return {
    nodePath: process.env.NODE_PATH,
    nodeModules: JSON.parse(process.env.NODE_MODULES),
  };
};
