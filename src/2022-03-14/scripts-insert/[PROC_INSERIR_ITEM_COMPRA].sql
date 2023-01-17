USE [DBT001]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERIR_ITEM_COMPRA] (
											  @pIdUsuario		INT
											, @pIdCompra		INT				
											, @pIdProduto		INT				
											, @pQuantidade		INT				
											, @pValor			DECIMAL(10,2)	
) AS

BEGIN
	SET NOCOUNT ON

	DECLARE   @ErrorMessage		VARCHAR(4000)
			, @ErrorSeverity	INT
			, @ErrorState		INT


	BEGIN TRY

		IF NOT EXISTS(SELECT * FROM tbl_usuario WHERE IdUsuario = @pIdUsuario)
		BEGIN
			RAISERROR('404;Usu�rio de atualiza��o n�o encontrado', 0, 1)
		END

		IF NOT EXISTS(SELECT * FROM tbl_produto WHERE IdProduto = @pIdProduto)
		BEGIN
			RAISERROR('404;Produto n�o encontrado', 0, 1)
		END

		IF NOT EXISTS(SELECT * FROM tbl_compra WHERE IdCompra = @pIdCompra)
		BEGIN
			RAISERROR('404;Compra n�o encontrada', 0, 1)
		END

		
		BEGIN TRANSACTION

		INSERT INTO tbl_item_compra (
				    IdCompra	
				  , IdProduto	
				  , Quantidade	
				  , Valor		
		)
		VALUES (
			      @pIdCompra	
				, @pIdProduto	
				, @pQuantidade	
				, @pValor		
		)

		COMMIT


	END TRY
	BEGIN CATCH
		SELECT	  @ErrorMessage		= ERROR_MESSAGE()	+ ' - Rollback executado!'
				, @ErrorSeverity	= ERROR_SEVERITY()
				, @ErrorState		= ERROR_STATE()
		
		ROLLBACK
		RAISERROR(
			  @ErrorMessage
			, @ErrorSeverity
			, @ErrorState
		)
		RETURN
	END CATCH

END