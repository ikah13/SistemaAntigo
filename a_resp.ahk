;@Ahk2Exe-SetMainIcon C:\Dih\zIco\2resp.ico
soft	=	responsaveis
#Include header.ahk
SetBatchLines, -1

; GUI de SeleÁ„o		;{
Gui, destroy
Gui, Color, 	%bggui%
Gui, Color, , %bgctrl%
Gui, 1:font, bold s10
Gui, 1:Add, Text, x5 y5, 																																				Buscar unidade 
Gui, 1:Add, Text, Section x252 y5
Gui, 1:font
Gui, 1:Add, Edit, x140 yp w109 h20 vb_unidade gUnidades
Gui, 1:Add, ListView, % "xs-252 yp+30  w300 gSelecionaUnidade NoSortHdr 0x3 h"( A_ScreenHeight - 120 ) ,		ID|UNIDADE
Gui, 1:Add, Button, % " x2 w246 gGuiClose h40 y"( A_ScreenHeight - 82 ), 															Fechar
LV_ModifyCol(1, 0)
LV_ModifyCol(2, Center)
gosub Unidades	;18/11/2018
Gui, 1:  -Border
Gui, 1:Show, % "x"( A_ScreenWidth - 256 ) "y0 w250 h"( A_ScreenHeight - 40 ), 													Unidades Cotrijal, GUI-1
GuiControl, 1:Focus, b_unidade
return  ;}
Unidades:				;{	18/11/2018
Gui, 1:submit, nohide
LV_Delete()
do =	;{
(
SELECT *
  FROM [Sistema_Monitoramento].[dbo].[id locais]
  WHERE id = '998' or id = '997' or id = '996' 
  order by 2 asc
)
unidades := ADOSQL(con, do)
Loop, % unidades.MaxIndex()-1
{
	col	:=	A_Index+1
	v1	:=	unidades[col,1]
	v2	:=	unidades[col,2]
	if ( b_unidade != "" )	;	parte da pesquisa din‚mica
	{
		ifinstring, v2, %b_unidade%
			LV_Add("", v1, v2)
	}
	else
		LV_Add("", v1, v2)
}	;}
do2 =	;{
(
SELECT *
  FROM [Sistema_Monitoramento].[dbo].[id locais]
  WHERE (id <> '998' and id <> '997' and id <> '996')
  order by 2 asc
)
unidades2 := ADOSQL(con, do2)
Loop, % unidades2.MaxIndex()-1
{
	col	:=	A_Index+1
	v3	:=	unidades2[col,1]
	v4	:=	unidades2[col,2]
	if ( b_unidade != "" )	;	parte da pesquisa din‚mica
	{
		ifinstring, v4, %b_unidade%
			LV_Add("", v3, v4)
	}
	else
		LV_Add("", v3, v4)
}	;}
return	;}
SelecionaUnidade:	;{	18/11/2018
Gui, 1:Submit, nohide
menos3	=	0
Gui, 2:Destroy
Gui, 3:Destroy
Process, Close, MDMapas.exe
RowNumber	=	0
Loop
{
	RowNumber	:=	LV_GetNext(RowNumber)
	if not RowNumber
		break
	LV_GetText(unidade, RowNumber, 1)
}
tamanho	:=	StrLen(unidade)
if tamanho < 3
{
	unidade := "0" . unidade
	menos3 = 1
}
if	(	unidade	=	"996"	)
	gosub infraestrutura
else if	(	unidade	=	"997"	)
	gosub rastsat
else if	(	unidade	=	"998"	)
	gosub monitoramento
else
	gosub, Responsaveis
return 	;}
Responsaveis:			;{	24/11/2018
direto = 1
gosub Abre_Mail
xx := 2
xlemb = 302
d	=	Disabled
x = `;
id = %unidade%

;{																								Respons·veis
id := LTrim(id, "0")
Gui, 2:Color, %bggui%
Gui, 2:Color, , %bgctrl%
fu =
(
SELECT *
  FROM [Sistema_Monitoramento].[dbo].[contatos]
  WHERE unidade = '%id%'
  ORDER BY ordem asc
)
funcionarios := ADOSQL(con, fu)
colunas := funcionarios.MaxIndex()-1
if ( colunas >9 )
{
	xlemb = 604
}
Loop, % funcionarios.MaxIndex()-1
{
	col	:=	A_Index+1
	b4 =
	b2 =
	b1	:=	funcionarios[col,1]	;	unidade
	b2	:=	funcionarios[col,2]	;	nome(busca do banco cotrijal)
	b3	:=	funcionarios[col,3]	;	matricula
	b4b	:=	funcionarios[col,4]	;	cargo(busca do banco cotrijal)
	b5	:=	funcionarios[col,5]	;	tel 1
	;~ b6	:=	funcionarios[col,6]	;	desc 1
	b7	:=	funcionarios[col,7]	;	tel 2
	;~ b8	:=	funcionarios[col,8]	;	desc 2
	b9	:=	funcionarios[col,9]	;	tel 3
	;~ b10	:=	funcionarios[col,10]	;	desc 3
	b11	:=	funcionarios[col,11]	;	endereco
	b12	:=	funcionarios[col,12]	;	informacao
	b13	:=	funcionarios[col,13]	;	autorizado
	b14	:=	funcionarios[col,14]	;	senha
	b15	:=	funcionarios[col,15]	;	ordem
	if (	b5 = b7	)
		b7 = 
	telefones := b5 "`n" b7 "`n" b9
	if (	b15 = "m"	)
		b16	:=	funcionarios[col,16]	;	lembrete
	is_vacation =
	ivd =
	if ( b4 = "" )
		b4 := b4b
	if(	b3 != ""	)
	{
		v_ferias =
		(
			SELECT SITUACAO, NM_RAZAO_SOCIAL, DN_CARGO, FONE, CELULAR
			FROM CAD_FUNCIONARIOS
			WHERE NUMCAD = '%b3%'
		)
		d_ferias	:= adosql(ora,v_ferias)
		ferias		:= d_ferias[2,1]
		b2 			:= d_ferias[2,2]
		;{	handle cargos
		b4			:= d_ferias[2,3]
		IfInString, b4, de unidade de negocios
			b4 := strreplace(b4,"de unidade de negocios")
		IfInString, b4, unidades
			b4 := strreplace(b4," unidades")
		IfInString, b4, operacionals
			b4 := strreplace(b4," operacionals"," Operacional")
		StringUpper, b4, b4, T
		b4 := strreplace(b4,"Ii","II")
		b4 := strreplace(b4,"Iii","III")
		;}
		StringUpper, b2, b2, T
		gosub ver_situaÁ„o
		if (	ferias = 7	)
			continue
		if (	ferias = 2	)
			isferias = cff0000 bold s9
		else
			isferias = c1b8b11 s8
		is_vacation := situacao
	}
	if (b11 != "")
	{
		uniname := b2
		continue
	}
	if (col = 2)
	{
		Gui, 2:Font, Bold
		Gui,	2:Add,	GroupBox,	x2		y30			w215	h112 Center	Section,	%b4%
		Gui, 2:Font, c0000CD
		Gui,	2:Add,	Text,			xp+5			y45			w205	h20					,	%b2%
		Gui, 2:Font, %isferias%
		Gui,	2:Add,	Text,			xp				y60			w205	h20					,	%is_vacation%
		Gui, 2:Font
		Gui,	2:Add,	Text,			xp+3			y75			w64	h20						,	Telefone 1
		;~ Gui,	2:Add,	Picture,		xp+35			y75		w15	h-1							,	C:\Users\dsantos\Documents\Nova pasta\WorkSpace\OneDrive\Documentos\call.png
		fx := MaskTel(fx)
		if	fx = 
			d = Disabled
		else
			d= Center
					fx = %b5%
		fx := MaskTel(fx)
		if fx = 
			d = Disabled
		else
			d= Center
		Gui,	2:Add,	Edit,			xp+53			y73		w145	h20			%d%		,	%fx%
		Gui,	2:Add,	Text,			xp-53		y95		w64		h20							,	Telefone 2
					fx = %b7%
		fx := MaskTel(fx)
		if fx = 
			d = Disabled
		else
			d= Center
		Gui,	2:Add,	Edit,			xp+53			y93			w145	h20			%d%		,	%fx%
		Gui,	2:Add,	Text,			xp-53			y115		w64		h20								,	Telefone 3
					fx = %b9%
		fx := MaskTel(fx)
		if fx = 
			d = Disabled
		else
			d=
		Gui,	2:Add,	Edit,			xp+53			y113		w145	h20			%d%		,	%fx%
	}
	else
	{
	Gui, 2:Font, Bold
	if ( col =19 )
		break
	if ( col=11)
	{
		xx :=303
		Gui,	2:Add,	GroupBox,		x%xx%		y30			w215	h110		Center	, 	%b4%
	}
	else
		Gui,	2:Add,	GroupBox,		x%xx%			yp+32		w215	h110	Center	, 	%b4%
	Gui, 2:Font, c0000CD
	Gui,	2:Add,	Text,				xp+5			yp+15		w205	h20					,	%b2%
	Gui, 2:Font, %isferias%
	Gui,	2:Add,	Text,				xp				yp+15		w205	h20		Center	, %is_vacation%
	Gui, 2:Font
	Gui,	2:Add,	Text,				xp+3			yp+15		w64		h20					,	Telefone 1
	fx := MaskTel(fx)
		if fx = 
			d = Disabled
		else
			d= Center
				fx = %b5%
	fx := MaskTel(fx)
		if fx = 
			d = Disabled
		else
			d= Center
	Gui,	2:Add,	Edit,				xp+53			yp-2			w145	h20			%d%		,	%fx%
	Gui,	2:Add,	Text,				xp-53		yp+22		w64		h20					,	Telefone 2
				fx = %b7%
	fx := MaskTel(fx)
		if fx = 
			d = Disabled
		else
			d= Center
	Gui,	2:Add,	Edit,				xp+53			yp-2			w145	h20			%d%		,	%fx%
	Gui,	2:Add,	Text,				xp-53		yp+22		w64		h20					,	Telefone 3
				fx = %b9%
	fx := MaskTel(fx) 
		if fx = 
			d = Disabled
		else
			d= Center
	Gui,	2:Add,	Edit,				xp+53			yp-2			w145	h20			%d%		,	%fx%
	}
}
Gui, 2:Font, bold
Gui, 2:Font, s10
Gui,	2:Add,	Text,	x2	y2	w290	h20	,	%uniname% - %unidade%
Gui,	2:Add,	Button,	x252	y0	w250	h25	gAbre_Mapa,	Mapa de Sensores de Alarme
emails := qs.MaxIndex()-1
Gui,	2:Add,	Button,	x502	y0	w200	h25	gAbre_Mail, ( %emails% ) E-Mails ˙ltimos 3 dias
Gui, 2:Font
;}
;{																								Lembretes
Gui, 2:Font, S10
Gui, 2:Font, Bold
Gui,	2:Add,	GroupBox,	xs+%xlemb%	y28			w511	h175	Center	vunin, InformaÁıes da Unidade
Gui, 2:Font
		if ( b11 = "" )
			d = Disabled
			else
			d =
Gui,	2:Add,	Text,			xp+15		yp+30		w64		h20						%d%		,	EndereÁo 1
Gui,	2:Add,	Edit,			xp+65		yp-10		w410	h40						%d%		,	% b11
		if ( b12 = "" )
			d = Disabled
			else
			d =
Gui,	2:Add,	Text,			xp-65		yp+40		w64		h20								,ObservaÁıes
Gui,	2:Add,	Edit,			xp			yp+20		w480	h80						%d%		,	% b12
Gui, 2:Font, S12
Gui, 2:Font, Bold
		if ( b16 = "" )
			d = Disabled
			else
			d =
if (	b16 = ""	)
{
		d	=	Hidden
		ylemb = y-170
}
else
	ylemb = yp+100
Gui,	2:Add,	GroupBox,	xs+%xlemb%	%ylemb%	w511	h366	+Center	%d%,	Lembretes
Gui, 2:Font
Gui,	2:Add,	Edit,			xp+7				yp+20		w497	h338		vf50 %d%	,	%b16%
;}	;}
								;{	Acesso Portıes	14/12/2018
;{																								Gui	Acesso aos portıes
d = Hidden

StringTrimRight, uni, unidade, 1
uni:= LTrim(uni,"0")
aut =
(
	SELECT * FROM [Sistema_Monitoramento].[dbo].[portoes]
	WHERE id = '%uni%'
)
au := ADOSQL(con,aut)
if (au.MaxIndex()-1 != 0)
{
	Gui, 2:Font, bold 
	Gui, 2:Font, s10
	Gui, 2:Add,	GroupBox,	xp-7	yp+355	w511	h345	vbox	Center %d%,	%uniname% - Autorizados
	Gui, 2:Font
	GuiControl, 2:Show, box
	Gui, 2:	Add,	GroupBox,		xp+5	yp			Hidden
	Loop, % au.MaxIndex()-1
	{
		col := A_Index+1
		m := au[col,1]
		d := au[col,2]
		s := au[col,3]
		o := au[col,4]
		orac =
		(
		SELECT NM_RAZAO_SOCIAL
		FROM CAD_FUNCIONARIOS
		WHERE NUMCAD = '%m%'
		AND SITUACAO != '7'
		)
		port := ADOSQL(ora,orac)
		n_col	:=	port[2,1]
		if (	n_col = ""	)
			continue
		StringSplit, cola, n_col, " "
		last := cola%cola0%
		 Loop, % cola0
		{
			if (	A_Index != 1 and A_Index != cola0	)	{
				meio := cola%A_Index%
				mid := SubStr(meio,1,1)
				mi := mi mid ". " 
			}
		}
		n_col := cola1 " " mi last
		StringUpper, n_col, n_col, T
		mi	=
		mid	=
		Gui, 2:	Add,		GroupBox,				xp 			yp+20			w70	h37, 
		Gui, 2:	Add,		Edit,						xp+10		yp+11			w50				h20,	% m
		Gui, 2:	Add,		GroupBox,				xp+60 	yp-11			w175			h37,	
		Gui, 2:	Add,		Edit,						xp+5		yp+11			w160			h20,	% n_col
		vezes ++
		if (	vezes = 10 	)
			Gui, 2:	Add,	Edit,						xp+178 yp-310 Hidden
		else 
			Gui, 2:	Add,	Edit,						xp-75 Hidden
	}
}
;}
vezes =
Gui, 2:Show, x0  y0 NoActivate, Respons·veis
return	;}
Abre_Mapa:			;{	22/12/2018
unidade :=	LTrim(unidade, "0")
Run, MDMapas.exe %unidade%
return
;}
Abre_Mail:				;{
mails = 
unin := substr(unidade,1,2) "0"
q_s = ; select de e-mails e agendamentos
(
DECLARE @idu varchar(max)
SET @idu = (SELECT top 1 IdCliente FROM [IrisSQL].[dbo].[Procedimentos] where Cliente = '10001' AND Particao = '%unin%')
SELECT	[Observacoes_conta] as descricao
				,[Disparo] as Data
				,[IdCliente] as id
FROM [IrisSQL].[dbo].[Procedimentos]
WHERE Observacoes_conta IS NOT NULL
	AND DATALENGTH(Observacoes_conta)<>0
	AND Disparo > DATEADD(HOUR, -72, GETDATE())
	AND Disparo < GETDATE()
	AND IdCliente = @idu
UNION ALL
SELECT	[Mensagem] as descricao
				,[QuandoGerou] as Data
				,[IdCliente] as id
 FROM [IrisSQL].[dbo].[Agenda]
 WHERE Mensagem IS NOT NULL
	AND DATALENGTH(Mensagem)<>0
	AND QuandoGerou > DATEADD(HOUR, -72, GETDATE())
	AND QuandoGerou < GETDATE()
	AND IdCliente = @idu
ORDER BY Data DESC
)
qs := adosql(con,q_s)
if (direto = 1)
{
	direto = 0
	return
}
if (qs.MaxIndex()-1 = "0")
{
	MsgBox N„o h· e-mails para %uniname% nos ˙ltimos 3 dias.
	return
}
Loop, % qs.MaxIndex()-1
{
	col		:=	A_Index+1
	descr	:=	qs[col,1]
	data	:=	qs[col,2]
	mails	:=	mails . data "`n ª`n" descr "`n`n_____________________________________________________________________________________`n"
}
Gui, 3:Color, %bggui%
Gui, 3:Margin, 0, 0
Gui, 3:Add, Text, x25 w400 0x1000 , %mails%
Gui, 3:Add, Button, w100 h18 gOk,OK
Gui, 3:Show, w550, % uniname
Return

Ok:	;{
3GuiClose:
Gui, 3:Destroy
Return	;}	;}
monitoramento:		;{	gui monitoramento
 ;{	body
q =
(
SELECT	NM_RAZAO_SOCIAL ,FONE ,CELULAR ,DN_CARGO,CD_CARGO,SITUACAO
from CAD_FUNCIONARIOS 
WHERE   cd_cargo like '`%344`%' and situacao <> '7'
order by 5 desc, 1 asc
)
query := adosql(ora,q)	;}
;{ definiÁıes
xp = -275
yp = yp+33
Gui,	2:Color, %bggui%	;}
Loop, % query.MaxIndex()-1	;{
{
	col	:=	A_Index+1
	a		:=	query[col,1]
	b		:=	query[col,2]
	d		:=	query[col,3]
	f		:=	query[col,4]
	s		:=	query[col,6]
	dt	:=	SubStr(d,-7)
	bt	:=	SubStr(b,-7)
	if (dt = bt)
		d=
	if(s	!=	1	)
		disabled	=	Disabled
	else
		disabled	=	
	a		:=	MaskName(a)
	b		:=	MaskTel(b)
	d		:=	MaskTel(d)
	StringUpper, f, f, t
	IfInString, f, Agente
		f	:=	strreplace(f,"Agente","Ag.")
	IfInString, f, Monitoramento
		f	:=	strreplace(f,"Monitoramento","Mon.")
	IfInString, f, De
		f	:=	strreplace(f,"De","de")
	Gui,	2:Font, Bold
	if	(	col	=	15	)
	{
		xp = 125
		yp = y30
	}
	if	(	col	>	15	and col < 28	)
	{
		xp	=	-275
		yp	=	yp+33
	}
	if	(	col	=	28	)
	{
		xp = 125
		yp = y30
	}
	if	(	col	>	28	)
	{
		xp = -275
		yp = yp+33
	}
	if	(	col	=	2		)
	{
		Gui,	2:Add,	GroupBox,	x5			y30		w385	h40			%disabled%	,	% a
		Gui,	2:Add,	GroupBox,	x170		yp		w110	h40
		Gui,	2:Add,	GroupBox,	xp-165	yp Hidden
	}
	else
	{
		Gui,	2:Add,	GroupBox,	xp%xp%			%yp%		w385	h40	%disabled%,	% a
		Gui,	2:Add,	GroupBox,	xp+165		yp		w110	h40
		Gui,	2:Add,	GroupBox,	xp-165	yp Hidden
	}
	Gui,	2:Font
	Gui,	2:Color, , %bgctrl%
	Gui,	2:Add,	Text,			xp+15		yp+13	w150	h20					%disabled%,	% f
	Gui,	2:Add,	Text,			xp+155	yp		w100	h20		Center	%disabled%,	% b
	Gui,	2:Add,	Text,			xp+105	yp		w100	h20		Center	%disabled%,	% d
	WinSet, TransColor, Green
}
Gui,	2:Show,x0 y0 NoActivate, Monitoramento
return	;}
;}
rastsat:					;{	gui monitoramento
 ;{	body
 q =
(
SELECT [nome]
      ,[cargo]
      ,[telefone 1]
      ,[telefone 2]
  FROM [Sistema_Monitoramento].[dbo].[contatos]
  where unidade = '999' and ordem <> 'm'
  order by 2 asc
)
query := adosql(con,q)	;}
;{ definiÁıes
xp = -275
yp = yp+33
Gui,	2:Color, %bggui%	;}
Gui,	2:Add,	Text,	x5			y10		w385	h40				,	ID da RASTSAT  = 999
Loop, % query.MaxIndex()-1	;{
{
	col	:=	A_Index+1
	a		:=	query[col,1]
	b		:=	query[col,2]
	c		:=	query[col,3]
	d		:=	query[col,4]
	a		:=	MaskName(a)
	b		:=	MaskName(b)
	c		:=	MaskTel(c)
	d		:=	MaskTel(d)
	Gui,	2:Font, Bold	;{
	if	(	col	=	15	)
	{
		xp = 125
		yp = y30
	}
	if	(	col	>	15	and col < 28	)
	{
		xp	=	-275
		yp	=	yp+33
	}
	if	(	col	=	28	)
	{
		xp = 125
		yp = y30
	}
	if	(	col	>	28	)
	{
		xp = -275
		yp = yp+33
	}
	if	(	col	=	2		)
	{
		Gui,	2:Add,	GroupBox,	x5			y30		w385	h40			%disabled%	,	% a
		Gui,	2:Add,	GroupBox,	x170		yp		w110	h40
		Gui,	2:Add,	GroupBox,	xp-165	yp Hidden
	}
	else
	{
		Gui,	2:Add,	GroupBox,	xp%xp%			%yp%		w385	h40	%disabled%,	% a
		Gui,	2:Add,	GroupBox,	xp+165		yp		w110	h40
		Gui,	2:Add,	GroupBox,	xp-165	yp Hidden
	}
	Gui,	2:Font
	Gui,	2:Color, , %bgctrl%
	Gui,	2:Add,	Text,			xp+15		yp+13	w150	h20					%disabled%,	% b
	Gui,	2:Add,	Text,			xp+155	yp		w100	h20		Center	%disabled%,	% c
	Gui,	2:Add,	Text,			xp+105	yp		w100	h20		Center	%disabled%,	% d
	WinSet, TransColor, Green
}
Gui,	2:Show,x0 y0 NoActivate, Monitoramento
return	;}	;}
;}
infraestrutura:			;{	gui infraestrutura
 ;{	body
q =
(
SELECT
NM_RAZAO_SOCIAL ,FONE ,CELULAR ,DN_CARGO ,NUMCAD ,SITUACAO,DT_NASCIMENTO ,CD_CARGO 
from CAD_FUNCIONARIOS 
WHERE   (cd_cargo like '`%220`%' or cd_cargo like '`%217`%' or cd_cargo like '`%385`%' or cd_cargo like '`%380`%')
and situacao <> '7'
order by 8 DESC, 1 ASC
)
query := adosql(ora,q)	;}
;{ definiÁıes
xp = -275
yp = yp+33
Gui,	2:Color, %bggui%	;}
Loop, % query.MaxIndex()-1	;{
{
	col	:=	A_Index+1
	a		:=	query[col,1]
	b		:=	query[col,2]
	d		:=	query[col,3]
	f		:=	query[col,4]
	s		:=	query[col,6]
	if(s	!=	1	)
		disabled	=	cFF0000
	else
		disabled	=	c000000
	a		:=	MaskName(a)
	b		:=	MaskTel(b)
	d		:=	MaskTel(d)
	StringUpper, f, f, t
	IfInString, f, Assistente
		f	:=	strreplace(f,"Assistente","Ass.")
	IfInString, f, Infraestrutura
		f	:=	strreplace(f,"Infraestrutura","Infra.")
	IfInString, f, Coordenador
		f	:=	strreplace(f,"Coordenador","Coord.")
	IfInString, f, De
		f	:=	strreplace(f," De "," de ")
	IfInString, f, ti
	{
		f	:=	strreplace(f,"de Ti")
		f	:=	strreplace(f," Ti")
	}
	IfInString, f, ii
		f	:=	strreplace(f," Ii"," II")
	IfInString, f, iii
		f	:=	strreplace(f," Iii"," III")
	Gui,	2:Font, Bold
	if	(	col	=	15	)
	{
		xp = 125
		yp = y30
	}
	if	(	col	>	15	and col < 28	)
	{
		xp	=	-275
		yp	=	yp+33
	}
	if	(	col	=	28	)
	{
		xp = 125
		yp = y30
	}
	if	(	col	>	28	)
	{
		xp = -275
		yp = yp+33
	}
	if	(	col	=	2		)
	{
		Gui,	2:Add,	GroupBox,	x5			y75		w385	h40			%disabled%	,	% a
		Gui,	2:Add,	GroupBox,	x170		yp		w1	h40
		Gui,	2:Add,	GroupBox,	xp-165	yp Hidden
	}
	else
	{
		Gui,	2:Add,	GroupBox,	xp%xp%			%yp%		w385	h40	%disabled%	,	% a
		Gui,	2:Add,	GroupBox,	xp+165		yp		w1	h40
		Gui,	2:Add,	GroupBox,	xp-165	yp Hidden
	}
	Gui,	2:Font
	Gui,	2:Color, , %bgctrl%
	Gui,	2:Add,	Text,			xp+15		yp+13	w150	h20					,	% f
	Gui,	2:Add,	Text,			xp+155	yp		w100	h20		Center	,	% b
	Gui,	2:Add,	Text,			xp+105	yp		w100	h20		Center	,	% d
	WinSet, TransColor, Green
}
q_sql =
(
SELECT *
  FROM [Sistema_Monitoramento].[dbo].[contatos]
  WHERE unidade = '996'
  AND ordem = 'k'
)
query := adosql(con,q_sql)
if	(	query.MaxIndex()-1 > 0)
{
	col = 
	Loop, % query.MaxIndex()-1	;{
		{
		col	:=	A_Index+1
		a		:=	query[col,2]
		b		:=	query[col,5]
		f		=		Plant„o
		d		=		
		a		:=	MaskName(a)
		b		:=	MaskTel(b)
		Gui,	2:Font, Bold
		if	(	col	=	2		)
		{
			Gui,	2:Add,	GroupBox,	x5			y30		w385	h40				,	% a
			Gui,	2:Add,	GroupBox,	x170		yp		w1	h40
			Gui,	2:Add,	GroupBox,	xp-165	yp Hidden
		}
		else
		{
			Gui,	2:Add,	GroupBox,	xp%xp%			%yp%		w385	h40	,	% a
			Gui,	2:Add,	GroupBox,	xp+165		yp		w1	h40
			Gui,	2:Add,	GroupBox,	xp-165	yp Hidden
		}
		Gui,	2:Font
		Gui,	2:Color, , %bgctrl%
		Gui,	2:Add,	Text,			xp+15		yp+13	w150	h20					,	% f
		Gui,	2:Add,	Text,			xp+155	yp		w100	h20		Center	,	% b
		Gui,	2:Add,	Text,			xp+105	yp		w100	h20		Center	,	% d
		WinSet, TransColor, Green
	}
}
Gui,	2:Show,x0 y0 NoActivate, Monitoramento
return	;}
;}	;}
Sistema:					;{
if (ip4 = 184)
 return
if !ProcessExist("DDguard Player.exe")
 ExitApp
 return
 ;}
								;{	FunÁıes
ver_situaÁ„o:	;{
situ =
(
	SELECT DESSIT FROM SENIOR.R010SIT
	WHERE CODSIT = '%ferias%'
)
situa := adosql(ora,situ)
situacao := situa[2,1]
return	;}
RemoveLetterAccents( text )
{
replace=¡·¿‡¬‚AaAa√„????ƒ‰≈ÂAaAa??????????????????????CcCcCcCc«ÁDd–d–…È»Ë ÍEeEe????EeÀÎEeEe????????????GgGgGgGgHhHhÕÌÃÏIiŒÓIiœÔIiIiIi????JjKkLlLlLlLl??NnNn—ÒNn”Û“ÚOo‘Ù????????Oo÷ˆOo’ıÿ¯??Oo??Oo??????????????????RrRrRrSsSsäöSsTtTtTt⁄˙Ÿ˘Uu€˚UuUu‹¸UuUuUuUuUuUuUuUu??Uu????????????????Ww??›˝??Yyüˇ??????ZzéûZz
with=AaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaCcCcCcCcCcDdDdDEeEeEeEeEeEeEeEeEeEeEeEeEeEeEeEeEeGgGgGgGgHhHhIiIiIiIiIiIiIiIiIiIiIiJjKkLlLlLlLlLlNnNnNnNnOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoPpPpRrRrRrSsSsSsSsTtTtTtUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuWwWwWwWwYyYyYyYyYyYyYyZzZzZz
Loop, Parse, Replace
   {
    stringmid, w, with, a_index, 1
    stringreplace, text, text, %a_loopfield%, %w%, All
   }
return text
}	;}
Esc::							;{
GuiClose:
ExitApp
;}
