Strict

Public

' Preprocessor related:
#If LANG = "cpp"
	#SIZEOF_NATIVE = True
#End

' Imports:
'Import vector

' Constant variable(s):

' Standard type sizes (In bytes):
#If Not SIZEOF_NATIVE
	Const SizeOf_Integer:Int = 4 ' 8
	
	#If CPP_DOUBLE_PRECISION_FLOATS And LANG = "cpp" And TARGET <> "win8"
		Const SizeOf_FloatingPoint:Int = 8
	#Else
		Const SizeOf_FloatingPoint:Int = 4
	#End
	
	Const SizeOf_Boolean:Int = 1
#Else
	Const SizeOf_Integer:Int = SizeOf(0)
	Const SizeOf_FloatingPoint:Int = SizeOf(0.0)
	Const SizeOf_Boolean:Int = SizeOf(False)
#End

' External bindings:
#If SIZEOF_NATIVE
	Extern
	
	' Functions (Native):
	Function SizeOf:Int(I:Int)="(int)sizeof"
	Function SizeOf:Int(F:Float)="(int)sizeof"
	Function SizeOf:Int(B:Bool)="(int)sizeof"
	
	Public
#End

' Functions (Monkey):
Function IntSize:Int(Size:Int)
	If (Size > 1) Then
		If (Size > 4) Then
			Return 8
		Elseif (Size < 4) Then
			Return 2
		Else
			Return 4
		Endif
	Endif
	
	Return 1
End

#If Not SIZEOF_NATIVE
	Function SizeOf:Int(I:Int)
		Return SizeOf_Integer
	End
	
	Function SizeOf:Int(F:Float)
		Return SizeOf_FloatingPoint
	End
	
	Function SizeOf:Int(B:Bool)
		Return SizeOf_Boolean
	End
#End

Function SizeOf:Int(S:String)
	' Make the input-string upper-case.
	S = S.ToUpper()
	
	If (S.Find("INT") <> -1) Then
		Return SizeOf(0)
	Elseif (S.Find("FLOAT") <> -1) Then
		Return SizeOf(0.0)
	Elseif (S.Find("BOOL") <> -1) Then
		Return SizeOf(False)
	#Rem
		Elseif (S.Find("VEC") <> -1) Then
			Return Max(Int(S), 1)
	#End
	Endif
	
	' Return the default response.
	Return 1
End