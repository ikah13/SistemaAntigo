;@Ahk2Exe-SetMainIcon	C:\Dih\zIco\2sm.ico
istest	=	0
salvar	=	1
version	=	2.6.0
#include	header.ahk
Menu,	Tray,	Icon
Gui	+LastFound	+AlwaysOnTop	-Caption	+ToolWindow	
Gui,	Font,	s25	cFFFFFF
Gui,	Color,	000000
Gui,	Add,	Text,	Center	,	Sistema Monitoramento`n%version%
Gui,	Show,	x0	y0	NoActivate
;{	Copia	arquivos	necessários	para	rodar
FileCopy,		\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\update.exe,					C:\Seventh\backup\update.exe,				1
if	(	ip4	=	171	or	ip4	=	175	or	ip4	=	178	or	ip4	=	163	or	ip4	=	167	or	ip4	=	184	)
{
	FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\map\*.jpg,					C:\Seventh\backup\map,							1
	IfNotExist,	C:\Dguard Advanced\Agenda_user.exe
	{
		Process,	Close,	Agenda_user.exe
		FileCopy,\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\Agenda_user.exe,		C:\Dguard Advanced\Agenda_user.exe,	1
	}
	IfNotExist,	C:\Dguard Advanced\MDAge.exe
	{
		Process,	Close,	MDAge.exe
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\MDAge.exe,			C:\Dguard Advanced\MDAge.exe,			1
	}
	IfNotExist,	C:\Dguard Advanced\MDCol.exe
	{
		Process,	Close,	MDCol.exe
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\MDCol.exe,				C:\Dguard Advanced\MDCol.exe,			1
	}
	IfNotExist,	C:\Dguard Advanced\MDKah.exe
	{
		Process,	Close,	MDKah.exe
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\MDKah.exe,			C:\Dguard Advanced\MDKah.exe,			1
	}
	IfNotExist,	C:\Dguard Advanced\MDMail.exe
	{
		Process,	Close,	MDMail.exe
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\MDMail.exe,			C:\Dguard Advanced\MDMail.exe,			1
	}
	IfNotExist,	C:\Dguard Advanced\MDMapas.exe
	{
		Process,	Close,	MDMapas.exe
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\MDMapas.exe,		C:\Dguard Advanced\MDMapas.exe,		1
	}
	IfNotExist,	C:\Dguard Advanced\MDRam.exe
	{
		Process,	Close,	MDRam.exe
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\MDRam.exe,			C:\Dguard Advanced\MDRam.exe,			1
	}
	if	(	ip4	=	184	)
	{
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\AutAdd.exe,			C:\Dguard Advanced\AutAdd.exe,			1
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\AutRem.exe,			C:\Dguard Advanced\AutRem.exe,			1
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\RespAdd.exe,			C:\Dguard Advanced\RespAdd.exe,		1
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\RespDel.exe,			C:\Dguard Advanced\RespDel.exe,			1
		FileCopy,	\\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\LembEdit.exe,			C:\Dguard Advanced\LembEdit.exe,		1
	}
}
;}
;{	Definições	Gerais	do	Software
SetTitleMatchMode,	2
SetTitleMatchMode,	Slow
SetNumLockState,	AlwaysOn
FileEncoding,				UTF-8
if	(	ip4	=	171	or	ip4	=	175	or	ip4	=	178	or	ip4	=	163	or	ip4	=	167	)	;	Executa agenda e detecção de movimento
{
	Run,	C:\Dguard Advanced\MDKah.exe
	Run,	C:\Dguard Advanced\MDAge.exe
}
;}
;{	Área	destinada	a	timers
if	(	ip4	!=	184	)
{
	SetTimer,	Move_Janelas_Dguard,	1000
	SetTimer,	timerms,							50
	SetTimer,	RestauroAutomático,	1000
	SetTimer,	check_update,				60000
}
SetTimer,		guid,								5000
;}
;{	TrayMenu
Menu,	Tray,	Color,	%bggui%
if	(	A_UserName	!=	"dsantos"	)
	Menu,	Tray,	NoStandard
if	(	ip4	=	184	or	A_UserName	=	"dsantos"	)
{
	Menu,	s_resp,	Add,	Adicionar Responsáveis,							add_responsavel
	Menu,	s_resp,	Add,	Remover Responsáveis,							del_responsavel
	Menu,	s_resp,	Add,	Adicionar Autorizado,								add_autorizado
	Menu,	s_resp,	Add,	Remover Autorizado,								rem_autorizado
	Menu,	s_resp,	Add,	Editar Lembretes e Dados da Unidade,	edi_lembrete
	Menu,	s_resp,	Color,	%bggui%																								;	Tree Color
	Menu,	Tray,		Add,	Editar Unidades,	:s_resp
	;~ Menu,	Tray,		Add,	Responder Dúvidas,	ASAC
}
if	(	ip4	=	171	or	ip4	=	175	or	ip4	=	178	or	ip4	=	163	or	ip4	=	167	or	ip4	=	184	or	A_UserName	=	"alberto"	or	A_UserName	=	"llopes"	or	A_UserName	=	"dsantos"	)
{
Menu,	Tray,	add
Menu,	Tray,	add,		Relatórios e E-Mail's,		Rel_Mail
Menu,	Tray,	add,		Ramais,								Ramais
Menu,	Tray,	add,		Contatos,							Colaboradores
Menu,	Tray,	add,		Responsáveis e Mapas,		Mapas	
Menu,	Tray,	add
Menu,	Tray,	Tip,		Sistema Monitoramento - %version%
;{	ìcones
if	(	ip4	=	184	or	A_UserName	=	"dsantos"	)
{
	Menu,	s_resp,	Icon,	Adicionar Responsáveis,							C:\Dih\zIco\2useradd.ico
	Menu,	s_resp,	Icon,	Remover Responsáveis,							C:\Dih\zIco\2userdel.ico
	Menu,	s_resp,	Icon,	Adicionar Autorizado,								C:\Dih\zIco\2autadd.ico
	Menu,	s_resp,	Icon,	Remover Autorizado,								C:\Dih\zIco\2autdel.ico
	Menu,	s_resp,	Icon,	Editar Lembretes e Dados da Unidade,	C:\Dih\zIco\2LembEdit.ico
	Menu,	Tray,		Icon,	Editar Unidades,										C:\Dih\zIco\2doubt.ico
	
}
Menu,		Tray,		Icon,	Responsáveis e Mapas,								C:\Seventh\Backup\ico\2resp.ico
Menu,		Tray,		Icon,	Relatórios e E-Mail's,								C:\Seventh\Backup\ico\2mail.ico
Menu,		Tray,		Icon,	Ramais,														C:\Seventh\Backup\ico\2ramais.ico
Menu,		Tray,		Icon,	Contatos,													C:\Seventh\Backup\ico\2contatos.ico
}
else
	Menu,	Tray,	Tip,	Sistema Monitoramento - %version%
;}
;}
;{	Atalhos	
Gui,	Destroy	;	Finaliza o gui de loading
^!End::			;{
ExitApp	;}
^F10::				;{
	Run,	C:/Dguard Advanced/Agenda.exe
return	;}
F10::				;{
	Run,	C:/Dguard Advanced/Agenda_user.exe
return	;}
^ins::				;{
	InputBox,	pass,	Comando Sistema Monitoramento,	,	HIDE
	if	pass	=	
		return
	if	pass	=	close	;{
	{
		Process,	Close,														ddguard.exe
		ToolTip,	Aguardando ddguard.exe encerrar
		Process,	WaitClose,												ddguard.exe
		ToolTip
		ExitApp
	}	;}
	if	pass	=	debug	;{
	{
		ListVars
		return
	}
		;}
	if	pass	=	sadmin	;{
		SetEnv,	x1,	A
	if	x1	!=
	{
		FileMove,	%repositorio%registros\%x1%%A_IPAddress1%.reg,	%repositorio%Registros\%A_IPAddress1%\%x1%%A_IPAddress1% - %A_DD%-%A_MM%-%A_YYYY% %A_Hour%_%A_Min%_%A_Sec%.reg
		run,	cmd.exe /c "reg export HKCU\Software\Seventh\DGuardCenter %repositorio%registros\%x1%%A_IPAddress1%.reg /y"
		Sleep,	500
		run,	cmd.exe /c "reg export HKEY_CURRENT_USER\Software\Seventh\DGuardCenter %repositorio%registros\%x1%%A_IPAddress1%.reg /y"
		x1	=
		pass	=	
		return
	}
	;}
	if	pass	=	noite	;{
	{
		FileMove,	%repositorio%registros\%x1%%A_IPAddress1%.reg,	%repositorio%Registros\Noite\older\%A_IPAddress1% - %A_DD%-%A_MM%-%A_YYYY%	%A_Hour%_%A_Min%_%A_Sec%.reg
		run,	cmd.exe /c "reg export HKCU\Software\Seventh\DGuardCenter %repositorio%registros\Noite\%A_IPAddress1%.reg /y"
		Sleep,	500
		run,	cmd.exe /c "reg export HKEY_CURRENT_USER\Software\Seventh\DGuardCenter %repositorio%registros\Noite\%A_IPAddress1%.reg /y"
		x1	=
		pass	=	
		return
	}
	;}
	if	pass	=	dia	;{
	{
		FileMove,	%repositorio%registros\%x1%%A_IPAddress1%.reg,	%repositorio%Registros\Dia\older\%A_IPAddress1% - %A_DD%-%A_MM%-%A_YYYY% %A_Hour%_%A_Min%_%A_Sec%.reg
		run,	cmd.exe /c "reg export HKCU\Software\Seventh\DGuardCenter %repositorio%registros\Dia\%A_IPAddress1%.reg /y"
		Sleep,	500
		run,	cmd.exe /c "reg export HKEY_CURRENT_USER\Software\Seventh\DGuardCenter %repositorio%registros\Dia\%A_IPAddress1%.reg /y"
		x1	=
		pass	=	
		return
	}
	;}
	if	pass	=	todas	;{
	{
		FileMove,	%repositorio%registros\%x1%%A_IPAddress1%.reg,	%repositorio%Registros\Todas\older\%A_IPAddress1% - %A_DD%-%A_MM%-%A_YYYY% %A_Hour%_%A_Min%_%A_Sec%.reg
		run,	cmd.exe /c "reg export HKCU\Software\Seventh\DGuardCenter %repositorio%registros\Todas\%A_IPAddress1%.reg /y"
		Sleep,	500
		run,	cmd.exe /c "reg export HKEY_CURRENT_USER\Software\Seventh\DGuardCenter %repositorio%registros\Todas\%A_IPAddress1%.reg /y"
		x1	=
		pass	=	
		return
	}
	;}
	if	pass	=	reload	;{
		Reload
		;}
	else
		MsgBox,	,Comando Inexistente,	Este comando não existe = %pass%
		pass	=
	return
;}
^g::					;{	REFAZER
	yger	=	0
	IfWinNotActive,	ahk_group ahk_class TfmGerenciador
	{
	WinShow,	ahk_class TfmGerenciador
	if	(	ip4	=	"175"	||	ip4	=	"178"	||	ip4	=	"163"	||	ip4	=	"167"	||	ip4	=	"171"	)
	yger	:=	"-1800"
	WinMove,		ahk_class TfmGerenciador,	,		5,	%yger%
	WinActivate,	ahk_class TfmGerenciador
	WinMove,		ahk_class TfmAutenticacao,	,		400,	%yger%
	WinMove,		ahk_class TfmConfigSistema,	,	400,	%yger%
	WinMove,		ahk_class TfmUsuarios,	,				400,	%yger%
	WinMove,		ahk_class TfmAvisos,	,					400,	%yger%
	WinMove,		ahk_class TfmConfigLegenda,	,	400,	%yger%
	}
	else
	{
	WinHide,		ahk_class TfmGerenciador
	WinMove,		ahk_class TfmGerenciador,	,		5,	%yger%
	WinMove,		ahk_class TfmAutenticacao,	,		400,	%yger%
	WinMove,		ahk_class TfmConfigSistema,	,	400,	%yger%
	WinMove,		ahk_class TfmUsuarios,	,				400,	%yger%
	WinMove,		ahk_class TfmAvisos,	,					400,	%yger%
	WinMove,		ahk_class TfmConfigLegenda,	,	400,	%yger%
	}
	return
;}
^u::					;{
	update:
	ToolTip,	update em andamento
	q_updt	=
		(	
			UPDATE	[Sistema_Monitoramento].[dbo].[Versao e Update]	SET	[update]	=	'nao',	[versao]	=	'%version%'	WHERE	IP	=	'%ip4%'
		)
	gup	:=	ADOSQL(con,q_updt)
	ToolTip,	sql ok
	Settimer,	timerms,	99999999
	FileCopy,	%repositorio%update.exe,	C:\Seventh\backup\update.exe,	1
	if	(ErrorLevel	=	1)
		erro	=	Cópia do "Update.exe" falhou!
	else
		erro	=	Cópia do "Update.exe" finalizado!
	ToolTip,	%erro%
	Process,	Close,	MDkah.exe
	WinGet,	PID,	PID,	MDkah.exe
	Process,	Close,	%PID%
	Process,	Close,	ddguard.exe
	WinGet,	PID,	PID,	ddguard.exe
	Process,	Close,	%PID%
	ToolTip,	Iniciando!
	Run,		C:\Seventh\backup\update.exe
		ExitApp
;}
^b::					;{
	if	(	ip4	=	184	or	A_UserName	=	"alberto"	or	A_UserName	=	"llopes"	)
		return
	goto,	RestauroDguard
	;}
^Numpad1::	;{
	if	(	ip4	=	184	)
		return
	goto,	dia
	;}
^Numpad2::	;{
	if	(	ip4	=	184	)
		return
	goto,	noite
	;}

;~	^Numpad0::	;{
	;~	if	(	ip4	=	184	)
		;~	return
	;~	goto,	todas
	;}

;}
;{	Funções
add_responsavel:			;{
Run,	C:\Dguard Advanced\RespAdd.exe
return	;}
del_responsavel:				;{
Run,	C:\Dguard Advanced\RespDel.exe
return	;}
edi_lembrete:					;{
Run,	C:\Dguard Advanced\LembEdit.exe
return	;}
add_autorizado:				;{
Run,	C:\Dguard Advanced\AutAdd.exe	
return	;}
rem_autorizado:				;{
Run,	C:\Dguard Advanced\AutRem.exe
return	;}
adicionar_email:				;{
Run,	C:\Dguard Advanced\Agenda.exe
return	;}

check_update:					;{
if	(	A_UserName	=	"alberto"	or	A_UserName	=	"dsantos"	or	A_UserName	=	"llopes"	)
	return
q_up	=
(
	SELECT	*	FROM	[Sistema_Monitoramento].[dbo].[Versao e Update]	WHERE	IP	=	'%ip4%'
)
up		:=	ADOSQL(con,q_up)
vers		:=	up[2,3]
updt	:=	up[2,2]
if	(	updt	!=	"nao"	or	vers	!=	version	)
	goto	update
return	;}

Sistema:							;{
if	(	ip4	=	184	)
	return
Process,	Exist,	DDguard Player.exe
if	!Errorlevel	
	ExitApp
return
	;}
SAC:								;{
Run,	C:\Dguard Advanced\MDSac.exe
return
;}
ASAC:								;{
Run,	C:\Dguard Advanced\MDDoubt.exe
return
;}
Rel_Mail:							;{
Run,	C:\Dguard Advanced\MDMail.exe
return	;}
Colaboradores:				;{
Run,	C:\Dguard Advanced\MDCol.exe
return	;}
Mapas:							;{
	Run,	C:\Dguard Advanced\MDResp.exe
	return
;}
Ramais:							;{
Run,	C:\Dguard Advanced\MDRam.exe
return
;}
errorexe:							;{
if	ErrorLevel	=	ERROR
	MsgBox,	,	Sistema Monitoramento,	Programa não instalado no seu sistema.	Informar aos facilitadores o que estava tentando abrir =]
return	;}
Move_Janelas_Dguard:	;{
yger	=	0
if	(	A_UserName	=	"alberto"		or	A_UserName	=	"llopes")
	return
if	(	ip4	=	"175"	||	ip4	=	"178"	||	ip4	=	"163"	||	ip4	=	"167"	||	ip4	=	"171"	)
	yger	:=	"-1800"
if	(	ip4	=	"180")
	yger	:=	"-900"
WinMove,	ahk_class TfmGerenciador,	,		5,		%yger%
WinMove,	ahk_class TfmAutenticacao,	,		400,	%yger%
WinMove,	ahk_class TfmConfigSistema,	,	400,	%yger%
WinMove,	ahk_class TfmUsuarios,	,				400,	%yger%
WinMove,	ahk_class TfmAvisos,	,					400,	%yger%
WinMove,	ahk_class TfmConfigLegenda,	,	400,	%yger%
IfWinExist,	Disparo
	SoundPlay,	C:\Iris10\Sons\police.wav,	1
return	;}

timerms:							;{
IfWinExist,	Selecione o tema de sua preferência	;{
	WinClose,	Selecione o tema de sua preferência	;}
if	(	A_UserName	=	"dsantos")	;{
	return	;}
IfWinExist,	Disparo	;{
{
	WinSet,	AlwaysOnTop,	On,	Disparo
	WinSet,	Style,	-0xC00000,	Disparo
	WinGetPos,	x,	y,	,	,	Disparo
	WinMove,	Disparo,	,	%x%,	%y%,	463,	135
}	;}


ifWinExist,	DDguard Player.exe	;{
{
	WinActivate,	DDguard Player.exe
	ControlGetText,	couldnot	,	static1,	DDguard Player.exe
	IfInString,	couldnot,	Could
	{
	ControlClick,	Button2,	DDguard Player.exe,	,	Left
	Send,	{tab}{Enter}
	WinClose,	DDguard Player.exe
	}
}
return	;}

;}
;}


;{	Restauração	do	D-Guard
RestauroAutomático:	;{
if	(	A_UserName	=	"alberto"	or	A_UserName	=	"dsantos"		or	A_UserName	=	"llopes")
	return
if	(A_Hour	=	horareset1	&&	A_Min	=	minutoreset	&&	A_Sec	=	01	)	{
	Gui,	reset:Destroy
	gosub	RestauroDguard
	Sleep	30000
	goto	update
}
else	if	(A_Hour	=	horareset2	&&	A_Min	=	minutoreset	&&	A_Sec	=	01	)	{
	Gui, reset:Destroy
	gosub	RestauroDguard
	Sleep	30000
	goto	update
}
return
;}

RestauroDguard:			;{
	BlockInput,	on
	Random,		soundvol,	15,	22
	SoundSet,		%soundvol%
	Process,			Close,	WatchdogServices.exe
	Process,			Close,	Watchdog.exe
	Process,			Close,	DGuard.exe
	Process,			Close,	Player.exe
	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\Software\Seventh\DGuardCenter /f"
	Run,	cmd.exe /c "reg delete HKCU\Software\Seventh\DGuardCenter /f"
	Sleep,	500
	Run,	cmd.exe /c "reg import %repositorio%registros\A%A_IPAddress1%.reg"
	
	Sleep,	2000
	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\SOFTWARE\Seventh\DGuardCenter\ImageOSDWriter /f"
	Run,	cmd.exe /c "reg delete HKCU\Seventh\DGuardCenter\ImageOSDWriter /f"
	Sleep,	250
	Run,	cmd.exe /c "reg import %repositorio%registros\padrão\L.reg"
	
	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\Software\Seventh\DGuardCenter\SmtpClient /f"
	Run,	cmd.exe /c "reg delete HKCU\Software\Seventh\DGuardCenter\SmtpClient /f"
	Sleep,	250
	Run,	cmd.exe /c "reg import %repositorio%registros\padrão\smtp.reg"

	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\Software\Seventh\DGuardCenter\Usuarios /f"
	Run,	cmd.exe /c "reg delete HKCU\Software\Seventh\DGuardCenter\Usuarios /f"
	Sleep,	250
	Run,	cmd.exe /c "reg import %repositorio%registros\padrão\U.reg"

	Sleep,	250
	Run,	C:\Seventh\DGuardCenter\DGuard.exe
	Sleep	500
	BlockInput,	off
	return	;}
	
dia:								;{
	BlockInput,	on
	Random,	soundvol,	15,	22
	SoundSet,	%soundvol%
	Process,	Close,	WatchdogServices.exe
	Process,	Close,	Watchdog.exe
	Process,	Close,	DGuard.exe
	Process,	Close,	Player.exe
	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\Software\Seventh\DGuardCenter /f"
	Run,	cmd.exe /c "reg delete HKCU\Software\Seventh\DGuardCenter /f"
	Sleep,	500
	Run,	cmd.exe /c "reg import %repositorio%registros\Dia\%A_IPAddress1%.reg"
	
	Sleep,	2000
	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\SOFTWARE\Seventh\DGuardCenter\ImageOSDWriter /f"
	Run,	cmd.exe /c "reg delete HKCU\Seventh\DGuardCenter\ImageOSDWriter /f"
	Sleep,	250
	Run	cmd.exe /c "reg import %repositorio%registros\padrão\L.reg"
	
	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\Software\Seventh\DGuardCenter\SmtpClient /f"
	Run,	cmd.exe /c "reg delete HKCU\Software\Seventh\DGuardCenter\SmtpClient /f"
	Sleep,	250
	Run,	cmd.exe /c "reg import %repositorio%registros\padrão\smtp.reg"

	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\Software\Seventh\DGuardCenter\Usuarios /f"
	Run,	cmd.exe /c "reg delete HKCU\Software\Seventh\DGuardCenter\Usuarios /f"
	Sleep,	250
	Run,	cmd.exe /c "reg import %repositorio%registros\padrão\U.reg"

	Sleep,	250
	Run,	C:\Seventh\DGuardCenter\DGuard.exe
	Sleep	500
	BlockInput,	off
	return	;}
	
noite:							;{
	BlockInput,	on
	Random,	soundvol,	15,	22
	SoundSet,	%soundvol%
	Process,	Close,	WatchdogServices.exe
	Process,	Close,	Watchdog.exe
	Process,	Close,	DGuard.exe
	Process,	Close,	Player.exe
	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\Software\Seventh\DGuardCenter /f"
	Run,	cmd.exe /c "reg delete HKCU\Software\Seventh\DGuardCenter /f"
	Sleep,	500
	Run,	cmd.exe /c "reg import %repositorio%registros\Noite\%A_IPAddress1%.reg"
	
	Sleep,	2000
	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\SOFTWARE\Seventh\DGuardCenter\ImageOSDWriter /f"
	Run,	cmd.exe /c "reg delete HKCU\Seventh\DGuardCenter\ImageOSDWriter /f"
	Sleep,	250
	Run,	cmd.exe /c "reg import %repositorio%registros\padrão\L.reg"
	
	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\Software\Seventh\DGuardCenter\SmtpClient /f"
	Run,	cmd.exe /c "reg delete HKCU\Software\Seventh\DGuardCenter\SmtpClient /f"
	Sleep,	250
	Run,	cmd.exe /c "reg import %repositorio%registros\padrão\smtp.reg"

	Run,	cmd.exe /c "reg delete HKEY_CURRENT_USER\Software\Seventh\DGuardCenter\Usuarios /f"
	Run,	cmd.exe /c "reg delete HKCU\Software\Seventh\DGuardCenter\Usuarios /f"
	Sleep,	250
	Run,	cmd.exe /c "reg import %repositorio%registros\padrão\U.reg"

	Sleep,	250
	Run,	C:\Seventh\DGuardCenter\DGuard.exe
	Sleep	500
	BlockInput,	off
	return	;}
	;}
;{	Guid	
guid:	;{
Gui,	Destroy
SetTimer,	guid,	off
return
;}	