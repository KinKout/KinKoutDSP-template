# dsp folder
___
#### This is a place to save all the audio processing code.
___

*[This folder][link_dsp] contains `KKDsp.h`, the only file included by `source/engine/Engine.h/cpp` as the root file to enable or disable parts of the DSP layer.*

*All DSP categories are managed with a `CategoryName.h` file in their own root folder. That act like an umbrella header for all the classes that contains that category, in a similar way of JUCE structure.*
___

It is divided into 9 subfolders categories structured to contain the following effects:

- **amplitude** - *amplitudes and their ratios:*
    - gain
    - pan
    - balance
    - stereo width
    - mono
    - polarity
    - dry/wet
    - crossfade
- **analysis** - *measurements without any processing:*
    - FFT
    - RMS/peak
    - pitch detection
- **distortion** - *non-linear effects:*
    - waveshaper
    - saturation
    - clipping
    - bitcrusher
- **dynamics** - *gain control and detection:*
    - compressor
    - limiter
    - gate
    - expander
    - envelope follower
- **filters** - *shapes the frequency response:*
    - biquad
    - SVF
    - EQ
    - cross-over
- **generators** - *generate signals:*
    - oscillators
    - noise
- **modulation** - *control signals:*
    - LFO
    - modulation envelope
    - modulation matrices
- **time** - *time-domain effects:*
    - delay
    - reverb
    - chorus
    - flanger
    - phaser
    - pitch-shifter
- **utility** - *generic services:*
    - envelope follower
    - smoothers
    - interpolators
    - oversampling
    - dithers




[link_dsp]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/dsp