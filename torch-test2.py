import os
# torch 2.1 does not work with python 3.12 anymore, touch 2.6 causes too many issues, so I selected 2.2.2
import torch  

cache_dir = os.path.expanduser("~/.cache/suno/bark_v0/")
model_path = os.path.join(cache_dir, "text_2.pt")

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