import from mtllm.llm { Model }
import from python_parser { PythonParser }
import from search_agent { SearchAgent }
import from rich.console { Console as RichConsole }
import from rich.text { Text as RichText }
import pyfiglet;
import from rich.prompt { Prompt, Confirm }
import from time { sleep }
import from genius_agent { GeniusAgent, File }


with entry {
    console = RichConsole();
    fig = pyfiglet.figlet_format("JACPILOT");
    # Wrap it with Rich text + color
    styled_text =
        RichText(fig, style="#ff6b35");
    console.print("Welcome to", style="bold white");
    console.print(styled_text);
    console.print("🚀", style="#ff6b35");
    pythonParser = PythonParser();
    with console.status("Wait Scanning codebase ") as consoleStatus  {
        # ui flow
        project_node =
            pythonParser.start();
    }
    search_agent = SearchAgent(project=project_node);
    #  test
    search_agent.start(
        request="find the files where fibonacci is implemented"
    );
    prompt = Prompt.ask("[#ff6b35]Please enter what you need done [/]");
    genius_agent = GeniusAgent();
    with console.status("Breaking down task ") as consoleStatus  {
        tasks = genius_agent.breakdown_task(prompt=prompt);
    }
    for task in tasks {
        with console.status("Searching for files ") as consoleStatus  {
            files = search_agent.start(request=task);
            files =
                [ File(file_content=file.text, file_path=str(file.path.resolve())) for file in files ];
        }
        with console.status("Updating files ") as consoleStatus  {
            files = genius_agent.update_files(task=task, existings_files=files);
        }
        for file in files {
            with open(file.file_path, 'w') as wfile  {
                wfile.write(file.file_content);
            }
        }
    }
}


# update fibonacci method to generate upto 10

