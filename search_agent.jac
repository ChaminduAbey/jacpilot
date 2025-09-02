import from graph_types { ProjectNode, BaseNode, Defines, FileNode }
import re;


obj SearchAgent {
    has project: ProjectNode;

    def search(keywords: str[]) {
        files = [self.project->:Defines :->( ` ? FileNode ) ];
        results: dict[str, dict[str, number]] = {};
        for file in files {
            if (not results[file.path]) {
                results[file.path] = {};
            }
            for keyword in keywords {
                results = re.findall(keyword, file.text);
                results[file.path][keyword] = len(results);
                print(results);
            }
        }
        print(results);
    }
}
