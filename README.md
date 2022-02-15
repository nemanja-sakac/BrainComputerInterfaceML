# Brain Computer Interface Using the SSVEP Paradigm

Brain-computer interfaces (BCIs) are real-time systems used to connect humans with computers, without the use of the musculoskeletal system. Computers may be connected to various actuators allowing the users to control wheelchairs, PC cursors, electronic devices etc. all with the use of brain activity alone. Features can be extracted from electroencephalography (EEG) signals and encoded into commands the user can perform. Steady-state visually evoked potentials (SSVEP) represent a category of sensory evoked potentials, i.e. electrical activity of the brain generated as a result of applying visual stimuli which can be used to encode these commands.

In this project, EEG signals released as part of the EU-funded research project MAMEM[^1] have been preprocessed and machine learning methods have been applied to classify EEG activity as commands, as proposed by Oikonomou et al.[^2]. Subject trials containing the signals are extracted using the eegtoolkit[^3] provided by the authors of the project. The signals are then preprocessed by filtering and applying blind-source separation techniques for artefact removal, implemented in MATLAB. Features are extracted from the Power Density Spectrum (PSD) and used as inputs for command classification. For classification, Neural Networks and Support Vector Machines (with and without the use of kernels and regularization) have been used. Nested Cross-Validation has been used as the validation procedure. Both classification and validation were performed in Jupyter Notebooks using the library Scikit-learn in Python.

[^1]: “MAMEM – Multimedia Authoring & Management using your Eyes & Mind,” 12 04 2021. [Online]. Available: https://www.mamem.eu/. [Accessed 12 04 2021].

[^2]: Vangelis P. Oikonomou, Georgios Liaros, Kostantinos Georgiadis, Elisavet Chatzilari, Katerina Adam, Spiros Nikolopoulos and Ioannis Kompatsiaris, "Comparative evaluation of state-of-the-art algorithms for SSVEP-based BCIs", Technical Report - eprint arXiv:1602.00904, February 2016

[^3]: “GitHub - MAMEM/eeg-processing-toolbox: Matlab code for proccesing EEG signals,” 15 04 2021. [Online]. Available: https://github.com/MAMEM/eeg-processing-toolbox. [Accessed 15 04 2021].
