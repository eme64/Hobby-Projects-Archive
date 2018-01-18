import brl.blitz
import brl.glmax2d
import pub.glew
import brl.standardio
TImageBuffer^Object{
.Image:TImage&
.rb%&[]&
.fb%&[]&
.Imageframe:TGLImageframe&
.Frame%&
.OrigX%&
.OrigY%&
.OrigW%&
.OrigH%&
-New%()="_bb_TImageBuffer_New"
-Delete%()="_bb_TImageBuffer_Delete"
+SetBuffer:TImageBuffer(Image:TImage,Frame%=0)="_bb_TImageBuffer_SetBuffer"
+Init%(Width%,Height%,Bit%=0,Mode%=60)="_bb_TImageBuffer_Init"
-GenerateFBO%()="_bb_TImageBuffer_GenerateFBO"
-BindBuffer%()="_bb_TImageBuffer_BindBuffer"
-UnBindBuffer%()="_bb_TImageBuffer_UnBindBuffer"
-Cls%(r#=0#,g#=0#,b#=0#,a#=1#)="_bb_TImageBuffer_Cls"
-BufferWidth%()="_bb_TImageBuffer_BufferWidth"
-BufferHeight%()="_bb_TImageBuffer_BufferHeight"
}="bb_TImageBuffer"
AdjustTexSize%(width% Var,height% Var)="bb_AdjustTexSize"
Pow2Size%(n%)="bb_Pow2Size"
