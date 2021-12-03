const simpleGit = require("simple-git");
const fs = require("fs");

const git = simpleGit();
const package = JSON.parse(fs.readFileSync("package.json"));

module.exports = async function () {
  return {
    branch: await git.revparse(["--abbrev-ref", "HEAD"]),
    commit: await git.revparse(["--short", "--verify", "HEAD"]),
    repository: package.repository.url
      .replace("git+https://", "")
      .replace("github.com/", "github:")
      .replace(".git", ""),
    repositoryURL: package.repository.url
      .replace("git+", "")
      .replace(".git", ""),
  };
};
