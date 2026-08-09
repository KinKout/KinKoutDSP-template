# source folder
___
#### [This folder][link_source] contains all the source code of the plugin
___

It is divided into 5 subfolders:

- **assets-helper** - for code that loads assets *(wraps audio, data, fonts, images etc.)*
- **core** - for cross-thread codes like constants, math, helpers, shared state, lock-free FIFOs between audio and UI.
- **dsp** - for audio processing code divided into 9 subfolders
    - amplitude, analysis, distortion, dynamics, filters, generators, modulation, time, utility. *(see [dsp/README.md][link_dsp_readme])*.
- **engine** - composition root, the single place where is wired DSP, APVTS and states.
    - this folder contains `Engine.h/cpp`, `State.h/cpp` and `Parameters.h/cpp`, the only classes visible by the `PluginProcessor.h/cpp`
- **ui** - for user interface code divided into 3 subfolders
    - components, shared-parts, style. *(see [ui/README.md][link_ui_readme])*
    - this folder contains `MainComponent.h/cpp`, the only class visible by the `PluginEditor.h/cpp`


!!! Note: `Engine.h/cpp`, `State.h/cpp`, `Parameters.h/cpp` and `MainComponent.h/cpp` are parts of the future structure codes, not already implemented.




[link_source]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source
[link_dsp_readme]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/dsp/README.md
[link_ui_readme]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/ui/README.md