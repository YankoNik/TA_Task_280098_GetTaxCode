
--- [SP_GET_PREFERENCIAL_PLAN_INFO_GET_STANDART_CONTRACT_CODE]

CREATE   PROCEDURE [dbo].[SP_GET_PREFERENCIAL_PLAN_INFO_GET_STANDART_CONTRACT_CODE]
(
    @DEAL_TYPE		INT		-- ��� �� ��������
,   @DEAL_NUM		INT     -- ����� �� ��������
,   @STD_DOG_CODE   INT	OUT
)
AS
	EXEC @STD_DOG_CODE = SP_GET_STD_CONTRACT_CODE @DEAL_TYPE, @DEAL_NUM;

	-- ��� ��� ��� �� ��� �� �������� �������� ���		
	IF( @STD_DOG_CODE = 0 )
	BEGIN
		SELECT TOP 1 @STD_DOG_CODE = STD_DOG_CODE FROM VI_TAXES_TO_DEALS_ALL  
				WHERE DEAL_NUMBER = @DEAL_NUM
					AND DEAL_TYPE = @DEAL_TYPE	
	END
GO

