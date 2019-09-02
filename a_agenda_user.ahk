;@Ahk2Exe-SetMainIcon C:\Dih\zIco\2Agenda.ico
istest = 0
#Include	header.ahk
Gui,	Font,	S10
Gui, Color,		%bggui%
Gui, Color,	,	%bgctrl%
Gui,	Add,	MonthCal,	%	"x5	y0													w"	A_ScreenWidth/2	"	h"	m_h/4	"	vmcall			g_date"
Gui,	Add,	ListView,		%	"xp	y"m_h/4-10	"								w"	A_ScreenWidth/2	"	h"	m_h/3	"	vlv				g_listview	AltSubmit	Grid"	,	Hora|Unidade|Operador|Unidade
Gui,	Add,	Edit,			%	"xp	y"(m_h/4)+(m_h/3)-5				"	w"	A_ScreenWidth/2	"	h"	m_h/3	"	veditbox"	
Gui,	Add,	Button,		%	"xm															w"	A_ScreenWidth/2-10		"										gGuiClose"									,	Fechar
Gui,	Show,						%	"x0	y0																															h"	m_h														,	Agenda
gosub	carrega_lv
return

_date:	;{
LV_Delete()	;}

carrega_lv:	;{
Gui,	Submit,	NoHide
data	:=	SubStr(mcall,1,4)	"-"	SubStr(mcall,5,2)	"-"	SubStr(mcall,7,2)
sqlv =
(
	SELECT p.IdCliente, p.QuandoAvisar, p.Mensagem, p.Assunto, c.Nome
	FROM [IrisSQL].[dbo].[Agenda] p
	LEFT JOIN [IrisSQL].[dbo].[Clientes] c ON p.IdCliente = c.IdUnico
	WHERE CONVERT(VARCHAR(25), Quandoavisar, 126) like '%data%`%'
	ORDER BY 1 DESC
)
fill	:=	adosql(con,sqlv)
Loop, % fill.MaxIndex()-1
{
	;~ hour	:=	SubStr(fill[A_Index+1,2],12)
	hour	:=	fill[A_Index+1,2]
	oper	:=	fill[A_Index+1,3]
	subj		:=	fill[A_Index+1,4]
	unit		:=	fill[A_Index+1,5]
	StringUpper,	unit,	unit,	T
	LV_Add("",	hour,	oper,	subj,	unit)
}
LV_ModifyCol(1)
LV_ModifyCol(1,Sort)
LV_ModifyCol(2,250)
LV_ModifyCol(3,0)
LV_ModifyCol(4)
return	;}

_listview:	;{
if A_GuiEvent = Normal
{
	LV_GetText(edb, A_EventInfo, 2)
	Loop
	{
		edb := RegExReplace(edb, "\R+\R", "`r`n ")
		if ErrorLevel = 0
			break
	}
	GuiControl,	,	editbox,	%	edb
}
return	;}

GuiClose:	;{
ExitApp	;}

sistema:	;{
return	;}