# import os
# os.environ["TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD"] = "1"

# if torch is not available in the environment, provide error message:
try:
    # torch 2.1 does not work with python 3.12 anymore, touch 2.6 causes too many issues with bark, so I selected 2.2.2
    import torch 
except ImportError:
    print("PyTorch is not installed. Please do not forget to activate a virtual environment, if aplicable, e.g. run:")
    print('source "/home/$(whoami)/ai/python-pip-venv/bin/activate"')
    exit(1)

import sounddevice as sd
from bark import generate_audio, SAMPLE_RATE
from scipy.io.wavfile import write

# Suppress specific warnings
import warnings
warnings.filterwarnings("ignore", category=UserWarning, module="torch.nn.utils.weight_norm")
warnings.filterwarnings("ignore", category=UserWarning, module="torch.utils._device")

# German voice options
voices = {
    "Default [English]": "v2/en_speaker_0",
    "Female 1 [English]": "v2/en_speaker_9",
    "Male 1 [English]": "v2/en_speaker_1",
    "Male 2 [English]": "v2/en_speaker_2",
    "Male 3 [English]": "v2/en_speaker_6",
    "Frau 1 [Deutsch]": "v2/de_speaker_3", 
    "Mann 1 [Deutsch]": "v2/de_speaker_0",
    "Mann 2 [Deutsch]": "v2/de_speaker_1",
    "Mann 3 [Deutsch]": "v2/de_speaker_2",
    "Mann 4 [Deutsch]": "v2/de_speaker_4",
}

# Show available voices
print("Available German Voices:")
for i, (name, code) in enumerate(voices.items(), 1):
    print(f"{i}. {name}")

# User selects a voice
choice = int(input("\nChoose a voice (1-10): ")) - 1
voice_preset = list(voices.values())[choice]

# User input text
text = input("\nGeben Sie Ihren Text ein: ")

# Detect if GPU is available
device = "cuda" if torch.cuda.is_available() else "cpu"
torch.set_default_device(device)

print(f"Using {device.upper()} for Bark TTS")

print(f"\n🔊 Erstelle Audio für Stimme: {name}")
audio_array = generate_audio(text, history_prompt=voice_preset)

# Play audio
print("\n🔊 Spiele Audio ab...")
sd.play(audio_array, samplerate=SAMPLE_RATE)
sd.wait()

# Alternatively - Save to file
# output_filename = "bark_output.wav"
# write(output_filename, SAMPLE_RATE, audio_array)
# print(f"\n✅ Sprachdatei gespeichert als '{output_filename}'")