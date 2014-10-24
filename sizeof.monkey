Strict

Public

' Preprocessor related:
#SIZEOF_IMPLEMENTED = True
#SIZEOF_DATABUFFER = True

#If LANG = "cpp"
	#SIZEOF_NATIVE = True
	
	#If TARGET <> "win8"
		#SIZEOF_NORMAL_CPP_TARGET = True
	#End
#End

' Imports (Public):
'Import vector

#If SIZEOF_NATIVE
	Import "native/sizes.${LANG}"
#End

' Imports (Private):
Private

#If SIZEOF_DATABUFFER
	Import brl.databuffer
#End

Public

' Global & Constant variable(s):

' Standard type sizes:
Const SizeOf_Octet:Int = 1
Const SizeOf_Octet_InBits:Int = 8

Const SizeOf_Byte:Int = SizeOf_Octet
Const SizeOf_Byte_InBits:Int = SizeOf_Octet_InBits

#If Not SIZEOF_NATIVE
	Const SizeOf_Integer:Int = 4 * SizeOf_Octet ' 8
	
	#If CPP_DOUBLE_PRECISION_FLOATS And SIZEOF_NORMAL_CPP_TARGET
		Const SizeOf_FloatingPoint:Int = 8 * SizeOf_Octet
	#Else
		Const SizeOf_FloatingPoint:Int = 4 * SizeOf_Octet
	#End
	
	Const SizeOf_Boolean:Int = SizeOf_Byte ' 1
#Else
	' Global variable(s) (External):
	
	' Modifying these values is considered non-standard, and should not be attempted:
	Extern
	
	Global SizeOf_Integer:Int = "sizeof_int"
	Global SizeOf_FloatingPoint:Int = "sizeof_Float"
	Global SizeOf_Boolean:Int = "sizeof_Boolean"
	
	Public
#End

#If SIZEOF_NATIVE And LANG = "cpp" And SIZEOF_NORMAL_CPP_TARGET
	' Global variable(s) (External):
	
	Extern
	
	' Modifying the value of this variable is considered non-standard, and should not be attempted.
	Global SizeOf_Char:Int = "sizeof_Char"
	
	Public
#Else
	Const SizeOf_Char:Int = SizeOf_Byte ' 1
#End

Global SizeOf_Char_InBits:Int = SizeOf_Char * SizeOf_Octet_InBits
Global SizeOf_Integer_InBits:Int = SizeOf_Integer * SizeOf_Octet_InBits
Global SizeOf_FloatingPoint_InBits:Int = SizeOf_FloatingPoint * SizeOf_Octet_InBits
Global SizeOf_Boolean_InBits:Int = SizeOf_Boolean * SizeOf_Byte_InBits ' SizeOf_Octet_InBits

' External bindings:
#If SIZEOF_NATIVE
	Extern
	
	#If LANG = "cpp"
		' Functions (Native):
		Function SizeOf:Int(I:Int)="(int)sizeof"
		Function SizeOf:Int(F:Float)="(int)sizeof"
		Function SizeOf:Int(B:Bool)="(int)sizeof"
	#Else
		' Nothing so far.
	#End
	
	Public
#End

' Functions (Monkey):

' This is mainly used for internal stream functionality in 'util'.
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

#If Not MONKEYLANG_EXPLICIT_BOXES
	Function SizeOf:Int(IO:IntObject)
		Return SizeOf(IO.ToInt())
	End
	
	Function SizeOf:Int(FO:FloatObject)
		Return SizeOf(FO.ToFloat())
	End
	
	Function SizeOf:Int(BO:BoolObject)
		Return SizeOf(BO.ToBool())
	End
	
	Function SizeOf:Int(S:StringObject, IsString:Bool=True)
		Return SizeOf(S.ToString(), IsString)
	End
#End

Function SizeOf:Int(S:String, IsString:Bool=True)
	' Make the input-string upper-case.
	S = S.ToUpper()
	
	If (Not IsString) Then
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
		
		#Rem
			Elseif (S.Find("BYTE")) Then
				Return SizeOf_Byte
		#End
		Endif
	Endif
	
	' Return the default response.
	Return SizeOf_Char * S.Length()
End

#If SIZEOF_DATABUFFER
	Function SizeOf:Int(Data:DataBuffer)
		Return Data.Length()
	End
#End

Function InBits:Int(I:Int)
	Return SizeOf_Integer_InBits
End

Function InBits:Int(F:Float)
	Return SizeOf_FloatingPoint_InBits
End

Function InBits:Int(B:Bool)
	Return SizeOf_Boolean_InBits
End

Function InBits:Int(S:String, IsString:Bool=False)
	Local Output:= SizeOf(S, IsString)
	
	If (Not IsString) Then
		Return Output * SizeOf_Octet_InBits
	Endif
	
	Return Output * SizeOf_Char_InBits
End