
/***************************************************************************************************************/
-- ���          : ������ �������
-- ���� � ���   : 08.01.2021
-- ������       : 213901 
-- ������������ : �����������
-- ��������     : ����������� �� SQL Plan ������������ �� SP_GET_PREFERENCIAL_PLAN_INFO
-- ���������    : -
/***************************************************************************************************************/

--- [SP_GET_PREFERENCIAL_PLAN_INFO_GET_INDIVIDUAL_OR_CLIENT_PREF_CODE]

CREATE   PROCEDURE [dbo].[SP_GET_PREFERENCIAL_PLAN_INFO_GET_INDIVIDUAL_OR_CLIENT_PREF_CODE]
(       
        @DEAL_TYPE      INT				-- ��� �� ��������
    ,   @DEAL_NUM		INT				-- ����� �� ��������
    ,   @TAX_CODE		INT				-- ��� �� ������� �� ����� ������ �������������
    ,   @OPEN_DATE      DATETIME	    -- ���� �� ��������� �� ��������
    ,   @DATE_ACT       DATETIME		-- ���� �� ���������� ������������� ���������
    ,   @STD_DOG_CODE   INT		    	-- ����������� ������� �� �������� ����� ���������
    ,   @PREF_CODE      INT OUT			-- ���� �� � ���� �� ������������� ����� �� ������ ������
    ,   @PREF_NAME      varchar(50) OUT	-- ����� �� ������������� ����� �� ������
)
AS
	-- ����� ������ ������������ �����������
	-- ���� ����� ������ � ��������� �����������
	SELECT TOP 1
			@PREF_CODE = T.CODE
		,	@PREF_NAME = PREFERENCE_NAME 
	FROM PREFERENCIAL_TAXES T WITH(NOLOCK)
	INNER JOIN PREFERENCIAL_TAXES_TO_DEALS TD WITH(NOLOCK)
		ON	T.CODE = TD.PREFERENCIAL_TAX_CODE
		AND T.PREFERENCE_STATUS = 1						-- ��������� �����������
		OR
			( /* ������� �����������, �� ������� � �� �������� �������� @DATE_ACT -> �� ��� � ������� */
				T.CODE = TD.PREFERENCIAL_TAX_CODE
				AND T.PREFERENCE_STATUS = 2				-- ����������� � ������� ���� �� ���������
				AND @DATE_ACT BETWEEN T.DATE_VALID_FROM AND T.DATE_VALID_TO
			)
	INNER JOIN PREFERENCIAL_EVENTS_TAXES ET  WITH(NOLOCK)
		ON	T.CODE = ET.PREFERENCE_CODE
	WHERE	(	dbo.CHECKBIT( T.STATUS, 12 ) = 1 OR		-- ������������ �����������
				dbo.CHECKBIT( T.STATUS, 13 ) = 1 )		-- ��������� �����������
			AND ET.TAX_CODE  = @TAX_CODE
			AND TD.DEAL_TYPE = @DEAL_TYPE
			AND TD.DEAL_NUM  = @DEAL_NUM
			AND CAST( T.DATE_VALID_FROM AS DATE ) <= @DATE_ACT -- ����������� ���� ���������� � ��������� �
			AND CAST( T.DATE_VALID_TO   AS DATE ) >= @DATE_ACT -- ������� �� ��������� �� ����������
			AND ( @OPEN_DATE <= 0 OR 
					( ( T.DATE_OPEN_FROM <= 0 OR T.DATE_OPEN_FROM <= @OPEN_DATE )
						AND ( T.DATE_OPEN_TO <= 0 OR T.DATE_OPEN_TO >= @OPEN_DATE ) ) )
	ORDER BY CASE WHEN dbo.CHECKBIT( T.STATUS, 12 ) = 1 THEN 1
					WHEN dbo.CHECKBIT( T.STATUS, 13 ) = 1 THEN 2
					ELSE 3
				END
GO
