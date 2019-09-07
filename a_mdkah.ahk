;@Ahk2Exe-SetMainIcon C:\Dih\zIco\2motion.ico
soft = detection
#include header.ahk
#SingleInstance Force
#Persistent
Menu Tray, Tip, Detecção de Movimento 1.0.0.1
Folder	=	\\srvftp\monitoramento\FTP\
localini	= \\srvftp\monitoramento\FTP\ini files\
estacoes	=	171,175,178,163,167,184
heigth	:=	m_h-100
;{
IfNotInString, estacoes, %ip4%
	ExitApp
if	(ip4	=	184)	{
	MsgBox, 4, , Gostaria de rodar o sistema de detecção de movimento nessa máquina?
	IfMsgBox,	No
		ExitApp
}
if	( A_UserName = "dsantos" or ip4 = "184" )	{
	oper	=	0006
	Menu, Tray, Icon
}
else
{
	Menu, Tray, Nostandard
	Menu, Tray, Icon
}
l	=	;{
(
	SELECT	[ip],[nome] FROM [MotionDetection].[dbo].[Cameras]
)
local	:=	adosql(con,l)
Loop,	%	local.MaxIndex()-1
	lugar	:=	lugar	.	local[A_index+1, 1]	"="	StrReplace(local[A_Index+1,2]," | "," - ") "`n"	;	10.2.1.2=nomedacâmera	;}
Sort, lugar
buscar	=	\\srvftp\monitoramento\FTP\%oper%\*.jpg	;}
SetTimer, begin, 250
return

;{	Botões
confirmar:	;{
Gui, Submit
;~ SetTimer, passou, Off
l_motivo	:=	StrLen(motivo)

if	(	l_motivo < 10 OR l_motivo > 150	)
{
	Gui, Destroy
	MsgBox O encerramento do evento precisa ter pelo menos 10 carateres e no máximo 150 caracteres.
	Reload
}
else
{
	if	(	inibidor	=	1	)
	{
		inibido_ate	:=	exibido+(StrReplace(inibe," Minutos")*60)
		ip4				:=	SubStr(A_IPAddress1,InStr(A_Ipaddress1,".",false,1,3)+1)
		if	(	inibido_ate > "86400"	)	{
			dia_inibido	:=	A_YDay+1
			exibido = 0
			inibido_ate	:=	inibido_ate-86400
		}
		else
			dia_inibido	:=	A_YDay
		FileMove, % Folder oper "\" atual , % Folder "Inibidos\" arquivo1 " - " oper " - " StrReplace(file[3],".jpg") " - " A_Now " - "  inibe ".jpg", 1
		IniWrite,	%	StrReplace(inibe," Minutos") "=" inibido_ate "=" dia_inibido, %	localini ip4 ".ini", Inibir,	% arquivo1
		mfile			:= "Inibidos\" arquivo1 " - " oper " - " StrReplace(file[3],".jpg") " - " file[2] ".jpg"
	}
	if	(	ocorrencia	=	1	)
	{
		mfile	:= "Movimentos\" arquivo1 " - " oper " - " StrReplace(file[3],".jpg") " - " file[2] ".jpg"
		FileMove, % Folder oper "\" atual , % Folder "Movimentos\" arquivo1 " - " oper " - " StrReplace(file[3],".jpg") " - " file[2] ".jpg", 1	
	}
	gosub sql
}
;~ }
Gui, Destroy
return	;}


b_inibir:	;{
inibidor	:=	!inibidor
if	(	inibidor	=	1	)
{
	GuiControl,	Show,	bText
	GuiControl,	Show,	inibe
	GuiControl,	Show,	conf
	GuiControl,	Show,	canc
	GuiControl,	Show,	motivo
	GuiControl,	Hide,	nada
	GuiControl,	Hide,	mov
	;~ GuiControl,	Hide,	img
	GuiControl,			,	ini,	Voltar
	GuiControl,	Focus,	motivo
}
else
{
	GuiControl,	Hide,	bText
	GuiControl,	Hide,	inibe
	GuiControl,	Hide,	conf
	GuiControl,	Hide,	canc
	GuiControl,	Hide,	motivo
	GuiControl,	Show,	nada
	GuiControl,	Show,	mov
	;~ GuiControl,	Show,	img
	GuiControl,			,	ini,	Inibir
}
return	;}

b_movimento:	;{
ocorrencia	:=	!ocorrencia
if	(	ocorrencia = 1	)
{
	GuiControl,	Hide,	bText
	GuiControl,	Hide,	inibe
	GuiControl,	Show,	moti
	GuiControl,	Show,	bMot
	GuiControl,	Show,	conf
	GuiControl,	Show,	canc
	GuiControl,	Hide,	motivo
	GuiControl,	Hide,	nada
	GuiControl,	Hide,	ini
	;~ GuiControl,	Hide,	img
	GuiControl,			,	mov,	Voltar
	GuiControl,	Show,	motivo
	GuiControl,	Focus,	motivo
}
else
{
	GuiControl,	Hide,	bText
	GuiControl,	Hide,	inibe
	GuiControl,	Hide,	moti
	GuiControl,	Hide,	bMot
	GuiControl,	Hide,	conf
	GuiControl,	Hide,	canc
	GuiControl,	Hide,	motivo
	GuiControl,	Show,	nada
	GuiControl,	Show,	ini
	;~ GuiControl,	Show,	img
	GuiControl,			,	mov,	Ocorrência
	GuiControl,	Hide,	motivo
}
return	;}

b_nada:	;{
FileMove, % Folder oper "\" atual , % Folder "Verificados\" arquivo1 " - " oper " - " StrReplace(file[3],".jpg") " - " A_Now ".jpg", 1
Gui, Destroy
return	;}


;}
begin:			;{
IfWinActive, Detecção de Movimento
	WinWaitClose, Detecção de Movimento
lista =
Loop, Files, %buscar%
	lista	.=	A_LoopFileTimeModified "`t" A_LoopFileFullPath "`n"
Loop, Parse, lista, `n
{
	full		:=	A_LoopField
	atual	:=	SubStr(A_LoopField,InStr(A_LoopField,oper "\")+5)	; nome do arquivo sem o path
	StringSplit, arquivo, atual, _ 
	Loop, Parse, lugar, `n
	{
		fullfile	:=	SubStr(full,InStr(full,"`t")+1)
		If	( InStr(A_LoopField,arquivo1)	>	0)
		{
			file			:=	StrSplit(fullfile,"_")
			data		:=	SubStr(file[2],7,2) "/" SubStr(file[2],5,2) "/" SubStr(file[2],1,4)
			hora		:=	SubStr(file[2],10,2) ":" SubStr(file[2],12,2) ":" SubStr(file[2],14,2)
			exib			:=	StrSplit(hora,":")
			criado		:=	(exib[1]*60*60)+(exib[2]*60)+exib[3]
			exibido	:=	(A_Hour*60*60)+(A_Min*60)+A_Sec
			displayed	:=	SubStr(A_Now,7,2) "/" SubStr(A_Now,5,2) "/" SubStr(A_Now,1,4) " " SubStr(A_Now,9,2) ":" SubStr(A_Now,11,2) ":" SubStr(A_Now,13,2)
			goto gui
		}
	}
}
return	;}
gui:				;{
;~ SetTimer, passou, 1000
Gui, Add, Pic						,%	"x10  									y0 						w1280		h1024							vPic"	;{
Gui, Font, S12   
Gui, Add, Edit						,%	"x10 									y" heigth-130 "	w999		h100							vmotivo							Hidden	"
Gui, Font 
Gui, Add, Button				,%	"x10									y" heigth-30 "	w150		h25	gb_nada				vnada		Default							", Sem motivo aparente
Gui, Add, Button				,%	"xp+151								y" heigth-30 "	w150		h25	gb_movimento	vmov												", Evento devido a...
Gui, Add, Button				,%	"xp+151								y" heigth-30 "	w150		h25	gb_inibir				vini													", Inibir eventos
Gui, Add, Button				,%	"xp+702								y" heigth-130 "	w260		h21								vbText	Center				Hidden	", % "Inibir " StrReplace(file[3],".jpg") " por:"
Gui, Add, DropDownList	,%	"xp										yp+20					w260		h30								vinibe		Choose2	r7	Hidden	", 15 Minutos|30 Minutos|45 Minutos|60 Minutos|120 Minutos|180 Minutos|240 Minutos
Gui, Add, Button				,		xp										yp-20					w260		h21								vbMot	Center				Hidden	,  Escolher motivo do movimento no local:
Gui, Add, DropDownList	,%	"xp										yp+20					w260		h30	gmoti					vmoti		Choose1	r7	Hidden	", |Animais no local|Veículos passando na parte externa|Chuva e/ou relâmpagos|Colaboradores trabalhando no local|Insetos ou poeira em frente a câmera|Fonte de luz incidindo sobre a câmera
Gui, Add, Button				,%	"xp										y" heigth-30 "	w260		h25	gConfirmar		vconf								Hidden	", Confirmar
Gui, Font, S15 Bold
Gui, Add, Text						,%	"x10									y0																						cGreen							", % StrReplace(file[3],".jpg") " - "	hora " "
;~ Gui, Add, Text						,%	"x10									y725				w600											vpassed	cRed								"
Gui, Font
GuiControl,, Pic					,%	"																	*w1260	*h720 " fullfile
Gui, Color, 000000, FFFFFF
Gui,	-Border	+AlwaysOnTop
Gui, +ToolWindow
Gui, Show , x0 y0 w1275 h%heigth%, Detecção de Movimento	;}
return	;}

moti:	;{
Gui,	Submit,	NoHide
GuiControl,	,	motivo,	%moti%
return	;}

sql:				;{
	encerra	:=	SubStr(A_Now,7,2) "/" SubStr(A_Now,5,2) "/" SubStr(A_Now,1,4) " " SubStr(A_Now,9,2) ":" SubStr(A_Now,11,2) ":" SubStr(A_Now,13,2)
	if	(	inibidor	=	1	)
	{
		campo1	:=	StrReplace(file[3],".jpg")
		campo2	:=	data " " hora
		campo3	:=	displayed
		campo4	:=	encerra
		campo5	:=	ip
		campo6	:=	StrReplace(mfile,".jpg")
		campo7	:=	"Inibido - " inibe
		campo8	:=	motivo
		campo9	:=	arquivo1
		inibidor = 0
		;~ gosub timer
	}
	if	(	ocorrencia	=	1	)
	{
		campo1	:=	StrReplace(file[3],".jpg")
		campo2	:=	data " " hora
		campo3	:=	displayed
		campo4	:=	encerra
		campo5	:=	ip
		campo6	:=	StrReplace(mfile,".jpg")
		campo7	:=	"Ocorrência"
		campo8	:=	motivo
		campo9	:=	arquivo1
		ocorrencia = 0
		;~ gosub timer
	}
	finaliza	=
	(
	INSERT INTO [MotionDetection].[dbo].[Encerrados]
		([Camera] ,[Gerado] ,[Exibido] ,[Finalizado] ,[Computador] ,[Imagem] ,[Ocorrido] ,[Descricao],[IP])
	VALUES
		('%campo1%','%campo2%' ,'%campo3%' ,'%campo4%' ,'%campo5%','%campo6%','%campo7%','%campo8%','%campo9%')
	)
	Log	:=	adosql(con,finaliza)
return	;}

timer:			;{	insere no banco evento não finalizado em 10 minutos
encerra		:=	StrReplace(StrReplace(StrReplace(encerra," "),":"),"/")
passados	:=	((SubStr(encerra,9,2)*60*60)+(SubStr(encerra,11,2)*60)+SubStr(encerra,13,2))-((SubStr(display,9,2)*60*60)+(SubStr(display,11,2)*60)+SubStr(display,13,2))
if (	passados > "600"	)
{
	excedeu	=
	(
	INSERT INTO [MotionDetection].[dbo].[Demora no Encerramento]
		([usuario] ,[hora_exibido] ,[hora_finalizado] ,[maquina] ,[data] ,[lanche] ,[segundos_passados])
	VALUES
	('%1%','%2%','%3%','%4%','%5%','%6%','%7%')
	)
}
return	;}

;~ passou:	;{
;~ Gui, Submit, NoHide
;~ horas	=	0
;~ minutos =	0
;~ display	:=	StrReplace(StrReplace(StrReplace(displayed," "),":"),"/")
;~ passados	:=	((SubStr(A_Now,9,2)*60*60)+(SubStr(A_Now,11,2)*60)+SubStr(A_Now,13,2))-((SubStr(display,9,2)*60*60)+(SubStr(display,11,2)*60)+SubStr(display,13,2))
;~ minutos	:=	Floor(passados / 60)
;~ horas		:=	Floor(minutos / 60)
;~ segundos	:=	passados - (minutos*60)
;~ if	(segundos < 10)
	;~ segundos	:=	"0" segundos
;~ if	(minutos < 10)
	;~ minutos	:=	"0" minutos
;~ if	(horas < 10)
	;~ horas	:=	"0" horas
;~ GuiControl,	,	passed,	% "Tempo sem finalizar: " horas	":" minutos ":" segundos
;~ return	;}

sistema:		;{
return	;}

GuiClose:
ExitApp