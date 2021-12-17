if (process.env.REPRODUCIBLE_BUILD == "1") {
  // git data makes a build unreproducible, so it is not available
  return;
}

const simpleGit = require("simple-git");
const git = simpleGit();

module.exports = async function () {
  return {
    branch: await git.revparse(["--abbrev-ref", "HEAD"]),
    commit: {
      short: await git.revparse(["--short", "--verify", "HEAD"]),
      long: await git.revparse(["--verify", "HEAD"]),
    },
  };
};
