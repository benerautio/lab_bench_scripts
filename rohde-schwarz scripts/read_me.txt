VISA_Instrument
- Matlab class allowing instrument control and communication without the need for the Instrument Control Toolbox.
- See http://www.rohde-schwarz.com/appnote/1MA171
- The remaining tools leverage this class.


parseSCPIFile.m
- Reads an ASCII file containing SCPI format commands, line by line
- Useful for sending multiple SCPI commands behind the scenes, keeping Matlab scripts clean
- Capable of collating and returning instrument responses/measurements, but not (yet) the most efficient for massive data collection


FSW_init.scpi
- An example SCPI file that can be parsed with parseSCPIFile()


mat2wv.m and wv2mat.m
- Scripts for converting between Matlab complex valued, time-series, data intended for signal generators and the native .wv file format used by R&S ARB signal generators.
- wv2mat does not import encrypted .wv files!


iqcapture.m
- Function to capture and import IQ data from Spectrum Analyzer.
- Illustrates the use of "QueryBinaryFloatData", for rapid, massive binary-format data transfer from the instrument directly into Matlab.
