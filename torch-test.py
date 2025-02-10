import os
import torch
import numpy.core.multiarray

# if torch.cuda.is_available():
#     print("✅ CUDA is available!")
#     print("GPU:", torch.cuda.get_device_name(0))
# else:
#     print("❌ CUDA is NOT available.")

# torch.serialization.add_safe_globals([numpy.core.multiarray.scalar])

cache_dir = os.path.expanduser("~/.cache/suno/bark_v0/")
model_path = os.path.join(cache_dir, "text_2.pt")

if os.path.exists(model_path):
    model = torch.load(model_path, map_location="cuda", weights_only=False)
    print("✅ Model loaded successfully!")
else:
    print("❌ Model file not found!")
