;@Ahk2Exe-SetMainIcon C:\Dih\zIco\2map.ico
#Include header.ahk
;{  Gui
SetBatchLines, -1
mapdir	:=	"C:\Seventh\Backup\map"
unidade = %1% ;variável aqui
de =
(
SELECT *
  FROM [Sistema_Monitoramento].[dbo].[id locais]
  WHERE id = '%unidade%'
)
mapas := ADOSQL(con, de)
mapa	:=	mapas[2,3]
mapanome	:=	mapas[2,2]
file := mapdir . "\" . mapa
if ( unidade = "" )
	return
Gui, 3:Add, Pic, x10 y10 vPic, %file%
Gui, 3:Color, %bggui%
Gui, 3:Show, AutoSize, Mapa de %mapanome%
return  ;}
Sistema:					;{
if (ip4 = 184)
 return
if !ProcessExist("DDguard Player.exe")
 ExitApp
 return
 ;}
3GuiClose:					;{
ExitApp
;}
