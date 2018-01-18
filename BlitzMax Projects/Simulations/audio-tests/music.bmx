SuperStrict

SeedRnd MilliSecs()

Local sample:TAudioSample=CreateAudioSample( 32,10000,SF_STEREO16BE )

For Local k:Int=0 Until 32
        sample.samples[k]=Sin(k*360/32)*127.5+127.5
Next

Local sound:TSound=LoadSound(sample,True)

Local channel1:TChannel = sound.play()
Local channel2:TChannel = sound.play()

Local last_time:Int = MilliSecs()

Local time_to_next:Int = 300

Local act_rate:Float = 1.0
Local ziel_rate:Float = 1.0

Repeat
	If last_time + time_to_next < MilliSecs() Then
		last_time = MilliSecs()
		
		time_to_next = 300.0*2.0^Rand(0,Rand(0,1))
		
		ziel_rate = 2.0^(Float(Rand(-12,36))/12.0)
	End If
	
	act_rate = (0.99*act_rate + 0.01*ziel_rate)
	
	channel1.SetRate(act_rate)
	channel2.SetRate(act_rate*2.0^(6.0/12.0))
	Delay 1
Until KeyHit(key_escape)