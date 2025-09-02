## JAC Pilot

An interactive, LLM-powered code assistant built with the Jac language. JAC Pilot scans your Python workspace, breaks down natural-language tasks, locates relevant files, and proposes direct edits to implement your request.

### Key Features
- **Interactive CLI**: Type a natural-language task and let the agent do the rest.
- **Codebase scanning**: Parses your Python project into a graph for precise file discovery.
- **Targeted search**: Generates focused keywords and finds relevant files programmatically.
- **Automated edits**: Proposes and applies file updates on disk.
- **Examples included**: Simple math utilities in `workplace/` (Fibonacci, primes, triangular numbers).

## Project Layout
- `main.jac`: Rich UI entrypoint; scans the codebase, uses `SearchAgent` and `GeniusAgent` to break down tasks and update files.
- `search_agent.jac`: Implements request-to-keywords, file scoring, and relevant file selection.
- `genius_agent.jac`: Declares LLM-driven methods for task breakdown and file updates.
- `workplace/`: Example Python scripts and a simple `main.py`.

## Prerequisites
- Python 3.11+ (3.12 recommended)
- A working `pip`/virtual environment
- The `jac` CLI (provided by `jaclang` in requirements)
- For LLM features: set `OPENAI_API_KEY` if using the default OpenAI-backed models

## Setup
```bash
# 1) Create and activate a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# 2) Install dependencies
pip install -r requirements.txt

# 3) (Optional) Configure your LLM credentials
export OPENAI_API_KEY="your_api_key_here"
```

## Running
```bash
jac run main.jac
```
What it does:
- Shows a styled banner
- Parses your Python codebase
- Uses `SearchAgent` to locate relevant files
- Uses `GeniusAgent` to propose edits and writes them back to disk

## Usage
When prompted, type what you want done in natural language, for example:
- "Update the Fibonacci generator to go up to 1000."
- "Create a script that prints the first 20 prime numbers."
- "Add a function to compute triangular numbers and use it in main."

Edits are written directly to disk. In the minimal flow, paths are constrained to the `workplace/` directory.

## Notes and Tips
- If the `jac` command is not found, ensure `jaclang` is installed (it is pinned in `requirements.txt`) and your virtualenv is active.
- LLM model names are defined in the Jac files (e.g., OpenAI `gpt-4o`); you may change them to suit your provider/setup.
- Example scripts live in `workplace/`. Run or import them as you like. The sample `workplace/main.py` prints a Fibonacci sequence.

## License
This project is licensed under the terms of the license in `LICENSE.txt`.


