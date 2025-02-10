from bark import SAMPLE_RATE, generate_audio
from scipy.io.wavfile import write
import torch
import numpy as np

# Allowlist the necessary globals for loading the model
with torch.serialization.safe_globals([np.core.multiarray.scalar]):
    # Input text
# text = "Hallo! Ich bin dein KI-Avatar. Wie kann ich helfen?"
    text = "Hello! This is a test speech generated using Bark."

    # Generate speech
    audio_array = generate_audio(text)

    # Save to a file
    write("output.wav", SAMPLE_RATE, audio_array)


# audio = generate_audio(text, speaker="de")
# with open("speech.wav", "wb") as f:
#     f.write(audio)

#     # If you want to play the generated audio directly in Python:
#     import sounddevice as sd

    # ##  Play audio
#     sd.play(audio_array, samplerate=24000)
#     sd.wait()