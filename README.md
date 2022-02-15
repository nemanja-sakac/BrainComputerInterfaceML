# Brain Computer Interface Using the SSVEP Paradigm

Brain-computer interfaces (BCIs) are real-time systems used to connect humans with computers, without the use of the musculoskeletal system. Computers may be connected to various actuators allowing the users to control wheelchairs, PC cursors, electronic devices etc. all with the use of brain activity alone. Features can be extracted from electroencephalography (EEG) signals and encoded into commands the user can perform. Steady-state visually evoked potentials (SSVEP) represent a category of sensory evoked potentials, i.e. electrical activity of the brain generated as a result of applying visual stimuli which can be used to encode these commands.

In this project, EEG signals released as part of the EU-funded research project MAMEM[^1] have been preprocessed and machine learning methods have been applied to classify EEG activity as commands, as proposed by Oikonomou[^2]. Subject trials containing the signals are extracted using the eegtoolkit[^3] provided by the authors of the project. The signals are then preprocessed by filtering and applying blind-source separation techniques for artefact removal, implemented in MATLAB. Features are extracted from the Power Density Spectrum (PSD) and used as inputs for command classification. For classification, Neural Networks and Support Vector Machines (with and without the use of kernels and regularization) have been used. Nested Cross-Validation has been used as the validation procedure. Both classification and validation were implemented using the library Scikit-learn in Python.

[^1] 
[^2] 
[^3] 
