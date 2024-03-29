--- [SP_GET_PREFERENCIAL_PLAN_INFO]
CREATE   PROCEDURE [dbo].[SP_GET_PREFERENCIAL_PLAN_INFO]
(
	@DEAL_TYPE		INT				-- ��� �� ��������
,   @DEAL_NUM		INT				-- ����� �� ��������
,	@TAX_CODE		INT				-- ��� �� ������� �� ����� ������ �������������
,   @CUR_DATE		NVARCHAR(20)	-- ������ ���������� ����
,   @OPEN_DEAL_DATE	NVARCHAR(20)	-- ���� �� ��������� �� ��������
,   @DATE_ACTION	INT	 = 0		-- ���� �� ���������� ������������� ���������
,   @CONTRACT_NUMBER INT = 0		-- ����� �� �������
)
AS
	DECLARE @PREF_CODE		INT			-- ���� �� � ���� �� ������������� ����� �� ������ ������
	DECLARE @STD_DOG_CODE	INT			-- ����������� ������� �� �������� ����� ���������
	DECLARE @PREF_NAME		VARCHAR(50)	-- ����� �� ������������� ����� �� ������
	DECLARE @DATE_ACT		DATETIME	-- ���� �� ���������� ������������� ���������

	SET @PREF_CODE		= 0
	SET @STD_DOG_CODE	= @CONTRACT_NUMBER
	SET @PREF_NAME		= ''
	SET @DATE_ACT		= @CUR_DATE /* �������������� ������ �� ���������� */

	DECLARE @OPEN_DATE DATETIME = 0
	IF( @OPEN_DEAL_DATE != '0000-00-00' ) 
		SET @OPEN_DATE = @OPEN_DEAL_DATE

	-- �������� �� ����������
	IF @DATE_ACTION BETWEEN 20010101 AND 29991231
		SET @DATE_ACT = STR(@DATE_ACTION, 8, 0 )

	EXEC [SP_GET_PREFERENCIAL_PLAN_INFO_GET_INDIVIDUAL_OR_CLIENT_PREF_CODE] 
	@DEAL_TYPE, @DEAL_NUM, @TAX_CODE, @OPEN_DATE, @DATE_ACT, @STD_DOG_CODE, @PREF_CODE OUT, @PREF_NAME OUT

	-- ��� �� �������� ���� ���� ������������ ���� ��������� ������ �� ��������
	IF ( @PREF_CODE = 0 )
	BEGIN
		-- ��� �� � ������� �����
		IF( @STD_DOG_CODE <= 0 )
		BEGIN
			EXEC [SP_GET_PREFERENCIAL_PLAN_INFO_GET_STANDART_CONTRACT_CODE] @DEAL_TYPE, @DEAL_NUM, @STD_DOG_CODE OUT
		END
		-- ������ �� ��� �� ���������� �������
		EXEC [SP_GET_PREFERENCIAL_PLAN_INFO_GET_STANDART_CONTRACT_PREF_CODE] 
			@DEAL_TYPE, @DEAL_NUM, @TAX_CODE, @OPEN_DATE, @DATE_ACT, @STD_DOG_CODE, @PREF_CODE OUT, @PREF_NAME OUT
	END
     
	EXEC [SP_GET_PREFERENCIAL_PLAN_INFO_GET_RESULT] @TAX_CODE, @PREF_CODE

GO

