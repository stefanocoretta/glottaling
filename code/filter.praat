form Pre-process audio
  word file m01.wav
  boolean all_files 0
endform

raw$ = "../data/raw/audio"
derived$ = "../data/derived/audio"
Create Strings as file list: "file_list", "'raw$'/*.wav"
files = Get number of strings

if all_files = 1
  for file from 1 to files
      select Strings file_list
      file$ = Get string: file
      Read from file: "'raw$'/'file$'"
      file_name$ = selected$ ("Sound")
  
      Extract one channel: 1
  
      Filter (pass Hann band): 40, 10000, 100
  
      Save as WAV file: "'derived$'/'file_name$'.wav"
  endfor
else
  Read from file: "'raw$'/'file$'"
  file_name$ = selected$ ("Sound")
  
  Extract one channel: 1
  
  Filter (pass Hann band): 40, 10000, 100
  
  Save as WAV file: "'derived$'/'file_name$'.wav"
endif
