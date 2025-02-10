from bark import generation

text = "Hallo! Ich bin dein KI-Avatar. Wie kann ich helfen?"
audio = generation(text, speaker="de")
with open("speech.wav", "wb") as f:
    f.write(audio)
