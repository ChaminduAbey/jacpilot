import from search_agent { SearchAgent }
import from mtllm.llm { Model }


glob llm = Model(model_name="openai/gpt-4o", verbose=False);


obj File {
    has file_content: str;
    has file_path: str;
}


obj GeniusAgent {
    def generate_task_for_search_agent(prompt: str) -> list[str] byllm();
    def breakdown_task(prompt: str) -> list[str] byllm();
    def update_files(task: str, existings_files: list[File]) -> list[File] byllm();
}


sem GeniusAgent. breakdown_task= """Break down the task into seperate tasks if needed. Make sure each task is only one sentence long. Dont mention GeniusAgent in the tasks IMPORTANT: Generate multiple tasks only if the file related to the task would be different. Most of the time, just one task is enough.
Wrong Ex:
1. Review the existing Fibonacci method implementation in the GeniusAgent class.
2. Modify the Fibonacci method to generate numbers up to 10.
Reasons for wrong:
Both tasks are basically looking for the fibonacci. Here just one task is enough. Also dont mention GeniusAgent in the tasks.

""";


sem GeniusAgent. generate_tasks_for_search_agent= """generate tasks for the search agent to complete.  Make sure these tasks are only relevant for finding the necessary python files. Dont include any other tasks. Dont repeat the same task in a different way please. Dont generate too many tasks. Correct Ex: 1. Find the files where fibonacci is implemented.
Wrong Ex:
1. Search for Python files with a function named 'fibonacci'
2. Find the source file with Fibonacci sequence generation.
Reasons for wrong:
Both tasks are basically looking for the fibonacci.
Wrong Ex2:
1. Locate the Python file where the Fibonacci sequence is implemented in GeniusAgent class.
2. Identify the Python file that contains the Fibonacci sequence generation code.
Reasons for wrong:
Both tasks are basically looking for the fibonacci. Just one task is enough.
Also dont mention GeniusAgent in the tasks.

IMPORTANT: Generate multiple tasks only if the file related to the task would be different. Most of the time, just one task is enough.
""";


sem GeniusAgent. update_files= """Write a python script to satisfy the user's request. You will receive existing scripts. Return back with changes done. You can add or delete files by simply including/excluding them to the return list""";
