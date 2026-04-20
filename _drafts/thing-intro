The fundamental motivation of this thesis is the poor state of tooling for
phonetics.

Speech recognition has moved entirely away from using phonetic representations
of words as an intermediate step towards recognition, towards ``end-to-end''
systems that predict the text directly; in spite of its limitations,
Whisper [FIXME: cite] is widely considered good enough for many languages,
to the extent that speech recognition is in some sense considered a ``solved
problem''; models such as omni [FIXME: name, cite] can perform speech
recognition of some sort for over 1,600 languages.
[[But it's terrible at some: the Irish it outputs is terrible, and does not
adhere to Irish orthographic conventions, rendering the output almost
useless]]

Speech synthesis, or text to speech, is at a point where most research is
similarly concentrating on ``end to end'' approaches. This, however, is one
area where production use cannot realistically follow research. For TTS
researchers, it is a matter of convenience to not use a text processing
pipeline: these are difficult to develop, require linguistic expertise that
is typically lacking, and are, ultimately, an inconvenient detail that
developers of the TTS engines would rather avoid.

In real use, however, the degree of control required requires some kind of
control over the details of pronunciation that cannot be achieved by
direct prediction from text with current systems, even overlooking that
in many environments there are additional details to the production
pipeline that add additional information that is not present in the text.

The first TTS system in widespread use that allowed synthesis without
phonetisation was Tacotron; it is telling that the most widely used
implementation adapted the system as described to allow the insertion of
strings of phones to re-add this missing level of control.

Although the progress made in terms of technology could reasonably be
expected to map back to phonetics despite the switch to end-to-end, for
the most part any attempts at directly addressing the needs of phonetics
tend to be fundamentally flawed, as engineers without domain knowledge
encode their misconceptions into the tools, rather than consulting with
domain experts: thus we find some limited exploration into the real of
``multilingual phoneme recognition'' models, even though anyone who has
sat through even the first lecture of an introduction to phonetics and
phonology would rightly laugh at the notion of ``multilingual phonemes''.

The realm of speech tooling useful to phoneticians has languished since the
time of WFST-based speech recognition systems, in the form of forced
alignment tools, such as Montreal Forced Aligner and Gentle, but while the
received wisdom among technologists is that these tools are ``good enough'',
the received wisdom among phoneticians is that they are merely better than
nothing, and the amount of error correction required to make their outputs
usable is often so prohibitive as to preclude their use.

