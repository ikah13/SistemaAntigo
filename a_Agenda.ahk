istest = 0
;@Ahk2Exe-SetMainIcon C:\Dih\zIco\2Agenda.ico
#Include	header.ahk
Menu Tray,	Tip,	Agendamento e Inserção de E-mails
global ret


if	istest = 1	;{
{
user	:=	A_UserName
goto Gui
}	;}
else
{	;{
Gui, Color,				%bggui%
Gui, Color,																						, %bgctrl%
Gui, Add, Text,		x10	y10		w80		h20									, Usuário
Gui, Add, Text,		x10	y30		w80		h20									, Senha
Gui, Add, Edit,		x90	y10		w140	h20		vuser					
Gui, Add, Edit,		x90	y30		w140	h20		vpass	Password	
Gui, Add, Button,	x10	y50		w221	h30					gok			, Ok
Gui, Show,																						, Login Cotrijal
}
return	;}
ok:	;{
Gui,	Submit, NoHide
LogonUser(user,"cotrijal.local", pass)
if	(	ret	=	1	)
	goto	Gui
else
	MsgBox ,,Falha no login, Senha ou Usuário inválidos!
Reload	;}

gui:	;{
Gui, Destroy
Gui, Color,		%bggui%
Gui, Color,	,	%bgctrl%
Gui,	Add,	Text,					x10		y0			w410	h30		0x1201	Section								,	ADICIONAR E-MAIL
Gui,	Add,	DateTime,			x10		yp+40		w200	h30		gDC			v_date	hwndHdate			,	dd/MM/yyyy HH:mm:ss
Gui,	Add,	Text,					x230	yp			w190	h30		0x1201	v_user									,	%user%
Gui,	Add,	Text,					x10		yp+40		w100	h20		0x1200												,	Unidade	:
Gui,	Add,	DropDownList,	x120	yp			w300	R25						v_uni
Gui,	Add,	Edit,					x10		yp+30		w410	h280					v_text
Gui,	Add,	CheckBox,			x10		yp+280	w190	h30		Checked	v_notify								,	Notificar operador 10 Minutos antes
Gui,	Add,	Button,				x220	yp			w200	h30												g_add			,	Adicionar
Gui,	Add,	ListView,							ys				w600	h220	AltSubmit	v_lv				g_lv2			,	Unidade|Mensagem|idavisos
Gui,	Add,	Edit,								yp+221	w600	h170						vshowbox
Gui,	Add,	Button,							yp+170	w600	h30												gfilllv			,	Recarregar Avisos
gosub	filllv
Menu, menudecontexto, Add, Excluir, Exclude
Gui,	Show,,	Adicionar E-Mail
gosub	ddl
return	;}



filllv:	;{
LV_Delete()
f	=
(
	SELECT TOP 10	p.Mensagem, c.Nome,	p.QuandoGerou, p.Idaviso,	p.IdCliente
	FROM [IrisSQL].[dbo].[Agenda] p
	LEFT JOIN [IrisSQL].[dbo].[Clientes] c ON p.IdCliente = c.IdUnico
	ORDER BY 3 DESC
)
fg	:=	adosql(con,f)
Loop,	% fg.MaxIndex()-1
	LV_Add("",fg[A_Index+1,2],fg[A_Index+1,1],fg[A_Index+1,4])
LV_ModifyCol(1)
LV_ModifyCol(2,400)
LV_ModifyCol(3,0)
return	;}

_lv2:	;{
if A_GuiEvent = Normal
{
	LV_GetText(_lv, A_EventInfo, 2)
	Loop
	{
		edb := RegExReplace(_lv, "\R+\R", "`r`n ")
		if ErrorLevel = 0
			break
	}
	GuiControl,	,	showbox,	%	_lv
}
return	;}

GuiContextMenu:	;{
if (A_GuiControl != "_lv")
	return
lastline	:=	A_EventInfo 
Menu, menudecontexto, Show, %A_GuiX%, %A_GuiY%
return	;}

exclude:	;{
Gui,	Submit,	NoHide
LV_GetText(msg, lastline,2)
LV_GetText(idremove, lastline,3)
MsgBox,	1,	Exclusão de Evento,	Deseja realmente excluir o seguinte evento:`n`n`n"%msg%"
IfMsgBox,	No
	return
else
{
d	=
(
	DELETE  FROM [IrisSQL].[dbo].[Agenda]
	WHERE Idaviso = '%idremove%'
)
dd	:=	adosql(con,d)
MsgBox Deletado com sucesso
}
LV_Delete()
goto filllv
;}
_add:	;{
Gui,	Submit,	NoHide
if	(	_text = ""	)
{
	MsgBox Você precisa adicionar algum texto para poder salvar!
	return
}
if	(	_uni = ""	)
{
	MsgBox Você precisa selecionar uma unidade para poder salvar!
	return
}
Loop
	{
		_text := RegExReplace(_text, "\R+\R", "`r`n ")
		if ErrorLevel = 0
			break
	}
Loop, parse, forid,  `n, `r
{
	IfInString, A_LoopField, %_uni%
	{
		IfNotInString,	A_LoopField,	Sede -
		{
			iduni	:=	StrSplit(A_LoopField,"-")
			idu		:=	iduni[2]
			op		:=	iduni[3]
			cli		:=	iduni[4]
		}
		else
		{
			iduni	:=	StrSplit(A_LoopField,"-")
			idu		:=	iduni[3]
			op		:=	iduni[4]
			cli		:=	iduni[5]
		}
	}
}
FormatTime, _data, % Substr(_date,1,8), yyyy-MM-dd
FormatTime, _hora, % Substr(_date,1,8) Substr(_date,9,6), HH:mm:ss.000
FormatTime, agora, %A_Now%, yyyy-MM-dd HH:mm:ss.000
dataagendado	:=	 _data " " _hora
IfInString,	_text, '
	_text	:=	StrReplace(_text,"'","’")
MsgBox,	0x1, Confirmar inserção de E-Mail, `tConfirma adicionar os seguintes dados no sistema?`n`nOperador:	%op%`nMensagem:`n---------`n`t%_text%`n---------`nInserido em:	%agora%`nCliente:	%cli%`nAgendado para:	%dataagendado%`nInserido por:	%user%
IfMsgBox Cancel
{
	GuiControl, Focus, _text
	return
}
Ins	=	
(
INSERT INTO [IrisSQL].[dbo].[Agenda]
([Assunto],[Mensagem],[TipoInfo],[SistemaGerou],[EstacaoGerou],[QuandoGerou],[Cliente],[Contrato],[Quandoavisar],[Usuariogerou],[IdCliente])
VALUES
('%op%','%_text%','1','MO','%A_ComputerName%',convert(datetime,'%agora%',121),'%cli%','1',convert(datetime,'%dataagendado%',121),'%user%','%idu%')
)
insere	:=	adosql(con,ins)
i	=
(
SELECT TOP 1 [Idaviso]
FROM [IrisSQL].[dbo].[Agenda]
ORDER BY 1 DESC
)
id		:=	adosql(con,i)
id		:=	id[2,1]

ins2	=
(
INSERT INTO [IrisSQL].[dbo].[Avisoagenda]
([Fkidaviso],[Dataagendado],[QuemAvisar],[Lembrar])
VALUES
('%id%',convert(datetime,'%dataagendado%',121),'TESTE','%_notify%')
)
insere2	:=	adosql(con,ins2)
Gui, Destroy
goto gui	;}




Sistema: ;{
if (ip4 = 184)
	return
Process, Exist, DDguard Player.exe
if !Errorlevel 
	ExitApp
	return	;}

GuiClose:	;{
ExitApp	;}

DC:	;{
   If !DMC(Hdate)
		Send {Right}
Return	;}

DMC(HWND) {	;{
   Static DTM_GETMONTHCAL := 0x1008
   Return DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", DTM_GETMONTHCAL, "Ptr", 0, "Ptr", 0, "Ptr")
}	;}

ddl:	;{
d	=
(
SELECT		[Nome],[IdUnico],[Classe],[Cliente]
FROM			[IrisSQL].[dbo].[Clientes]
WHERE		[Cliente] = '10001'	AND [Particao] > '001'
ORDER BY	1	ASC
)
u						:=	adosql(con,d)
Loop, % u.MaxIndex()-1
{
	unidade		:=	u[A_Index+1,1]
	IfInString,	unidade,	-
		unidade	:=	StrReplace(unidade,"-"," ")
	unidadeid	:=	u[A_Index+1,2] "-" u[A_Index+1,3] "-" u[A_Index+1,4]
	StringLower, unidade, unidade, T
	unidades	:=	unidades	"|"	unidade	;	ddl
	forid			:=	unidade "-" unidadeid "`n" forid
}

GuiControl, , _uni, %unidades%
return	;}
