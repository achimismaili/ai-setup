# This script also can help checking functionality with torch, 
# e.g. with allowing unsave globals in newer torch versions
# I never got a recent torch 2.6 version to work, even when trying to add safe globals
# Then, torch 2.1 does not work with python 3.12 anymore, touch 2.6 causes too many issues with bark, so I selected 2.2.2

import os

# if torch is not available in the environment, provide error message:
try:
    import torch  # Now PyTorch will respect the setting
except ImportError:
    print("PyTorch is not installed. Please do not forget to activate a virtual environment, if aplicable, e.g. run:")
    print('source "/home/$(whoami)/ai/python-pip-venv/bin/activate"')
    exit(1) 

cache_dir = os.path.expanduser("~/.cache/suno/bark_v0/")
model_path = os.path.join(cache_dir, "text_2.pt")

## Section to experiment with adding safe globals ##

# unsafe_globals = torch.serialization.get_unsafe_globals_in_checkpoint(model_path)
# print(f"unsafe globals: {unsafe_globals}")

# allowed_before = torch.serialization.get_safe_globals()
# print(f"allowed before: {allowed_before}")

# # torch.serialization.add_safe_globals(unsafe_globals) 
# # torch.serialization.safe_globals()
# torch.serialization.add_safe_globals([numpy.core.multiarray.scalar])
# # torch.serialization.add_safe_globals([numpy.dtype])

# allowed_after = torch.serialization.get_safe_globals()
# print(f"allowed after: {allowed_after}")

model = torch.load(model_path, map_location="cuda")