import os

from dotenv import load_dotenv


def read_env_variable(env_variable_name: str) -> str:
    """
    Convenience function to get an environment variable from `config.env`

    # Arguments:
    - `env_variable_name`: The name of the environment variable name you're trying to acces. Must match the case/spelling in `config.env` exactly.

    # Returns:
    The string value of the variable

    Raises an exception if the variable cannot be found
    """

    load_dotenv("config.env")
    variable = os.getenv(env_variable_name)

    if variable is None:
        raise Exception(f"Environment variable {env_variable_name} not found")

    return variable
