import torch
import sounddevice as sd
from bark import generate_audio, SAMPLE_RATE
from scipy.io.wavfile import write

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
# choice = int(input("\nChoose a voice (1-5): ")) - 1
choice = 0
voice_preset = list(voices.values())[choice]

# Load the Bark model explicitly allowing full state loading
# model = torch.load("text_2.pt", map_location="cpu", weights_only=False)


# User input text
# text = input("\nGeben Sie Ihren Text ein: ")
text = "Dies ist ein Beispieltext, alles sollte idealerweise klappen."

# Detect if GPU is available
device = "cuda" if torch.cuda.is_available() else "cpu"
torch.set_default_device(device)

model = torch.load("/home/ismaili/.cache/suno/bark_v0/text_2.pt", map_location="cuda", weights_only=False)

print(f"Using {device.upper()} for Bark TTS")

# Add error handling for torch.load

# Generate speech
audio_array = generate_audio(text, history_prompt=voice_preset)

# Save to file
# output_filename = "bark_deutsch_output.wav"
# write(output_filename, SAMPLE_RATE, audio_array)
# print(f"\n✅ Sprachdatei gespeichert als '{output_filename}'")

# Play audio
# print("\n🔊 Spiele Audio ab...")
# sd.play(audio_array, samplerate=SAMPLE_RATE)
# sd.wait()
