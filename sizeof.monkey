Strict

Public

' Preprocessor related:
#SIZEOF_IMPLEMENTED = True

' By enabling this, you allow 'SizeOf' to be used with the standard 'DataBuffer' class.
#SIZEOF_DATABUFFER = True

#If LANG = "cpp"
	'#SIZEOF_NATIVE = True
#End

#If LANG = "cpp" And TARGET <> "win8" And TARGET <> "winrt"
	#SIZEOF_NORMAL_CPP_TARGET = True
#End

' Imports (Public):
'Import regal.vector

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

#Rem
	Please refrain from using these "constants" with your personal aliases.
	For example, you shouldn't do something like: "Const SizeOf_F:= SizeOf_FloatingPoint".
	If you must do this, please use a global variable as the "alias" (Could be slower).
	It's best not to bother with this, though, just use these variables directly.
	You could technically check against 'SIZEOF_NATIVE' with the preprocessor,
	but this may not be portable in the future.
#End

' Standard type sizes:
Const SizeOf_Octet:Int = 1
Const SizeOf_Octet_InBits:Int = 8

Const SizeOf_Byte:= SizeOf_Octet
Const SizeOf_Byte_InBits:= SizeOf_Octet_InBits

#If Not SIZEOF_NATIVE
	Const SizeOf_Integer:= 4 * SizeOf_Byte ' 8
	
	#If CPP_DOUBLE_PRECISION_FLOATS And SIZEOF_NORMAL_CPP_TARGET
		Const SizeOf_FloatingPoint:= 8 * SizeOf_Byte
	#Else
		Const SizeOf_FloatingPoint:= 4 * SizeOf_Byte
	#End
	
	Const SizeOf_Boolean:= SizeOf_Byte ' 1 ' 4
	
	Const SizeOf_Short:= 2 * SizeOf_Byte
	Const SizeOf_Long:= 8 * SizeOf_Byte
#Else
	' Global variable(s) (External):
	
	' Modifying these values is considered non-standard, and should not be attempted:
	Extern
	
	Global SizeOf_Integer:Int = "sizeof_int"
	Global SizeOf_FloatingPoint:Int = "sizeof_Float"
	Global SizeOf_Boolean:Int = "sizeof_boolean"
	
	Global SizeOf_Short:Int = "sizeof_short"
	Global SizeOf_Long:Int = "sizeof_long"
	
	Public
#End

#If SIZEOF_NATIVE And LANG = "cpp" And SIZEOF_NORMAL_CPP_TARGET
	' Global variable(s) (External):
	
	Extern
	
	' Modifying the value of this variable is considered non-standard, and should not be attempted.
	Global SizeOf_Char:Int = "sizeof_Char"
	
	Public
#Else
	Const SizeOf_Char:= SizeOf_Byte ' 1
#End

' Type sizes (In bits):
Global SizeOf_Char_InBits:= SizeOf_Char * SizeOf_Byte_InBits
Global SizeOf_Integer_InBits:= SizeOf_Integer * SizeOf_Byte_InBits
Global SizeOf_FloatingPoint_InBits:= SizeOf_FloatingPoint * SizeOf_Byte_InBits
Global SizeOf_Boolean_InBits:= SizeOf_Boolean * SizeOf_Byte_InBits ' SizeOf_Byte_InBits

Global SizeOf_Short_InBits:= SizeOf_Short * SizeOf_Byte_InBits
Global SizeOf_Long_InBits:= SizeOf_Long * SizeOf_Byte_InBits

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
			Return SizeOf_Long
		Elseif (Size < 4) Then
			Return SizeOf_Short
		Else
			Return SizeOf_Integer
		Endif
	Endif
	
	' Return the default response.
	Return SizeOf_Byte
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
	If (Not IsString) Then
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
		Return Output * SizeOf_Byte_InBits
	Endif
	
	Return Output * SizeOf_Char_InBits
End