/*
*
* File:     PluginEditor.h
* Date:     08-Aug-2026
*
* Plugin:   MyNewPlugin
*
*/


#pragma once

#include "PluginProcessor.h"


//==============================================================================
class MyNewPluginAudioProcessorEditor  : public juce::AudioProcessorEditor
{
public:
    MyNewPluginAudioProcessorEditor (MyNewPluginAudioProcessor&);
    ~MyNewPluginAudioProcessorEditor() override;

    //==============================================================================
    void paint (juce::Graphics&) override;
    void resized() override;

private:
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    MyNewPluginAudioProcessor& audioProcessor;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (MyNewPluginAudioProcessorEditor)
};
