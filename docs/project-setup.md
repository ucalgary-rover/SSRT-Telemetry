# Set up the SSRT Telemetry environment for development

## Clone this repository

In your WSL environemnt, pick a location to clone this repo. Then navigate into the directory

```bash
mkdir Your/Desired/Directory
cd Your/Desired/Directory/
git clone https://github.com/ucalgary-rover/SSRT-Telemetry
cd SSRT-Telemetry
```

## Create a virtual environment

Install venv
```bash
sudo apt install python3-venv
```

Create the virtual environment
```bash
python3 -m venv ./.venv
```

Activate the virtual environment
```bash
source ./.venv/bin/activate
```
Your terminal should now look like this:
```bash
(.venv) danijourdain@Dani-Vivobook:~/SSRT/SSRT-Telemetry
```

From this point forward, **all commands** should only be run in the virtual environment in the SSRT-Telemetry directory

## Install and configure `pre-commit hooks`
Pre commit hooks are used for consistent code styling across developers, and to ensure only clean code is committed to a repository.

Install pre-commit
```bash
pip install pre-commit
```

Set up the git hook scripts
```bash
pre-commit install
```

Ensure it has been installed correctly
```bash
pre-commit run --all-files
```
The output should look like this assuming you haven't changed any files
```
check yaml...............................................................Passed
fix end of files.........................................................Passed
trim trailing whitespace.................................................Passed
check python ast.....................................(no files to check)Skipped
check docstring is first.............................(no files to check)Skipped
check for merge conflicts................................................Passed
mixed line ending........................................................Passed
check json...........................................(no files to check)Skipped
pretty format json...................................(no files to check)Skipped
Reorder python imports...............................(no files to check)Skipped
autoflake............................................(no files to check)Skipped
black................................................(no files to check)Skipped
```

### How to develop with pre-commit hooks
There are two main workflows with pre-commit hooks

1. Try to commit your code and fix changes until the code is accepted
2. Run `pre-commit run --all-files` before committing and fix changes before attempting to commit.

## Install Streamlit using pip

Install Streamlit
```bash
pip install streamlit
```

Verify Streamlit installed correctly
```bash
streamlit hello
```
The output should look like this, with slightly different addresses
```bash
Welcome to Streamlit. Check out our demo in your browser.

  Local URL: http://localhost:8501
  Network URL: http://172.30.220.39:8501

  Ready to create your own Python apps super quickly?
  Head over to https://docs.streamlit.io

  May you create awesome apps!
```

Open the URL in your browser to explore the sample app.

## Install the rest of the requirements for the project

```bash
pip install -r requirements.txt
```

## Notes

Please make sure that you are always developing in your virtual environment. If you're ever unsure, run `which python` and ensure the path points to your virtual environment.

If you need new dependencies, please make sure they are added to `requirements.txt` and pushed to GitHub so all members are aware.

Please **DO NOT** push your virtual environment to GitHub. It should be ignored by the `.gitignore` file but if it is not, please make sure it does not get pushed to GitHub.
