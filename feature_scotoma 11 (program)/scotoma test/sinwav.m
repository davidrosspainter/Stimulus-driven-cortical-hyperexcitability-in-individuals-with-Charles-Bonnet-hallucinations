function my_sound = sinwav(Frequency,Duration,SamplingRate)
    my_sound = sin((1:Duration*SamplingRate)*2*pi*Frequency/SamplingRate);
return