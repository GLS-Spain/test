USE [Wasmcom]

-- =============================================
ALTER FUNCTION [dbo].[atl_get_posibles_horarios]
(
	@codservicio smallint,
	@pais_org varchar(3),
	@pais_dst varchar(3),
	@cp_dst varchar(10)

)
RETURNS @horarios table
(
	codigo smallint,
	CodigoOld float,
	CodigoCom char(1),
	Descrip varchar(40),
	f_baja smalldatetime,
	Alternativo smallint
)
as begin

if @pais_org is null set @pais_org= 'ES'
if @pais_dst is null set @pais_dst= 'ES'


if @codservicio = 2
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo in (0,2,3,5,14,15)
else if @codservicio = 6 
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo =10
else if @codservicio = 12 
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo =17
else if @codservicio = 13 
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo =16
else if @codservicio in (30,35,37,60)
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo =18
else if @codservicio in (83)
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo in (16)
else if @codservicio =21
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo =1
else if @codservicio =62
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo =1
else if @codservicio = 66 
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo =2
else if @codservicio in (96,97,98)
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where codigo =18
else begin
	insert into @horarios select codigo,codigoold, codigocom, descrip, f_baja, alternativo from wasmcom.dbo.thorarios (nolock) where f_baja is null

	if @codservicio in (1,21) delete from @horarios where codigo in (10,19)

	--Andorra no tiene ASM10
	if @pais_org = 'AD' or @pais_dst = 'AD' delete from @horarios where codigo=0

	--Maritimo, sólo fuera de peninsula
	if dbo.EsPeninsula(@cp_dst)=1 delete from @horarios where codigo =10


	--Asm10 no puede ser fuera de peninsula
	if @cp_dst is not null and dbo.EsPeninsula(@cp_dst)=0 delete from @horarios where codigo =0
	-- desaparece el horario masivo
	if getdate()>'01/01/2024' delete from @horarios where codigo =4
end

return
end
