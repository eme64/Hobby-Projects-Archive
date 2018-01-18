SuperStrict

Type PUNKT
	Global plot_in:Int
	Global plot_anz:Int
	
	Const scale:Int=200
	Const lenge:Int=1000
	
	
	'Global feld:Int[PUNKT.lenge,PUNKT.lenge]
	
	Function draw(x:Float,y:Float,z:Float)
		If ((x^2+y^2+z^2)=<1) Or (Abs(x)>0.98) + (Abs(y)>0.98) + (Abs(z)>0.98)>1 Then
			DrawRect x*PUNKT.scale-0.4*z*PUNKT.scale+400,y*PUNKT.scale-0.3*z*PUNKT.scale+300,2,2
		End If
	End Function
End Type


'Graphics 800,600


	PUNKT.plot_in=0
	PUNKT.plot_anz=0
	For Local x:Int= (PUNKT.lenge/2)-1 To -(PUNKT.lenge/2) Step -1
		Print x
		For Local y:Int=(PUNKT.lenge/2)-1 To -(PUNKT.lenge/2) Step -1
			For Local z:Int=(PUNKT.lenge/2)-1 To -(PUNKT.lenge/2) Step -1
				'SetColor 255*(x+(PUNKT.lenge/2))/PUNKT.lenge,255*(y+(PUNKT.lenge/2))/PUNKT.lenge,255*(z+(PUNKT.lenge/2))/PUNKT.lenge
				'PUNKT.draw(Float(x)/(PUNKT.lenge/2),Float(y)/(PUNKT.lenge/2),Float(z)/(PUNKT.lenge/2))
				PUNKT.plot_in:+((x^2+y^2+z^2)=<((PUNKT.lenge/2)^2))
				PUNKT.plot_anz:+1
			Next
		Next
	Next
	
	Print "insgesammt: "+PUNKT.plot_in
	Print "in kreis: "+PUNKT.plot_anz
	Print "PI: "+Float(PUNKT.plot_in)/Float(PUNKT.plot_anz)*8.0*3.0/4.0
	