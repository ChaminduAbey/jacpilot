with entry {
    print("Welcome to Jac Pilot");
    while True {
        user_request = input("Please write what you want done : ");
        if (user_request.lower() == "exit") {
            break;
        }
        print("To exit please type : exit");
    }
}
