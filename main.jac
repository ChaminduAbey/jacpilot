import from mtllm.llm { Model }
import from python_parser { PythonParser }
import from search_agent { SearchAgent }


with entry {
    pythonParser = PythonParser();
    project_node = pythonParser.start();
    search_agent = SearchAgent(project=project_node);
    search_agent.search(["fibonacci"]);
}
