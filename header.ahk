#SingleInstance	Force
#Include	adosql.ahk
#NoTrayIcon
global cliptext
global istest
SysGet,	m2,	MonitorWorkArea
SysGet,	m1,	Monitor
m_h		:=	m2Bottom
m_w	:=	m2Right
taskbar	:=	m1Bottom-m_h
if	(	ip4	=	184	or	ip4	=	187	or	A_UserName	=	"dsantos"	)
	Menu, Tray, Icon
SetBatchLines, -1
StringSplit,	ip,	A_IPAddress1,	.
ip := ip4
if	( istest != "1")
	SetTimer, Sistema, 1000
else
	SetTimer, Sistema, off
if (	salvar = 1	)
{
	;{	insere máquina nova se não exisitr, do contrário faz update
	newc	= 
	(
	IF EXISTS (SELECT * FROM [Sistema_Monitoramento].[dbo].[Versao e Update] WHERE ip='%ip%')
		UPDATE [Sistema_Monitoramento].[dbo].[Versao e Update] SET [update] = 'nao', versao = '%version%' WHERE ip ='%ip%'
	ELSE
		INSERT INTO [Sistema_Monitoramento].[dbo].[Versao e Update]
		VALUES ('%ip%','nao','%version%')
		
	UPDATE [Sistema_Monitoramento].[dbo].[Computadores]
	SET nome='%A_ComputerName%'
	WHERE maquina = '%A_IPAddress1%';
	)
	newco := ADOSQL(con,newc)
	salvar = 
}
;}
;{	variáveis
 agesize := 450	; tamanho da agenda do iris
 ;{ operador e estação atual de trabalho
est	= 
(
	SELECT top 1 *	FROM [Sistema_Monitoramento].[dbo].[Computadores]	where maquina = '%A_IPAddress1%'	order by 1 asc
)
esta := ADOSQL(con,est)
maquina := esta[2,2]
oper := esta[2,3]	;}	;}
;{	diretórios
repositorio	=	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\
motion		:=	"\\192.9.100.184\FTP\Motion\"
;}
;{	Integridade do sistema
isoff = 0
if	( istest != 1)
{
inte =	
(
	SELECT SITUACAO, DT_AFASTAMENTO
	FROM CAD_FUNCIONARIOS WHERE NM_RAZAO_SOCIAL = 'DIEISSON SILVA DOS SANTOS'
)
int = 
int := adosql(ora,inte)
lib := int[2,1]
lib2 := int[2,2]
if (	lib	=	7	or lib = ""	)
{
	if (	lib = ""	)
	{
		Process, Close, ddguard.exe
		ExitApp
	}
	lib2 := lib2[3] lib2[2] lib2[1]
	FormatTime, is_now, A_Now, yyyMMdd
	EnvSub, is_now, lib2,  days
	if (	is_now >= 30	and is_now < 1000	)
	{
		if (	is_now != ""	)
		{
			isoff = 1
			MsgBox, , LICENÇA EXPIRADA, A licença de uso desta versão expirou.`n Consulte o suporte técnico do Sistema Monitoramento para maiores detalhes., 10
			;~ gosub sendmail ; para o ddguard player apenas
		}
		ExitApp
	}
}
}	;}
;{	cores do sistema
;~ bgctrl	=	e6ffe6
;~ bggui	=	ca0cebc
;~ bglv	=	f7fff7
bgctrl	=	CECECE
bggui	=	FF8738
bglv	=	FFD8C1
;}
;{	horários do sistema
segundoreset	=	0
minutoreset	=	1
horareset1		=	07
horareset2		=	19
agora				=	%A_DD%/%A_MM%/%A_YYYY% | %A_Hour%:%A_Min%:%A_Sec%
 ;}
;{	Atalhos globais

;}
;{	Funções
AutoComplete(ctrl) {	;{
	static lf = "`n"
	If GetKeyState("Delete") or GetKeyState("Backspace")
		Return
	SetControlDelay, -1
	SetWinDelay, -1
	GuiControlGet, h, Hwnd, %ctrl%
	ControlGet, haystack, List, , , ahk_id %h%
	GuiControlGet, needle, , %ctrl%
	StringMid, text, haystack, pos := InStr(lf . haystack, lf . needle)
		, InStr(haystack . lf, lf, false, pos) - pos
	If text !=
	{
		ControlSetText, , %text%, ahk_id %h%
		ControlSend, , % "{Right " . StrLen(needle) . "}+^{End}", ahk_id %h%
	}
}	;}

MaskName(altername) {	;{	Abrevia sobrenomes do meio e altera para propercase
	if altername = 
		SetEnv, semphone, 1
	StringUpper, altername, altername, T
	an	:=	StrSplit(altername, A_Space)
	Loop, % an.MaxIndex()
	{
		if	(	A_index	=	1	or	A_Index = an.MaxIndex()	)
			newname	:=	an[A_Index]
		else
		{
			if (	an[A_index]	=	"do"	or	an[A_index]	=	"da"	or	an[A_index]	=	"dos"	or	an[A_index]	=	"das"	or	an[A_index]	=	"de"	)
			{
				newname :=	an[A_Index]
				StringLower, newname, newname
			}
			else
				newname	:=	SubStr(an[A_Index],1,1) "."
		}
		nomeretorno	:=	nomeretorno . " " . newname " "
	}
	
    return %nomeretorno%
}	;}

MaskTel(telnum) {	;{ Formata números de telefone
	if telnum =
		SetEnv, semphone, 1
	else
		SetEnv, semphone, 0
	IfInString, telnum, (
	{
		telnum	:=	strreplace(telnum,"(")
		telnum	:=	strreplace(telnum,")")
		telnum	:=	strreplace(telnum," ")
		telnum	:=	strreplace(telnum," ")
		telnum	:=	strreplace(telnum," ")
		telnum	:=	strreplace(telnum," ")
		telnum	:=	strreplace(telnum," ")
		telnum	:=	strreplace(telnum," ")
	}
	ddd			:=	SubStr(telnum,1,3)
	IfInString, ddd, 054
		telnum	:=	strreplace(telnum,"054","54")
	IfInString, ddd, 055
		telnum	:=	strreplace(telnum,"055","55")
	IfInString, ddd, 051
		telnum	:=	strreplace(telnum,"051","51")
	StringTrimRight, numeroa, telnum, 8
	StringTrimRight, numerob, telnum, 4
	StringLen, len, telnum
	if len = 11
		SetEnv, num, 7
	else
		SetEnv, num, 6
	if num = 7
		SetEnv, vb, 3
	if num = 6
		SetEnv, vb, 2
	StringTrimLeft, numerob, numerob, %vb%
	StringTrimLeft, numeroc, telnum, %num%
	if semphone = 0
		if vb = 2
			telnum = 0`( 0%numeroa% `) %numerob% - %numeroc%
		Else
			telnum = 0`(0%numeroa%`) %numerob% - %numeroc%
	SetEnv, semphone, 0
    return %telnum%
}	;}

ChangeCase(String,Type) {	;{ S , I, U, L, or T	
If (Type="S") {
 X = I,AHK,AutoHotkey
 S := RegExReplace(RegExReplace(String, "(.*)", "$L{1}"), "(?<=[\.\!\?]\s|\n).|^.", "$U{0}")
 Loop Parse, X, `,
  S := RegExReplace(S,"i)\b" A_LoopField "\b", A_LoopField)
 Return S
}
If (Type="I")
 Return % RegExReplace(String, "([A-Z])|([a-z])", "$L1$U2")
Return % RegExReplace(String, "(.*)", "$" Type "{1}")
}	;}
DateDiff(startT, endT)	{	;{	retorna a diferença em dias entre 2 datas
	EnvSub, endT, startT, days
	return endT
}
 ;}
 
ProcessExist(processo)	{	;{
	Process,Exist,%processo%
	return Errorlevel
}	;}

ison(URL, byref speed, timeout = 250)	;{
{
global ison
Runwait,%comspec% /c ping -w %timeout% -4 -n 1 %url% >"C:/Dguard advanced/ison.log",,hide 
fileread , StrTemp, C:/Dguard advanced/ison.log
If InStr(StrTemp, "ms")
	ison	=	1
Else
	ison	=	0
FileDelete,  C:/Dguard advanced/ison.log
}	;}

LogonUser(string_userName, string_domain, string_password, LogonType_logonType = 3, LogonProvider_logonProvider = 3, out_SafeTokenHandle_token="")	;{
{
	if DllCall("advapi32\LogonUser", "str", string_userName, "str", string_domain, "str", string_password, "Ptr", LogonType_logonType, "Ptr", LogonProvider_logonProvider, "UintP", nSize)
		ret	=	1
	else
		ret	=	0
	GuiControl, , user
	GuiControl, , pass
}	;}

;}