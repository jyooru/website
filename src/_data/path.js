module.exports = function () {
  return process.env.hasOwnProperty("NODE_PATH")
    ? process.env.NODE_PATH
    : "node_modules";
};
