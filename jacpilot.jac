import from mtllm.llm { Model }
import from pathlib { Path }


glob llm = Model(model_name="ollama/huihui_ai/phi4-mini-abliterated", verbose=True);


"""Write a python script to satisfy the user's request. You will receive existing scripts. Return back with changes done. You can add or delete files by simply including/excluding them to the return list"""
def create_python_script(
    user_request: str,
    existings_files: list[FileNode]
) -> list[FileNode] byllm();


def create_python_script2(user_request: str) -> str byllm();


walker UpdateFile {
    can update_file with FileNode entry {
        file_path = here.file_name;
        if file_path.startswith("/") {
            file_path = file_path[ 1 : ];
        }
        print(file_path);
        if not file_path.startswith("workplace") {
            file_path = "workplace/" + file_path;
        }
        with open(file_path, 'w') as file  {
            file.write(here.file_content);
        }
    }
}


obj FileFinder {
    def find_all_python_files()  -> list[FileNode] {
        files = [];
        project_root = Path("./workplace/");
        python_files = list(project_root.rglob("*.py"));
        for file_path in python_files {
            files.append(self.read_file_content(file_path));
        }
        return files;
    }

    def read_file_content(file_path: str) -> FileNode {
        with open(file_path, 'r', encoding='utf-8') as file  {
            # Read the entire content of the file
            file_content =
                file.read();
            return FileNode(file_name=file_path, file_content=file_content);
        }
    }
}


node FileNode {
    has file_name: str;
    has file_content: str;
}


node ProjectNode {}


with entry {
    print("Welcome to Jac Pilot");
    while True {
        files = FileFinder().find_all_python_files();
        user_request = input("Please write what you want done : ");
        if (user_request.lower() == "exit") {
            break;
        }
        updated_files =
            create_python_script(user_request=user_request, existings_files=files);
        print(files);
        print(updated_files);
        for file in updated_files {
            UpdateFile() spawn file;
        }
        print("To exit please type : exit");
    }
}
