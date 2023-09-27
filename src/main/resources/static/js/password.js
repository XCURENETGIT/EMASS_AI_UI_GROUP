
/**
 * 패스워드 체크 함수
 * @param uid : 사용자 아이디
 * @param upw : 사용자 패스워드
 * @param bpw : 과거 패스워드
 * @return
 */

function validationPassword( uid, upw, bpw )
{
	var com_msg = passwordJS.pwMix + '\n';

	password = upw.toLowerCase();
	var num_length = [9, 12]; 	// 패스워드 길이
	var totalStressCnt = 3; 	// 패스워드 조합 강도
	var sameChar = 3; 			// 패스워드 연속된 동일 문자

	var lower = 'abcdefghijklmnopqrstuvwxyz';
	var sChar = "!@#$%^&*()[]\|<>?,./";
	var number = '1234567890';
	if( sha256_digest( upw ) == bpw )
	{
		alert( passwordJS.noPast );
		return false;
	}

	if ( uid == upw )
	{
		alert( passwordJS.notAccount );
        return false;
	}

	if ( password.length < num_length[0] ){
		alert( com_msg + passwordJS.notUp );
		return false;
	}
	
	if ( password.length > num_length[1] ){
		alert( com_msg + passwordJS.notDown );
		return false;
	}

	var discordanceChar = false;
	for ( var i=0 ; i < password.length ; i++ )
	{
		var lo = lower.indexOf( password.charAt(i) );
		var sc = sChar.indexOf( password.charAt(i) );
		var nu = number.indexOf( password.charAt(i) );
		if ( lo < 0 && sc < 0 && nu < 0 ) discordanceChar = true;
	}
	///if ( discordanceChar ) {
	//	alert( com_msg + '지원되지 않는 문자가 포함 되어 있습니다.\n지원되는 문자는 아래와 같습니다.\n1.영소(a-z)\n2.영대(A-Z)\n3.숫자(0-9)\n4.특수문자(!@#$%^&*()[]\|<>?,./)' );
	//	return false;
	//}

	var lowerFlag = false;
	var sCharFlag = false;
	var numberFlag = false;
	for ( var i=0 ; i < password.length ; i++ )
	{
		if ( lower.indexOf( password.charAt(i) ) > -1 ) lowerFlag = true;
		if ( sChar.indexOf( password.charAt(i) ) > -1 ) sCharFlag = true;
		if ( number.indexOf( password.charAt(i) ) > -1 ) numberFlag = true;
	}
	var totalSequenceCnt = 0;
	if ( lowerFlag ) totalSequenceCnt++;
	if ( sCharFlag ) totalSequenceCnt++;
	if ( numberFlag ) totalSequenceCnt++;
	if ( totalSequenceCnt < totalStressCnt ) {
		//alert( com_msg + passwordJS.notCombination + '\n' + passwordJS.combiMsg1 + '\n' + passwordJS.combiMsg2 + '\n' + passwordJS.combiMsg3 + '\n' + passwordJS.combiMsg4 + '\n' + '위 3가지 중 ' + totalStressCnt + '가지 항목 이상을 포함해야 합니다.' );
		alert( com_msg + passwordJS.notCombination + '\n' + passwordJS.combiMsg1 + '\n' + passwordJS.combiMsg2 + '\n' + passwordJS.combiMsg3 + '\n' + passwordJS.combiMsg4 + '\n' + passwordJS.combiMsg5 );
		return false;
	}

	var chr_pass_0;
	var chr_pass_1;
	var chr_pass_2;

	var SamePass_0 = 0;
	var SamePass_1 = 1;
	var SamePass_2 = 1;
    for( var i=0 ; i < password.length ; i++)
    {
    	chr_pass_0 = password.charAt(i);
    	chr_pass_1 = password.charAt(i+1);
    	chr_pass_2 = password.charAt(i+2);

      	if( chr_pass_0 == chr_pass_1 && chr_pass_1 == chr_pass_2 )
  		{
      		SamePass_0 = sameChar; //동일문자 카운트

  		}

      	if( chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1 ) SamePass_1++;
      	if( chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1 ) SamePass_2++;
    }
    if ( SamePass_0 >= sameChar ) {
    	alert( com_msg + passwordJS.notContinue);
    	return;
    }
    
    if ( SamePass_1 > 1 ) {
    	alert( com_msg + passwordJS.notAsc );
    	return;
    }
    
    if ( SamePass_2 > 1 ) {
    	alert( com_msg + passwordJS.notDesc );
    	return;
    }
    return true;
}