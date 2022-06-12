import json
from pathlib import Path
from shutil import move
from typing import Any, Union

import frontmatter


def main() -> None:
    with open("data/projects.json") as file:
        projects_data = json.load(file)
    path = Path.cwd() / "content/projects"
    
    for project in path.iterdir():
        if not project.is_dir():
            continue

        index_created = False
        for index_path in map(
            lambda x: project / f"{x}.md", ["README", "_index", "index"]
        ):
            index = index_path
            if index_path.exists():
                break
        if not index.exists():
            index_created = True
            index.touch()

        project_data = projects_data.get(project.name, {})
        data = frontmatter.load(index)

        data["title"] = data.get("title", project.name)
        data["description"] = data.get("description", project_data.get("description", ""))
        data["extra"] = data.get("extra", {})
        for key, value in project_data.get("extra", {}).items():
            data["extra"][key] = data["extra"].get(key, value)

        if index_created:
            data["extra"]["href"] = f"https://github.com/jyooru/{project.name}"

        if index_path.name == "README.md":
            if data.content.startswith("# "):
                data.content = "\n".join(data.content.splitlines()[1:])

        frontmatter.dump(data, index)

        if index_path.name == "README.md":
            move(index_path, index_path.parent / "index.md")


if __name__ == "__main__":
    main()
