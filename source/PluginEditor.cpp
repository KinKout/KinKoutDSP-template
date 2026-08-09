/*
*
* File:     PluginEditor.cpp
* Date:     08-Aug-2026
*
* Plugin:   MyNewPlugin
*
*/


#include "PluginProcessor.h"
#include "PluginEditor.h"


//==============================================================================
MyNewPluginAudioProcessorEditor::MyNewPluginAudioProcessorEditor (MyNewPluginAudioProcessor& p)
    : AudioProcessorEditor (&p), audioProcessor (p)
{
    // Make sure that before the constructor has finished, you've set the
    // editor's size to whatever you need it to be.
    setSize (400, 300);
}

MyNewPluginAudioProcessorEditor::~MyNewPluginAudioProcessorEditor()
= default;

//==============================================================================
void MyNewPluginAudioProcessorEditor::paint (juce::Graphics& g)
{
    // (Our component is opaque, so we must completely fill the background with a solid colour)
    g.fillAll (getLookAndFeel().findColour (juce::ResizableWindow::backgroundColourId));

    g.setColour (juce::Colours::white);
    g.setFont (juce::FontOptions (15.0f));
    g.drawFittedText ("Finalmente funziona!!!", getLocalBounds(), juce::Justification::centred, 1);
}

void MyNewPluginAudioProcessorEditor::resized()
{
    // This is generally where you'll want to lay out the positions of any
    // subcomponents in your editor..
}
