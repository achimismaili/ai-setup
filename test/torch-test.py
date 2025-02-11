# This script checks, if torch can be loaded and if it has CUDA (GPU) support.
import os

# this 'weights only setting' seems not to be required in older versions of torch,
#  and not helping in newer versions :D
# os.environ["TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD"] = "1"

# if torch is not available in the environment, provide error message:
try:
    # torch 2.1 does not work with python 3.12 anymore, touch 2.6 causes too many issues with bark, so I selected 2.2.2
    import torch  # Now PyTorch will respect the setting
except ImportError:
    print("PyTorch is not installed. Please do not forget to activate a virtual environment, if aplicable, e.g. run:")
    print('source "/home/$(whoami)/ai/python-pip-venv/bin/activate"')
    exit(1)

# import numpy.core.multiarray

# print torch version
print("PyTorch version:", torch.__version__)

if torch.cuda.is_available():
    print("✅ CUDA is available!")
    print("GPU:", torch.cuda.get_device_name(0))
else:
    print("❌ CUDA is NOT available.")

cache_dir = os.path.expanduser("~/.cache/suno/bark_v0/")
model_path = os.path.join(cache_dir, "text_2.pt")

if os.path.exists(model_path):
    model = torch.load(model_path, map_location="cuda")
    print("✅ Model loaded successfully!")
else:
    print("❌ Model file not found!")


