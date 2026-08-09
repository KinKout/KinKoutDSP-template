# ui folder
___
#### This is a place to save all the user interface code.
___

*[This folder][link_ui] contains `MainComponent.h/cpp`, the only file included by `source/PluginEditor.h/cpp` as the root component to manage the UI.*
___

It is divided into 3 subfolders:

- **components** - *for aggregated UI elements like knobs, buttons, meters, etc.*
    *for example, the [source/ui/components/knob][link_knob] folder contains the `KnobComponent.h/cpp`, the only class visible by the `source/ui/MainComponent.h/cpp`, the internal objects of the knob itself instead are placed in the `source/ui/components/knob/internal` folder. (e.g. `KnobBody.h`, `KnobLookAndFeel.h`, `KnobShadow.h`)*

- **shared-parts** - *for shared components like labels, shadows, ticks, etc.*
- **style** - *for the global look and feel or aspects of the plugin UI*



[link_ui]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/ui
[link_knob]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/ui/components/knob