;@Ahk2Exe-SetMainIcon C:\Dih\zIco\2mail.ico
soft    =   relatorios
#Include header.ahk
;{ Conf
SetTimer, c_var, 500
SetTimer, Progress_bar, 1000
if (    ip4 = 171    )
 est =  AND  Setor = '0001'
if (    ip4 = 175    )
 est =  AND  Setor = '0002'
if (    ip4 = 178    )
 est =  AND  Setor = '0003'
if (    ip4 = 163    )
 est =  AND  Setor = '0004'
if (    ip4 = 167    )
 est = AND  Setor = '0005'
else
 est = AND  Setor = '0001' 
if ( A_UserName = "dsantos" or A_UserName = "alberto"	or	A_UserName	=	"llopes")
 H1 := "Eventos Últimas 48 Horas|Eventos por Unidade|Filtrar Eventos|E-Mails 10 Últimos Dias|Avisos|Ocomon|Caminhões|Vigilantes"
else
 H1 := "Eventos Últimas 48 Horas|Eventos por Unidade|Filtrar Eventos|E-Mails 10 Últimos Dias|Avisos|Ocomon|Caminhões"

;}
;{ Starter
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow 
Gui, Font, s15 ceef442
Gui,	Add,	Text,  x2	y100	h20 ,	Versão %version%
Gui, Font, s10 cFF0000
Gui, Color, 000000
Gui,	Add,	Text,	x2	y0	    h20	vg1,	Carregando E-Mails de Caminhões...
Gui,	Add,	Text,	x2	y20	    h20	vg2,	Carregando Avisos...
Gui,	Add,	Text,	x2	y40	    h20	vg3,	Carregando Chamados do Ocomon...
Gui,	Add,	Text,	x2	y60	    h20	vg4,	Carregando Lista de Unidades...
Gui,	Add,	Text,	x2	y80	    h20	vg5,	Carregando E-Mails...
if ( A_UserName = "dsantos" or A_UserName = "alberto"	or	A_UserName	=	"llopes")
 Gui,	Add,	Text,	x2	y100    h20	vg6,	Carregando Vigilantes...
Gui, Show, x0  y0  NoActivate
Gui, Font, s10 c229b1b
 gosub Caminhão
GuiControl, Font, g1
GuiControl, ,   g1, E-Mails de Caminhões Carregados!
 gosub avisos
GuiControl, Font, g2
GuiControl, ,   g2, Avisos Carregados!
 gosub Ocomon
GuiControl, Font, g3
GuiControl, ,   g3, Chamados do Ocomon Carregados!
 gosub ddl
GuiControl, Font, g4
GuiControl, ,   g4, Lista de Unidades Carregada!
 gosub e_mail
GuiControl, Font, g5
GuiControl, ,   g5, E-Mails Carregados!
if ( A_UserName = "dsantos" or A_UserName = "alberto"	or	A_UserName	=	"llopes")
{
GuiControl, Font, g6
GuiControl, ,   g6, Vigilantes Carregados!
}
Sleep 1000
Gui, Font
Gui, Destroy ;}
;{ GUI
SysGet, primary, MonitorPrimary
SysGet, mon, MonitorWorkArea, %primary%
Gui, Color, %bggui%
Gui, Color, , %bgctrl%
Gui, Add, Tab2, % "x2 y0 w" A_ScreenWidth-10 " h20 vH", % H1 
Gui, Add, Text, xm y30 w240 h20 , Operador
Gui, Add, DropDownList,x65 y25 w100 h20 AltSubmit r6 gEventos_48h vS2 , Operador 1|Operador 2|Operador 3|Operador 4|Operador 5|Monitoramento ;{
Gui, Add, Edit,% "xp-60 yp+25 w" A_ScreenWidth-10 " h" A_ScreenHeight-(A_ScreenHeight-monBottom)-100 " +VScroll  vE1", % ET1  ;listview
Gui, Add, Checkbox,xp+170 yp-25 w400 h20 Checked gEventos_48h vS3 , Exibir disparos sem motivo aparente e de inicio de expediente.
Gui, Add, Checkbox,xp+400 yp w700 h20 gEventos_48h vOC, ordem cronológica
Gui, Add, Button,% "x" A_ScreenWidth-210 " y" A_ScreenHeight-(A_ScreenHeight-monBottom)-45 " w200 h40 gGuiClose", Fechar
;}
;=============================================================
Gui, Tab, Filtrar Eventos ;{
Gui, Add, MonthCal, Section gFiltros vM2 
Gui, Add, Text,ys Section , Ordem
Gui, Add, Radio, Checked gFiltros vO1 , Ascendente
Gui, Add, Radio, gFiltros , Descendente
Gui, Add, Text,ys Section , Ordenar Por:
Gui, Add, Radio, Checked Group gFiltros vO2 , Cliente
Gui, Add, Radio, gFiltros , Data
Gui, Add, Radio, gFiltros , Operador
Gui, Add, Text,x425 ys , Buscar evento contendo:
Gui, Add, Edit, gFiltros vB1
Gui, Add, Text,x425 yp+30 , Buscar ID de cliente do Iris:
Gui, Add, Edit,limit5 gFiltros vB2
Gui, Add, Edit,% "x5 yp+100 w" A_ScreenWidth-10 " h" A_ScreenHeight-(A_ScreenHeight-monBottom)-245 "+VScroll vE2"
Gui, Add, Button,% "x" A_ScreenWidth-210 " y" A_ScreenHeight-(A_ScreenHeight-monBottom)-45 " w200 h40 gGuiClose", Fechar ;}
;=============================================================
Gui, Tab, Eventos por Unidade ;{
Gui, Add, Text,x11 ys+2, Evento contendo:
Gui, Add, Edit,xp+115 yp-5  vBEC, 
Gui, Add, Text,xp+125 ys+2 , Por unidade
Gui, Add, Edit,xp+75 yp-5 w250  vEv
Gui, Add, Button,xp+255 yp w100 h20 gEventos_Unidade , Buscar
Gui, Add, Edit,% "xp-576 ys+22 w" A_ScreenWidth-10 " h" A_ScreenHeight-(A_ScreenHeight-monBottom)-100 " +VScroll vEPU"
Gui, Add, Button,% "x" A_ScreenWidth-210 " y" A_ScreenHeight-(A_ScreenHeight-monBottom)-45 " w200 h40 gGuiClose", Fechar ;}
;=============================================================
Gui, Tab, E-Mails 10 Últimos Dias ;{
Gui, Add, Text,x11 ys+2, E-Mail contendo:
Gui, Add, Edit,xp+115 yp-5 ge_mail vME, 
Gui, Add, Text,xp+125 ys+2 , Por unidade
Gui, Add, DropDownList,xp+75 yp-5 w250 ge_mail vDD , % ddlx
Gui, Add, Text,xp+260 yp+4 , Recarregando E-Mails...
Gui, Add, Progress,xp+120 yp-2 -Smooth vprog
Gui, Add, Edit, % "xp-700 ys+22 w" A_ScreenWidth-10 " h" A_ScreenHeight-(A_ScreenHeight-monBottom)-100 " +VScroll Section vMV"
Gui, Add, Button,% "x" A_ScreenWidth-210 " y" A_ScreenHeight-(A_ScreenHeight-monBottom)-45 " w200 h40 gGuiClose", Fechar ;}
;=============================================================
Gui, Tab, Avisos ;{
Gui, Add, Text,x11 ys-22 , Aviso contendo:
Gui, Add, Edit,xp+115 yp gavisos vLE , 
Gui, Add, Edit,% "xp-120 yp+22 w" A_ScreenWidth-10 " h" A_ScreenHeight-(A_ScreenHeight-monBottom)-100 " +VScroll vL1"
Gui, Add, Button,% "x" A_ScreenWidth-210 " y" A_ScreenHeight-(A_ScreenHeight-monBottom)-45 " w200 h40 gGuiClose", Fechar ;}
;=============================================================
Gui, Tab, Ocomon ;{
Gui, Add, Text,x11 ys-22 , Chamado contendo:
Gui, Add, Edit,xp+115 yp-2 gOcomon vCO1, 
Gui, Add, Edit, % "xp-115 yp+22 w" A_ScreenWidth-10 " h" A_ScreenHeight-(A_ScreenHeight-monBottom)-100 "+VScroll vCO"
Gui, Add, Button,% "x" A_ScreenWidth-210 " y" A_ScreenHeight-(A_ScreenHeight-monBottom)-45 " w200 h40 gGuiClose", Fechar    ;}
;=============================================================
Gui, Tab, Caminhões ;{
Gui, Add, Text,x11 ys-22 , E-Mail contendo:
Gui, Add, Edit,xp+115 yp gCaminhão vCAME, 
Gui, Add, Edit, % "xp-115 yp+22 w" A_ScreenWidth-10 " h" A_ScreenHeight-(A_ScreenHeight-monBottom)-100 " +VScroll vCAM"
Gui, Add, Button,% "x" A_ScreenWidth-210 " y" A_ScreenHeight-(A_ScreenHeight-monBottom)-45 " w200 h40 gGuiClose", Fechar ;}

if ( A_UserName = "dsantos" or A_UserName = "alberto"	or	A_UserName	=	"llopes") ;{
{
Gui, Tab, Vigilantes
Gui, Add, Text,x11 ys-22 , Relatório contendo:
Gui, Add, Edit,xp+115 yp gVigilantes vVIG, 
Gui, Add, Edit,% "xp-115 yp+22 w" A_ScreenWidth-10 " h" A_ScreenHeight-(A_ScreenHeight-monBottom)-100 " +VScroll vVI"
 gosub Vigilantes
Gui, Add, Button,% "x" A_ScreenWidth-210 " y" A_ScreenHeight-(A_ScreenHeight-monBottom)-45 " w200 h40 gGuiClose", Fechar
} ;}
Gui, -Border -Caption

Gui, Show,% "x-1 y-1 w" A_ScreenWidth " h" A_ScreenHeight-(A_ScreenHeight-monBottom), Eventos
GuiControl, , L1, % L
GuiControl, , E2, % ET2
GuiControl, , MV, % EM
GuiControl, , CO, % C
GuiControl, , VI, % VI
GuiControl, , CAM, % CAMX
 sleep 10
Send {Up}
 return ;}
TABSEL: ;{  apenas quando select de tab estiver ativo
Gui, Submit, NoHide
if  (      H = 1 )
 gosub ddl
if  (      H = 3 )
 gosub e_mail
if  (      H = 4 )
 gosub avisos
if  (      H = 5 )
 gosub Ocomon
if  (      H = 6 )
 gosub Caminhão
return  ;}
ddl: ;{
q_ddl =
(
SELECT * FROM [IrisSQL].[dbo].[Clientes]
Where Cliente = '10001'
AND Particao > '000'
AND idUnico <> '244'
AND idUnico <> '248'
AND idUnico <> '232'
ORDER BY 4
)
Table :=
Table := ADOSQL(Con, q_ddl)
xlemb := Table.MaxIndex() -1
Loop % Table.MaxIndex() -1
{
 col := A_Index+1
 ddlx := ddlx "|" Table[col, 4]
}
return ;}
Eventos_48h: ;{ Select do DDL
Gui, Submit, NoHide
GuiControl, , E1
ET1 =
ev =
q_s =
relat =
if ( S3 = 0 )
{
 v1 = AND TipoAtd <> 't'
 v2 = AND TipoAtd <> '0'
}
else
{
 v1 =
 v2 =
}
if ( OC = 1 )
 v3 = ORDER BY Disparo DESC
else
 v3 = ORDER BY Cliente ASC 

if S2 = 6   ;{
{
q_s =   ;   Monitoramento
(
 DROP TABLE IF EXISTS #eventos
 SELECT * INTO #eventos
 FROM [IrisSQL].[dbo].[Procedimentos]
 WHERE Observacoes_conta IS NOT NULL
 AND DATALENGTH(Observacoes_conta)<>0
 AND Disparo > DATEADD(HOUR, -48, GETDATE())
 AND Disparo < GETDATE()
 
 SELECT
 Cliente,
 OperadorDisparo,
 CONVERT(CHAR, Disparo, 103) + CONVERT(VARCHAR(8), Disparo, 14) AS Disparo,
 OperadorFinalizou,
 CONVERT(CHAR, Finalizado, 103) + CONVERT(VARCHAR(8), Disparo, 14) AS Finalizado,
 Observacoes_conta,
 idCliente
 
 FROM #eventos
 WHERE
 Cliente =  '10001'
 AND Particao = '000'
 ORDER BY Cliente ASC
)
Tablet =
Tablet := ADOSQL(Con, q_s)
Loop % Tablet.MaxIndex() -1 
{
 col := A_Index+1
 q1 := Tablet[col, 1]
 unidade := Tablet[col, 7]
gosub getnames
 q2 := Tablet[col, 2]
 q3 := Tablet[col, 3]
 q4 := Tablet[col, 4]
 q5 := Tablet[col, 5]
 q6 := Tablet[col, 6]
 IfInString, q6, ~ Cliente Ausente
 {
 StringSplit, q6, q6, ~
 q6 := q61
 }
 ;~ q6 := ChangeCase(q6,"S")
 relat := relat name "`nOperador Inicial:`t`t" q2 "`nHorário Inicio:`t`t" q3 "`nOperador Encerramento:`t" q4 "`nHorário de Finalização:`t" q5 "`nRelatório:`n`n" q6 "`n`n|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|`n`n"
}
goto t  ;}


}
if S2 = 1
 est =  AND ( setor = '0001' or EstacaoFinalizou =   'CPC027893')
if S2 = 2
est =   AND ( setor = '0002' or EstacaoFinalizou =   'CPC027896')
if S2 = 3
est =   AND ( setor = '0003' or EstacaoFinalizou =   'CPC027897')
if S2 = 4
 est =  AND ( setor = '0004' or EstacaoFinalizou =   'EST03-VDM')
if S2 = 5
 est = AND  ( setor = '0005' or EstacaoFinalizou =   'EST07-VDM')
q_s =
(
 DROP TABLE IF EXISTS #eventos
 SELECT * INTO #eventos
 FROM [IrisSQL].[dbo].[Procedimentos]
 WHERE Observacoes_conta IS NOT NULL
 AND DATALENGTH(Observacoes_conta)<>0
 AND Disparo > DATEADD(HOUR, -48, GETDATE())
 AND Disparo < GETDATE()
 %v1%
 %v2%
 
 SELECT
 Cliente,
 OperadorDisparo,
 CONVERT(CHAR, Disparo, 103) + CONVERT(VARCHAR(8), Disparo, 14),
 OperadorFinalizou,
 CONVERT(CHAR, Finalizado, 103) + CONVERT(VARCHAR(8), Finalizado, 14),
 Observacoes_conta,
 idCliente,
 Setor,
 CodEvtFinalizou
 
 FROM #eventos
 WHERE
 Cliente > '10001'
 %est%
 %v3%
)
Tablet =
Tablet := ADOSQL(Con, q_s)
Loop % Tablet.MaxIndex() -1 
{
 col := A_Index+1
 q1 := Tablet[col, 1]
 unidade := Tablet[col, 7]
 gosub getnames
 q2 := Tablet[col, 2]
 q3 := Tablet[col, 3]
 q4 := Tablet[col, 4]
 q5 := Tablet[col, 5]
 q6 := Tablet[col, 6]
 q3 :=  strreplace(q3,"                    ", " - ")
 q5 :=  strreplace(q5,"                    ", " - ")
 IfInString, q6, ~ Cliente Ausente
 {
 StringSplit, q6, q6, ~
 q6 := q61
 }
 ;~ q6 := ChangeCase(q6,"S")
 relat := relat name "`nOperador Inicial " q2 "`t`tHorário Inicio:`t`t" q3 "`nOperador Final   " q4 "`t`tHorário de Finalização:`t" q5 "`n`nRelatório:`n" q6 "`n`n|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|`n`n"
}
t:
StringSplit, ev_separados, relat, |
ev := ev_separados0 -1
Loop %ev% 
{
ET1 := ET1 . ev_separados%A_index%
}
StringTrimRight, ET1, ET1, 1

GuiControl, , E1, % ET1
GuiControl, Focus, E1
Return ;}
Eventos_Unidade:    ;{ ;{
Gui, Submit, NoHide
ddays = -30
if ( Ev != "" )
{
q_c =
(
SELECT TOP 1
Cliente
FROM [IrisSQL].[dbo].[Clientes]
WHERE Nome like '`%%Ev%`%'
AND Particao = '000'
)
Table :=
Table := ADOSQL(Con, q_c)
onde := Table[2, 1]
StringTrimRight, onde, onde, 1
ddl2 := "AND Cliente like '`%" onde "`%'"
}
else
 ddl2 =
GuiControl, , EPU
q_m = 
test =
xe_mail =
evi =

q_m =
(
 SELECT *
 FROM [IrisSQL].[dbo].[Procedimentos]
 WHERE Disparo > DATEADD(DAY, %ddays%, GETDATE())
 AND ( Observacoes_conta LIKE '`%%BEC%`%' and Observacoes_conta is not null )
 AND CodEvtFinalizou <> '9037'
 %ddl2%
 ORDER BY 10 DESC
)
LastQuery := ADOSQL_LastQuery
eventos :=
eventos := ADOSQL(Con, q_m)
xe_mail := eventos.MaxIndex() -1
Loop % eventos.MaxIndex() -1
{
 col := A_Index+1
 unidade := eventos[col, 23]
 v1 =
 gosub getnames
 desc := eventos[col, 4] "`n`n" ; Conteudo
 dat := eventos[col, 10] ; data adicionado
 who := eventos[col, 3] ; data adicionado
 test := test "`n" name "`nSalvo em: " dat "`n`n" desc "`n" who "`n`n"  "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------`n"
}
ddl2 =
EPUT := test
GuiControl, , EPU, % EPUT
return ;}    ;}
Filtros: ;{ On Select Tab 2
Sleep 1500
Gui, Submit, NoHide
cb1 := B1
cb2 := B2
GuiControl, , E2
if O1 = 1
 SetEnv, O1, ASC
if O1 = 2
 SetEnv, O1, DESC
if O2 = 1
 SetEnv, O2, Cliente
if O2 = 2
 SetEnv, O2, Disparo
if O2 = 3
 SetEnv, O2, OperadorDisparo
dateadd := CalculateTime(M2,A_Now)
if ( dateadd >= "0" )
{
 MsgBox Você precisa selecionar uma data anterior ao dia de hoje.
 return
}
ET2 =
q_s =
eventos =
q_s =
(
DROP TABLE IF EXISTS #eventos

SELECT * INTO #eventos
FROM [IrisSQL].[dbo].[Procedimentos]
WHERE
Observacoes_conta IS NOT NULL
AND DATALENGTH(Observacoes_conta) <> 0
AND OperadorDisparo IS NOT NULL
AND Disparo > DATEADD(DAY, %dateadd%, GETDATE())
AND Disparo < GETDATE()

SELECT
Cliente,
OperadorDisparo,
CONVERT(VARCHAR(20), Disparo, 20) AS Disparo,
OperadorFinalizou, CONVERT(VARCHAR(20), Finalizado, 20) AS Finalizado,
Observacoes_conta
FROM #eventos
WHERE
Cliente <> '10000'
AND Observacoes_conta LIKE '`%%B1%`%'
AND Cliente LIKE '`%%B2%`%'
ORDER BY %O2% %O1%
)
Table =
Table := ADOSQL(Con, q_s)
Loop % Table.MaxIndex() -1 
{
 CURRENT_ROW := A_Index +1
 Loop % Table[CURRENT_ROW].MaxIndex() 
 {
 CURRENT_COLUMN := A_Index
 if A_Index = 1
 Campo = 
 if A_Index = 2
 campo = Operador Inicial:
 if A_Index = 3
 campo = Iniciado as:
 if A_Index = 4
 campo = Operador Final:
 if A_Index = 5
 campo = Finalizado as:
 if A_Index = 6
 campo = Relatório:`n
 if A_index = 1
 separador =
 else
 separador = +
 eventos := eventos separador campo "`t" Table[CURRENT_ROW, CURRENT_COLUMN]
 }
eventos := eventos "`n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------`n`n`n|"
}
StringSplit, ev_separados, eventos, |
ev := ev_separados0 -1
Loop %ev% 
{
 StringSplit, cada_evento, ev_separados%A_Index%, +
 Loop %cada_evento0%
 {
 un := trim(cada_evento1, "`t")
 IniRead, cada_evento1, \\fs\Departamentos\monitoramento\Monitoramento\Dieisson\SMK\uni.ini, %un%
 StringUpper, cada_evento1, cada_evento1, T
 ET2 := ET2 "`n" cada_evento%A_index%
 }
StringTrimRight, ET2, ET2, 1
}
GuiControl, , E2, % ET2
return ;}
e_mail: ;{ ;{ OK 30/11
Gui, Submit, NoHide
ddays = -10
if ( DD != "" )
{
 ddays = -999
q_c =
(
SELECT IdUnico
FROM [IrisSQL].[dbo].[Clientes]
WHERE Nome = '%DD%'
)
Table :=
Table := ADOSQL(Con, q_c)
onde := Table[2, 1]
ddl2 = AND idCliente = '%onde%'
}
else
 ddl2 =
If ( ME != "" )
 ddays = -999
cME := ME
GuiControl, , MV
q_m = 
EM =
test =
xe_mail =
ev =

q_m =
(
 DROP TABLE IF EXISTS #eventos
SELECT Finalizado, Observacoes_conta, idCliente INTO #eventos
 FROM [IrisSQL].[dbo].[Procedimentos]
 WHERE cliente = '10001'
 AND Particao >= '001'
 AND Particao < '998'
 AND Particao < '998'
 AND Disparo > DATEADD(DAY, %ddays%, GETDATE())
 AND Observacoes_conta LIKE '`%%ME%`%'
  %ddl2%
 INSERT INTO #eventos
 (Finalizado, Observacoes_conta, idCliente)
 SELECT QuandoGerou, Mensagem, Idcliente
 FROM [IrisSQL].[dbo].[Agenda]
 WHERE QuandoGerou > DATEADD(DAY, %ddays%, GETDATE())
 AND Mensagem LIKE '`%%ME%`%'
 AND IdCliente <> '244'
 AND IdCliente <> '248'
 AND IdCliente <> '232'
  %ddl2%

 SELECT Finalizado, Observacoes_conta, idCliente
 FROM #eventos
 ORDER BY 1 DESC
)
Table :=
Table := ADOSQL(Con, q_m)
xe_mail := Table.MaxIndex() -1
Loop % Table.MaxIndex() -1
{
 col := A_Index+1
 unidade := Table[col, 3]
 v1 =
 gosub getnames
 test := test name "`n" ; Nome da Unidade
 test := test Table[col, 2] "`n`n" ; Conteudo
 test := test "Salvo em:`t"
 test := test "`t" Table[col, 1] ; data adicionado
 test := test "`n|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|`n"
}
StringSplit, even, test, |
ev := even0 -1
Loop %ev% 
 EM := EM "`n" even%A_Index% 
GuiControl, , MV, % EM
return ;}    ;}
getnames: ;{ Cria as variáveis com part = nome da unidade
q_n =
q_n =
(
 SELECT *
 FROM [IrisSQL].[dbo].[Clientes]
 WHERE idUnico = '%unidade%'
)
Tab :=
Tab := ADOSQL(Con, q_n)
name := "`t`t`t`t`t`t" Tab[2, 4]
return ;}
avisos: ;{ Preenchimento da tab 1 de 24 horas
Gui, Submit, NoHide
cLE := LE
GuiControl, , L1
L1 = 
L =
lemb = 
ev =
if ( LE1 = 2 )
 LM = -30 ; 30 dias
if ( LE1 = 1 )
 LM = -90 ; 90 dias
q_l =
eventos =
q_l =
(
 DROP TABLE IF EXISTS  #avisos
 SELECT Observacoes_conta, Disparo INTO #avisos FROM [IrisSQL].[dbo].[Procedimentos]
 WHERE cliente = '10001' AND Particao ='999' AND Observacoes_conta LIKE '`%%LE%`%'
 ORDER BY 2 DESC
 INSERT INTO #avisos (Observacoes_conta, Disparo)
 SELECT Mensagem, QuandoGerou FROM [IrisSQL].[dbo].[Agenda]
 WHERE IdCliente = '232'
 ORDER BY 2 DESC

 SELECT Observacoes_conta, Disparo
 FROM #avisos
 ORDER BY 2 DESC
)
Table :=
Table := ADOSQL(Con, q_l)
xlemb := Table.MaxIndex() -1
Loop % Table.MaxIndex() -1
{
 col := A_Index+1
 lemb := lemb Table[col, 1] "`n`n"
 lemb := lemb Table[col, 2] 
 lemb := lemb "`n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------||"
}
StringSplit, even, lemb, |
ev := even0 -1
Loop %ev% 
 L := L "`n" even%A_Index% 
GuiControl, , L1, % L
Return ;}
Ocomon: ;{ Preenchimento da tab 1 de 24 horas
Gui, Submit, NoHide
cCO1 := CO1
GuiControl, , CO
CO1 = 
C =
ocomon = 
ev =

q_o=
eventos =
q_o =
(
 DROP TABLE IF EXISTS  #ocomon
 SELECT Observacoes_conta, Disparo INTO #ocomon FROM [IrisSQL].[dbo].[Procedimentos]
 WHERE cliente = '10001' AND Particao ='998' AND Observacoes_conta LIKE '`%%cCO1%`%'
 ORDER BY 2 DESC
 INSERT INTO #ocomon (Observacoes_conta, Disparo)
 SELECT Mensagem, QuandoGerou FROM [IrisSQL].[dbo].[Agenda]
 WHERE IdCliente = '244'
 ORDER BY 2 DESC

 SELECT Observacoes_conta, Disparo
 FROM #ocomon
 ORDER BY 2 DESC
)
Table :=
Table := ADOSQL(Con, q_o)
xlemb := Table.MaxIndex() -1
Loop % Table.MaxIndex() -1
{
 col := A_Index+1
 ocomon := ocomon Table[col, 1] "`n`n"
 ocomon := ocomon Table[col, 2] 
 ocomon := ocomon "`n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------||"
}
StringSplit, even, ocomon, |
ev := even0 -1
Loop %ev% 
 C := C "`n" even%A_Index% 
GuiControl, , CO, % C
Return ;}
Caminhão: ;{ Preenchimento da tab 1 de 24 horas
Gui, Submit, NoHide
GuiControl, , CAM
CAME = 
CAM =
ev =
caminhao =
q_cam=
eventos =
q_cam =
(
 DROP TABLE IF EXISTS  #caminhoes
 SELECT Observacoes_conta, Disparo INTO #caminhoes FROM [IrisSQL].[dbo].[Procedimentos]
 WHERE cliente = '10001' AND Particao ='997' AND Observacoes_conta LIKE '`%%CAME%`%'
 ORDER BY 2 DESC
 INSERT INTO #caminhoes (Observacoes_conta, Disparo)
 SELECT Mensagem, QuandoGerou FROM [IrisSQL].[dbo].[Agenda]
 WHERE IdCliente = '248'
 ORDER BY 2 DESC

 SELECT Observacoes_conta, Disparo
 FROM #caminhoes
 ORDER BY 2 DESC
)
Table :=
Table := ADOSQL(Con, q_cam)
xlemb := Table.MaxIndex() -1
Loop % Table.MaxIndex() -1
{
 col := A_Index+1
 caminhao := caminhao Table[col, 1] "`n`n"
 caminhao := caminhao Table[col, 2] 
 caminhao := caminhao "`n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------||"
}
StringSplit, even, caminhao, |
ev := even0 -1
Loop %ev% 
 CAMX := CAMX "`n" even%A_Index% 
GuiControl, , CAM, % CAMX
Return ;}
Vigilantes: ;{ 
Gui, Submit, NoHide
GuiControl, , VI
VI =
ev =
vigilante =
q_vig=
eventos =
q_vig =
(
 SELECT *
 FROM [IrisSQL].[dbo].[Procedimentos]
 WHERE cliente = '90001'
 AND Particao ='001'
 AND Observacoes_conta LIKE '`%%VIG%`%'
 ORDER BY 10 DESC
)
Table :=
Table := ADOSQL(Con, q_vig)
xlemb := Table.MaxIndex() -1
Loop % Table.MaxIndex() -1
{
 col := A_Index+1
 vigilante := vigilante Table[col, 3] "`n"
 vigilante := vigilante Table[col, 4] "`n`n"
 vigilante := vigilante Table[col, 10] 
 vigilante := vigilante "`n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------||"
}
StringSplit, even, vigilante, |
ev := even0 -1
Loop %ev% 
 VI := VI "`n" even%A_Index% 
GuiControl, , VI, % VI
Return ;}
CalculateTime(DateTo,DateFrom="",Time="Days"){ 
 static FillUp:="0000000000"
 DateTo.=SubStr(FillUp,1,14-StrLen(DateTo))
 If DateFrom
 DateFrom.=SubStr(FillUp,1,14-StrLen(DateFrom))
 If (Time="WDays"){
 YearTo:=SubStr(DateTo,1,4)*1
 YearFrom:=SubStr(DateFrom,1,4)*1
 FormatTime,WeekFrom,%DateFrom%,YWeek
 FormatTime,WeekTo,%DateTo%,YWeek
 If (yearto>=yearfrom){
 Loop % (yearto-yearfrom)
 {
 FormatTime,week,% YearTo . "1231000000",yWeek
 YearTo--
 WeekEndDays+=SubStr(week,5,2)*2
 }
 EnvSub,DateTo,%DateFrom%,days
 DateTo-=(SubStr(WeekTo,5,2)*1-SubStr(WeekFrom,5,2)*1)*2
 DateTo-=WeekEndDays
 } else {
 Loop % (yearfrom-yearto)
 {
 FormatTime,week,% YearFrom . "1231000000",yWeek
 YearFrom--
 WeekEndDays+=SubStr(week,5,2)*2
 }
 EnvSub,DateTo,%DateFrom%,days
 DateTo+=(SubStr(WeekTo,5,2)*1-SubStr(WeekFrom,5,2)*1)*2
 DateTo+=WeekEndDays
 }
 } else
 EnvSub,DateTo,%DateFrom%,%Time%
 Return DateTo
}
c_var: ;{
Gui, Submit, NoHide
if( cb1 != B1 )
 goto Filtros
if( cb2 != B2 )
 goto Filtros
if( cME != ME )
 goto e_mail
if( cLE != LE )
 goto avisos
if( cCO1 != CO1 )
 goto Ocomon
return ;}
Progress_bar: ;{
recheck ++
percent += 0.333
GuiControl, , prog, %percent%
if ( recheck = 300 )
{
 gosub e_mail
 gosub avisos
 recheck = 0
 GuiControl, , prog
 percent = 0
}
return ;}
Sistema: ;{
if (ip4 = 184)
 return
if !ProcessExist("DDguard Player.exe")
 ExitApp
 return
 ;}
GuiClose:   ;{
ExitApp
;}           