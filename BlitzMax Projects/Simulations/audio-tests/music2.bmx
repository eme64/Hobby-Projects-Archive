SuperStrict


Type TON
	Global sample:TAudioSample[1000]
	Global channel:TChannel[1000]
	
	Function ini()
		For Local i:Int=0 To 1000-1
			TON.sample[i]=CreateAudioSample(32,2000+i*i*0.1,SF_STEREO16BE)
			For Local k:Int=0 Until 32
        			TON.sample[i].samples[k]=Sin(k*360/32)*127.5+127.5
			Next
			
			TON.channel[i]=CueSound(LoadSound(TON.sample[i],True))
			If i<400 Then TON.channel[i].SetPan(1) Else TON.channel[i].SetPan(-1)
			'TON.channel[i].SetPan(Rand(0,2)-1)
		Next
		
		
	End Function
	
	
	Function play_music(text:String)
		For Local i:Int=1 To Len(text)
			ResumeChannel(TON.channel[Asc(Mid(text,i,1))])
			Delay 100
			PauseChannel(TON.channel[Asc(Mid(text,i,1))])
		Next
	End Function
End Type


TON.ini()
Rem
Local s:String=""
For Local i:Int=1 To 200
	s=s+Chr(Rand(0,Rand(255)))
Next
TON.play_music(" k4l.'`gk/*-+ k4l.'`gk/*-+ k4l.'`gk/*-+ k4l.'`gk/*-+")
End
End Rem

Rem
Repeat
	Local i:Int=Rand(0,Rand(0,1000))
	ResumeChannel(TON.channel[i])
	Delay 100
	PauseChannel(TON.channel[i])
Forever
End Rem

'Rem
Repeat
	For Local i:Int=200 To 1000-1 Step 1
		ResumeChannel(TON.channel[i*0.1])
		ResumeChannel(TON.channel[i])
		ResumeChannel(TON.channel[i-100])
		ResumeChannel(TON.channel[i-200])
		
		Delay 30
		PauseChannel(TON.channel[i*0.1])
		PauseChannel(TON.channel[i])
		PauseChannel(TON.channel[i-100])
		PauseChannel(TON.channel[i-200])
	Next
	
	For Local i:Int=1000-1 To 200 Step -1
		ResumeChannel(TON.channel[i*0.1])
		ResumeChannel(TON.channel[i])
		ResumeChannel(TON.channel[i-100])
		ResumeChannel(TON.channel[i-200])
		Delay 10
		PauseChannel(TON.channel[i*0.1])
		PauseChannel(TON.channel[i])
		PauseChannel(TON.channel[i-100])
		PauseChannel(TON.channel[i-200])
	Next
Forever
'End Rem

Rem
Graphics 200,200

Repeat
	For Local i:Int=1 To 360
		ResumeChannel(TON.channel[(Cos(i)+1.0)*200+300])
		ResumeChannel(TON.channel[(Sin(i)+1.0)*200+300])
		
		
		Cls
		SetColor 255,255,255
		DrawLine 100,100,Cos(i)*100+100,Sin(i)*100+100
		SetColor 255,0,0
		DrawRect Cos(i)*100+95,Sin(i)*100+95,10,10
		SetColor 100,100,100
		DrawLine 0,Sin(i)*100+100,200,Sin(i)*100+100
		DrawLine Cos(i)*100+100,0,Cos(i)*100+100,200
		Flip
		If KeyHit(key_escape) Or AppTerminate() Then End
		
		
		PauseChannel(TON.channel[(Cos(i)+1.0)*200+300])
		PauseChannel(TON.channel[(Sin(i)+1.0)*200+300])
	Next
Forever
End Rem

Rem
Local i:Int=300
Local ii:Int=700
Repeat
	i:+Rand(0,50)-25
	If i<0 Then i=0
	If i>999 Then i=999
	
	ii:+Rand(0,50)-25
	If ii<0 Then ii=0
	If ii>999 Then ii=999
	ResumeChannel(TON.channel[i])
	ResumeChannel(TON.channel[ii])
	Delay 100
	PauseChannel(TON.channel[i])
	PauseChannel(TON.channel[ii])
Forever
End Rem