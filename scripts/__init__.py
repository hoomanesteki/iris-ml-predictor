import importlib.util
from pathlib import Path


def _load(module_filename, module_name):
    module_path = Path(__file__).parent / module_filename
    spec = importlib.util.spec_from_file_location(module_name, module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


#expose what we want to test

_validation = _load("02validation_splitting.py", "validation_splitting")
split_data = _validation.split_data
