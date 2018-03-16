# Extract EGG data

## extract-egg-data.praat
```praat
data_dir$ = "../data/derived/audio"
egg_dir$ = "../data/raw/audio"
createDirectory("../results")
results_file$ = "../results/tracegram.csv"
results_header$ = "speaker,index,word,position,proportion,maximum,minimum"
writeFileLine: results_file$, results_header$

smooth_width = 11

file_list = Create Strings as file list: "file_list", "'data_dir$'/*-palign-manual.TextGrid"
number_of_files = Get number of strings

for file from 1 to number_of_files
    <<<read files>>>

    <<<egg loop>>>
endfor

<<<smoothing>>>
```

### "read files"
```praat
selectObject: file_list
textgrid$ = Get string: file
textgrid = Read from file: "'data_dir$'/'textgrid$'"
speaker$ = textgrid$ - "-palign-manual.TextGrid"
audio = Read from file: "'egg_dir$'/'speaker$'.wav"
egg = Extract one channel: 2
Multiply: -1
removeObject: audio
```

### "egg loop"
```praat
selectObject: textgrid
sentence_intervals = Get number of intervals: 3
index = 0

for sentence_interval from 1 to sentence_intervals
    selectObject: textgrid
    sentence_label$ = Get label of interval: 3, sentence_interval

    if sentence_label$ == "speech"
      index = index + 1
        sentence_start = Get start time of interval: 3, sentence_interval
        sentence_end = Get end time of interval: 3, sentence_interval
        word_interval = Get interval at time: 2, sentence_start
        first_word$ = Get label of interval: 2, word_interval

        if first_word$ == "say"
            phone_interval = Get interval at time: 1, sentence_start
            vowel_interval = phone_interval + 3
            position$ = "medial"
        else if first_word$ == "the"
            phone_interval = Get interval at time: 1, sentence_start
            vowel_interval = phone_interval + 8
            position$ = "final"
        endif

        vowel_start = Get start time of interval: 1, vowel_interval
        vowel_end = Get end time of interval: 1, vowel_interval
        word_interval = Get interval at time: 2, vowel_start
        word$ = Get label of interval: 2, word_interval

        <<<degg>>>

        <<<degg loop>>>

    endif

endfor
```

### "degg"
```praat
selectObject: egg
sentence_egg = Extract part: sentence_start, sentence_end, "rectangular", 1, "yes"

sentence_egg_filtered = Filter (pass Hann band): 40, 10000, 100
@smoothing: smooth_width
sampling_period = Get sampling period
time_lag = (smooth_width - 1) / 2 * sampling_period
Shift times by: time_lag
egg_pp = noprogress To PointProcess (periodic, peaks): 75, 600, "yes", "no"
sentence_sound_end = Get end time
Remove points between: 0, vowel_start
Remove points between: vowel_end, sentence_sound_end

selectObject: sentence_egg_filtered
Copy: "degg"
Formula: "self [col + 1] - self [col]"
degg = Remove noise: 0, 0.1, 0.025, 80, 10000, 40, "Spectral subtraction"
degg_pp = noprogress To PointProcess (periodic, peaks): 75, 600, "yes", "no"
Remove points between: 0, vowel_start
Remove points between: vowel_end, sentence_sound_end
```

### "degg loop"
```praat
selectObject: egg_pp
egg_points = Get number of points
mean_period = Get mean period: 0, 0, 0.0001, 0.02, 1.3

for point to egg_points - 2
    selectObject: egg_pp
    point_1 = Get time from index: point
    point_2 = Get time from index: point + 1
    point_3 = Get time from index: point + 2
    selectObject: sentence_egg_filtered
    egg_minimum_1 = Get time of minimum: point_1, point_2, "Sinc70"
    egg_minimum_2 = Get time of minimum: point_2, point_3, "Sinc70"
    period = egg_minimum_2 - egg_minimum_1

    if period <= mean_period * 2
        selectObject: degg_pp
        degg_pp_points = Get number of points

        if degg_pp_points != 0
          degg_maximum_point_1 = Get nearest index: egg_minimum_1
          degg_maximum = Get time from index: degg_maximum_point_1

          if degg_maximum <= egg_minimum_1
              degg_maximum = Get time from index: degg_maximum_point_1 + 1
          endif

          if degg_maximum != undefined
              selectObject: degg
              degg_minimum = Get time of minimum: degg_maximum, egg_minimum_2, "Sinc70"

              degg_maximum_rel = (degg_maximum - egg_minimum_1) / period
              degg_minimum_rel = (degg_minimum - egg_minimum_1) / period

              time = egg_minimum_1 - vowel_start
              proportion = (egg_minimum_1 - vowel_start) / (vowel_end - vowel_start)

              results_line$ = "'speaker$','index','word$','position$','proportion','degg_maximum_rel','degg_minimum_rel'"

              appendFileLine: results_file$, results_line$
          endif
        endif
    endif
endfor
```

### "smoothing"
```praat
procedure smoothing : .width
    .weight = .width / 2 + 0.5

    .formula$ = "( "

    for .w to .weight - 1
        .formula$ = .formula$ + string$(.w) + " * (self [col - " + string$(.w) + "] +
            ...self [col - " + string$(.w) + "]) + "
    endfor

    .formula$ = .formula$ + string$(.weight) + " * (self [col]) ) / " +
        ...string$(.weight ^ 2)

    Formula: .formula$
endproc
```
