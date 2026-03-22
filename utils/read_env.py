import os

from dotenv import dotenv_values
from dotenv import load_dotenv

ENV_FILE = "config.env"


def read_env_variable(env_variable_name: str) -> str:
    """
    Convenience function to get an environment variable from `config.env`

    # Arguments:
    - `env_variable_name`: The name of the environment variable name you're trying to acces. Must match the case/spelling in `config.env` exactly.

    # Returns:
    The string value of the variable

    Raises an exception if the variable cannot be found
    """

    load_dotenv(ENV_FILE)
    variable = os.getenv(env_variable_name)

    if variable is None:
        raise Exception(f"Environment variable {env_variable_name} not found")

    return variable


def get_all_topics() -> list[str]:
    all_env_variables = dotenv_values(ENV_FILE)
    topics = []

    for key, value in all_env_variables.items():
        if "topic" in key.lower():
            topics.append(value)

    return topics
