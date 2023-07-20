import SwiftUI
import AVFAudio


@available(iOS 16.0, *)
struct ContentView: View {
    private let synth = AVSpeechSynthesizer()
    private let volume: Float = 0.9
    private let rate: Float = 0.001
    private let voice = AVSpeechSynthesisVoice(language: "fr-FR")

    private let protwords = [
        "squat": "skwat",
        "quadriceps": "kwa.dri.sɛps"
    ]

    private enum simpleText {
        static let basicSquat = "A vous, quart de squat pendant 30 secondes"
        static let basicQuadri = "Etirez votre quadriceps gauche pendant 30 secondes"
    }
    private enum ssmlText {
        static let basicSquat = """
                <speak>
                    A vous, quart de <prosody rate="150%"><phoneme alphabet="ipa" ph="skwat" >squat</phoneme></prosody> pendant 30 secondes
                </speak>
            """
        static let basicQuadri = """
                <speak>
                    Etirez votre <prosody rate="120%"><phoneme alphabet="ipa" ph="/kwa.dri.sɛps/" >quadriceps</phoneme></prosody> gauche pendant <emphasis level="moderate"> 30 secondes </emphasis>
                </speak>
            """
        static let countdown = """
                <speak>
                    <prosody volume="-10dB">
                    3
                    </prosody>
                    <break time="1s" />
                    <prosody volume="+0dB">
                    2
                    </prosody>
                    <break time="1s" />
                    <prosody volume="+10dB">
                    1
                    </prosody>
                </speak>
            """
        static let speed = """
                <speak>
                    <prosody rate="200%">
                        Voici la deuxième partie de l'apprentissage de la position assise.
                    </prosody>
                    <prosody rate="70%">
                        Vous aurez besoin d'une chaise.
                    </prosody>
                    <prosody rate="120%">
                        Regardez la vidéo.
                    </prosody>
                </speak>
            """
        static let duration = """
            <speak>
                <prosody duration="10s">
                    Faites un pas à droite, levez le genou gauche, et changez de côté.
                </prosody>
                <prosody duration="2s">
                    Faites un pas à droite, levez le genou gauche, et changez de côté.
                </prosody>
            </speak>
        """
        static let gender = """
            <speak>
                <voice gender="female">
                    Faites un pas à droite.
                </voice>
                <voice gender="male">
                    Faites un pas à droite.
                </voice>
            </speak>
        """
        static let age = """
            <speak>
                <voice age="6">
                    Faites un pas à droite.
                </voice>
                <voice age="30">
                    Faites un pas à droite !
                </voice>
            </speak>
        """
        static let pitch = """
            <speak>
                <prosody pitch="low">
                    Faites un pas à droite, levez le genou gauche, et changez de côté.
                </prosody>
                <prosody pitch="high">
                    Faites un pas à droite, levez le genou gauche, et changez de côté.
                </prosody>
                <prosody pitch="low">
                    Faites un pas à droite,
                </prosody>
                <prosody pitch="medium">
                    levez le genou gauche
                </prosody>
                <prosody pitch="high">
                    et changez de côté.
                </prosody>
                <prosody pitch="x-low">
                    Faites un pas à droite, levez le genou gauche, et changez de côté.
                </prosody>
                <prosody pitch="x-high">
                    Faites un pas à droite, levez le genou gauche, et changez de côté.
                </prosody>

            </speak>
        """
        static let lang = """
            <speak>
                Il préfère les pâtes
                <lang xml:lang="it-IT">
                    mozarella
                </lang>.
                Appuyer sur le bouton
                <lang xml:lang="en-UK">
                    Start
                </lang> et ensuite vous pouvez commencer.
                <lang xml:lang="en-UK">Ready?</lang>
            </speak>

        """
        static let spell = """
            <speak>
                <say-as interpret-as='telephone'>06 02 56 76 13</say-as>
                <say-as interpret-as="verbatim">abcdefg</say-as>
            </speak>
        """

        static let engTest = """
                <speak>
                    That is a huge bank account!
                    That is a <emphasis level="strong"> huge </emphasis> bank account!
                </speak>
            """
    }

    func currentTTS(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        utterance.volume = self.volume
        self.synth.speak(utterance)
    }

    func attrTTS(text: String) {
        let mutableAttributedString = NSMutableAttributedString(string: text)
        let pronunciationKey = NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute)
        for protword in protwords {
            let range = NSString(string: text).range(of: protword.key)
            mutableAttributedString.setAttributes([pronunciationKey: protword.value], range: range)
        }
        let utterance = AVSpeechUtterance(attributedString: mutableAttributedString)
        utterance.voice = self.voice
        utterance.volume = self.volume
        self.synth.speak(utterance)
    }

    func newTTS(text: String) {
        let utterance = AVSpeechUtterance(ssmlRepresentation: text)!
        utterance.voice = self.voice
        utterance.volume = self.volume
        self.synth.speak(utterance)
    }

    func newTTSEn(text: String) {
        let utterance = AVSpeechUtterance(ssmlRepresentation: text)!
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        self.synth.speak(utterance)
    }

    var okView: some View {
        VStack {
            Text("Tests SSML")
            HStack {
                Spacer()
                Button {
                    newTTS(text: ssmlText.countdown)
                } label: {
                    Text("Countdown")
                }.buttonStyle(SSMLButton())
                Spacer()
                Button {
                    newTTS(text: ssmlText.speed)
                } label: {
                    Text("Speed")
                }.buttonStyle(SSMLButton())
                Spacer()
                Button {
                    newTTS(text: ssmlText.pitch)
                } label: {
                    Text("Pitch")
                }.buttonStyle(SSMLButton())
                Spacer()
            }
        }
    }
    var nokView: some View {
        VStack {
            Text("Failed Tests SSML")
            Group {
                HStack {
                    Spacer()
                    Button {
                        newTTSEn(text: ssmlText.engTest)
                    } label: {
                        Text("Emphasis")
                    }.buttonStyle(SSMLButton())
                    Spacer()
                    Button {
                        newTTS(text: ssmlText.duration)
                    } label: {
                        Text("Duration")
                    }.buttonStyle(SSMLButton())
                    Spacer()
                    Button {
                        newTTS(text: ssmlText.gender)
                    } label: {
                        Text("Gender")
                    }.buttonStyle(SSMLButton())
                    Spacer()
                    Button {
                        newTTS(text: ssmlText.age)
                    } label: {
                        Text("Age")
                    }.buttonStyle(SSMLButton())
                    Spacer()
                }
            }
            Group {
                HStack {
                    Spacer()
                    Button {
                        newTTS(text: ssmlText.lang)
                    } label: {
                        Text("Langue")
                    }.buttonStyle(SSMLButton())
                    Spacer()
                    Button {
                        newTTS(text: ssmlText.spell)
                    } label: {
                        Text("Spell")
                    }.buttonStyle(SSMLButton())
                    Spacer()
                }
            }

        }
    }

    var body: some View {
        VStack {
            Spacer()
            Text("SQUAT")
            HStack {
                Spacer()
                Button {
                    currentTTS(text: simpleText.basicSquat)
                } label: {
                    Text("String")
                }.buttonStyle(StringButton())
                Spacer()
                Button {
                    attrTTS(text: simpleText.basicSquat)
                } label: {
                    Text("Attributed")
                }.buttonStyle(AttrButton())
                Spacer()
                Button {
                    newTTS(text: ssmlText.basicSquat)
                } label: {
                    Text("SSML")
                }.buttonStyle(SSMLButton())
                Spacer()
            }
            Text("QUADRI")
            HStack {
                Spacer()
                Button {
                    currentTTS(text: simpleText.basicQuadri)
                } label: {
                    Text("String")
                }.buttonStyle(StringButton())
                Spacer()
                Button {
                    attrTTS(text: simpleText.basicQuadri)
                } label: {
                    Text("Attributed")
                }.buttonStyle(AttrButton())
                Spacer()
                Button {
                    newTTS(text: ssmlText.basicQuadri)
                } label: {
                    Text("SSML")
                }.buttonStyle(SSMLButton())
                Spacer()
            }
            Spacer()
            okView
            Spacer()
            nokView
        }
    }
}

struct StringButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.indigo)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

struct AttrButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.orange)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

struct SSMLButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.red)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
