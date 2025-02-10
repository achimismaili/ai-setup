import os
os.environ["TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD"] = "1"

import torch  # Now PyTorch will respect the setting

import numpy.core.multiarray

# if torch.cuda.is_available():
#     print("✅ CUDA is available!")
#     print("GPU:", torch.cuda.get_device_name(0))
# else:
#     print("❌ CUDA is NOT available.")

cache_dir = os.path.expanduser("~/.cache/suno/bark_v0/")
model_path = os.path.join(cache_dir, "text_2.pt")

if os.path.exists(model_path):
    model = torch.load(model_path, map_location="cuda")
    print("✅ Model loaded successfully!")
else:
    print("❌ Model file not found!")


