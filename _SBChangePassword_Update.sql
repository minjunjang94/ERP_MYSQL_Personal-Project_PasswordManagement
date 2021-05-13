drop PROCEDURE _SBChangePassword_Update;

DELIMITER $$
CREATE PROCEDURE _SBChangePassword_Update
	(
		 InData_OperateFlag			CHAR(2)				-- 작업표시
		,InData_CompanySeq			INT					-- 법인내부코드
		,InData_UserId				VARCHAR(30)			-- 로그인ID
		,InData_LoginPwd			VARCHAR(50)			-- 로그인Pwd
		,InData_ChgLoginPwd			VARCHAR(50)			-- (변경)로그인Pwd
		,InData_ChgLoginPwdCheck	VARCHAR(50)			-- (변경확인)로그인Pwd
    )
BEGIN

	-- 변수선언
    DECLARE Var_GetDateNow			VARCHAR(100);    
    
	SET Var_GetDateNow  = (SELECT DATE_FORMAT(NOW(), "%Y%m%d") AS GetDate); -- 작업일시는 Update 되는 시점의 일시를 Insert  
    
    -- ---------------------------------------------------------------------------------------------------
    -- Update --
	IF( InData_OperateFlag = 'U' ) THEN    
    
			-- PasswordHis2 설정 --
 			UPDATE _TCBaseUser				AS A	
			   SET   PasswordHis2			= A.PasswordHis1		
			 WHERE   A.CompanySeq 			= InData_CompanySeq
               AND   A.UserId				= InData_UserId;   
    
			-- PasswordHis1 설정 --
			UPDATE _TCBaseUser				AS A
			   SET   PasswordHis1			= A.LoginPwd			
			 WHERE   A.CompanySeq 			= InData_CompanySeq
               AND   A.UserId				= InData_UserId;    
    
			-- LoginPwd 설정 --
			UPDATE _TCBaseUser				AS A
			   SET   LoginPwd				= InData_ChgLoginPwd	
					,PwdChgDate				= Var_GetDateNow
			 WHERE   A.CompanySeq 			= InData_CompanySeq
               AND   A.UserId				= InData_UserId;
                     
              SELECT '저장되었습니다.' AS Result; 
                     
	ELSE
			  SELECT '저장이 완료되지 않았습니다.' AS Result;
	END IF;	


END $$
DELIMITER ;