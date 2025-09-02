import from graph_types { ProjectNode, BaseNode, Defines, FileNode }
import from mtllm.llm { Model }
import re;


glob llm = Model(model_name="openai/gpt-4o", verbose=False);


def generate_keywords(request: str) -> list[str] byllm();


sem generate_keywords= "# generate a list of keywords based on the request to find a file in a python codebase. Regex is allowed. Dont suggest random keywords. Only suggest keywords that would appear in codebase like variable names, function names, class names, etc.";


obj SearchAgent {
    has project: ProjectNode;

    def start(request: str) {
        keywords = generate_keywords(request=request);
        results = self.search(keywords=keywords);
        filtered_results = self.filter_with_atleast_one_keyword(results=results);
        relevant_files = self.relevant_files(file_paths=filtered_results.keys());
        return relevant_files;
    }

    def relevant_files(file_paths: list[str]) {
        files = [self.project->:Defines :->( ` ? FileNode ) ];
        relevant_files = [];
        for file in files {
            if str(file.path.resolve()) in file_paths {
                relevant_files.append(file);
            }
        }
        return relevant_files;
    }

    def search(keywords: str[]) {
        files = [self.project->:Defines :->( ` ? FileNode ) ];
        results: dict[str, dict[str, int]] = {};
        for file in files {
            filePath = str(file.path.resolve());
            if (results.get(filePath) is None) {
                results[filePath] = {};
            }
            for keyword in keywords {
                keywordResults = re.findall(keyword, file.text);
                results[filePath][keyword] = len(keywordResults);
            }
        }
        return results;
    }

    def filter_with_atleast_one_keyword(results: dict[str, dict[str, int]]) {
        filtered_results = {};
        for filePath in results.keys() {
            if (any(results[filePath].values())) {
                filtered_results[filePath] = results[filePath];
            }
        }
        return filtered_results;
    }
}
