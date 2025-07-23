import from mtllm.llm { Model }


glob llm = Model(model_name="gpt-4.1-nano", verbose=False);


"""Write a python script to satisfy the user's request"""
def create_python_script(user_request: str) -> File byllm();


walker UpdateFile {
    can update_file with File entry {
        with open(here.file_name, 'w') as f  {
            f.write(here.file_content);
        }
    }
}


node File {
    has file_name: str;
    has file_content: str;
}


with entry {
    print("Welcome to Jac Pilot");
    user_request = input("Please write what you want done : ");
    print(user_request);
    file = create_python_script(user_request);
    UpdateFile() spawn file;
}
