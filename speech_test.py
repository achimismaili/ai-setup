# import os
# os.environ["TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD"] = "1"

import torch  # Now PyTorch will respect the setting
import sounddevice as sd
from bark import generate_audio, SAMPLE_RATE
from scipy.io.wavfile import write

# Suppress specific warnings
import warnings
warnings.filterwarnings("ignore", category=UserWarning, module="torch.nn.utils.weight_norm")
warnings.filterwarnings("ignore", category=UserWarning, module="torch.utils._device")

# German voice options
voices = {
    "German Male 1": "v2/de_speaker_0",
    "German Male 2": "v2/de_speaker_1",
    "German Female 1": "v2/de_speaker_2",
    "German Female 2": "v2/de_speaker_3",
    "German Female 3": "v2/de_speaker_4",
}

# Show available voices
print("Available German Voices:")
for i, (name, code) in enumerate(voices.items(), 1):
    print(f"{i}. {name}")

# User selects a voice
choice = int(input("\nChoose a voice (1-5): ")) - 1
voice_preset = list(voices.values())[choice]

# User input text
text = input("\nGeben Sie Ihren Text ein: ")

# Detect if GPU is available
device = "cuda" if torch.cuda.is_available() else "cpu"
torch.set_default_device(device)

print(f"Using {device.upper()} for Bark TTS")

# Generate speech
audio_array = generate_audio(text, history_prompt=voice_preset)

# Save to file
# output_filename = "bark_deutsch_output.wav"
# write(output_filename, SAMPLE_RATE, audio_array)
# print(f"\n✅ Sprachdatei gespeichert als '{output_filename}'")

# Play audio
print("\n🔊 Spiele Audio ab...")
sd.play(audio_array, samplerate=SAMPLE_RATE)
sd.wait()
