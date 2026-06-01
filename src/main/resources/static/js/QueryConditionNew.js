var queryCon = {
		svc:[],
		direction_svc:"",
		work:"",
		businm:[],
		deptnm:[],
		host:[],
		host_str:[],
		senders:[],
		sender_str:[],
		account:[],
		sname:[],
		srcip:[],
		recvss:[],
		recvs:[],
		recvs_name:[],
		dstip:[],
		toCcBcc:[],
		toCcBccs:[],
		ocr_attach:[],
		allofus:[],
		attached:"",
		kwd:"",
		pi_total:[],
		userid:[],
		users:[],
		interUser:[],
		recvs_poid:[],
		epmsg_type:"",
		
		//정보 분류
		ml_confd_class:[],
		ml_confd_feedback:[],
		ml_confd_prob:[]
};

function setQueryMakeCondition(querys){
	var val = [];
	var key = "";
	var fieldFlag = true;
	for(var i=0; i<querys.length; i++) {
		if(querys[i].indexOf("-svc:(EMMA)") > -1) {
			querys[i] = querys[i].replace("-svc:(EMMA)","EMMAX");
		}
		
		if(querys[i].indexOf(":") != -1) {
			
			if(i != 0 && fieldFlag) settingQueryCondition(key, val);
			
			if(querys[i].startsWith('+') || querys[i].startsWith('-')) {
				if(querys[i].charAt(1) == "(") key = querys[i].replace('+','').replace('-','').substring(0, querys[i].indexOf(":")-1).replace('(','');
				else key = querys[i].replace('+','').replace('-','').substring(0, querys[i].indexOf(":")-1).replace('(','');
			}
			else if(querys[i].startsWith('(')) key = querys[i].replace('(','').substring(0, querys[i].indexOf(":")-1);
			else key = querys[i].replace('+','').replace('-','').substring(0, querys[i].indexOf(":"));
			
			val = [];
			fieldFlag = false;
			
			var excludeField = ["attachexistcnt", "pi_DRM", "pi_sct", "size", "body_size", "attach_size"];
			if(excludeField.includes(key)) continue;
			
			if(querys[i].charAt(querys[i].indexOf(":")+1) == "(") {
				if(querys[i].indexOf(")") != -1) val.push(querys[i].substring(querys[i].indexOf(":")+2, querys[i].length-1).replace('*', '').replace(')', ''));
				else val.push(querys[i].substring(querys[i].indexOf(":")+2, querys[i].length).replace('*', ''));
			} else if(querys[i].startsWith('(') && querys[i].charAt(querys[i].length-1) == ")") val.push(querys[i].substring(querys[i].indexOf(":")+1, querys[i].length-1).replace('*', '').replace(')', ''));
			else val.push(querys[i].substring(querys[i].indexOf(":")+1, querys[i].length).replace('*', '').replace(')', '')); 
			
		}
		
		if(querys[i].indexOf(":") == -1) {
			
			var excludeField = ["attachexistcnt", "pi_DRM", "pi_sct", "size", "body_size", "attach_size"];
			if(excludeField.includes(key)) continue;
			
			if(querys[i].indexOf(")") != -1) {
				val.push(querys[i].substring(0, querys[i].indexOf(")")).replace('*', '').replace(')',''));
			} else if(querys[i].startsWith('+') || querys[i].startsWith('-')) continue;
			else val.push(querys[i].replace('*', '').replace(')',''));
		}
		
		fieldFlag = true;
		if(i == querys.length-1 && fieldFlag) settingQueryCondition(key, val);
	}
}

function settingQueryCondition(field, value) {
	switch (field) {
		case "svc":
			queryCon.svc.push(value.join(','));
			break;
		case "direction_svc":
			queryCon.direction_svc += value;
			break;
		case "work":
			queryCon.work = value;
			break;
		case "ml_confd_class":
			queryCon.ml_confd_class += value;
			break;
		case "ml_confd_feedback":
			queryCon.ml_confd_feedback += value;
			break;
		case "ml_confd_prob":
			var result = [];
			for(var i = 0; i <value.length; i++) {
				if(value[i] != "TO") result.push(value[i].replace('[','').replace(']','')) 
			}
			queryCon.ml_confd_prob.push(result.join('|'));
			break;
		case "businm":
			queryCon.businm.push(value.join('|'));
			break;
		case "deptnm":
			queryCon.deptnm.push(value.join('|'));
			break;
		case "host":		
			queryCon.host.push(value.join('|'));
			break;
		case "host_str":
			queryCon.host_str.push(value.join('|'));
			break;
		case "sender_str":
		case "sname":
		case "srcip":
			for(var i=0; i<value.length; i++) {
				if(!queryCon.senders.includes(value[i])) {
					queryCon.senders.push(value[i]);
				}
			}
			break;
		case "account":
			for(var i=0; i<value.length; i++) {
				if(!queryCon.account.includes(value[i])) {
					queryCon.account.push(value[i]);
				}
			}
			break;
		case "recvs":
		case "recvs_name":
		case "dstip":
			value = removeAstaric(value);
			for(var i=0; i<value.length; i++) {
				if(!queryCon.recvss.includes(value[i])) {
					queryCon.recvss.push(value[i]);
				}
			}
			break;
		case "to":
		case "cc":
		case "bcc":
			value = removeAstaric(value);
			for(var i=0; i<value.length; i++) {
				if(!queryCon.toCcBcc.includes(value[i])) {
					queryCon.toCcBcc.push(value[i]);
				}
			}
			break;
		case "ocr_attach":
			queryCon.ocr_attach.push(value.join(','));
			break;
		case "allofus":
			queryCon.allofus.push(value.join(' '));
			break;
		case "attached":
			queryCon.attached = value;
			break;
		case "attachtype":
			if(queryCon.attached == "") queryCon.attached = "Y";
			break;
		case "kwd":
			queryCon.kwd = value;
			break;
		case "kwds":
			if(queryCon.kwd == "") queryCon.kwd = "Y";
			break;
		case "pi_total":
			if(value[0] == 0) queryCon.pi_total.push(0);
			else queryCon.pi_total.push(1);
			break;
		case "user":
		case "name":
		case "user_str":
			for(var i=0; i<value.length; i++) {
				if(!queryCon.users.includes(value[i])) {
					queryCon.users.push(value[i]);
				}
			}
		case "userid":
			value = removeAstaric(value);
			for(var i=0; i<value.length; i++) {
				if(!queryCon.users.includes(value[i]) && !queryCon.interUser.includes(value[i])) {
					queryCon.interUser.push(value[i]);
				}
			}
			break;
		case "recvs_poid":
			queryCon.recvs_poid.push(value.join('|'));
			break;
		case "epmsg_type":
			queryCon.epmsg_type = value;
			break;
	}
	//ex.) condtionNew.js
}

function setDisplayCondtion(queryCondition) {
	$('#feedbackTypeSelect').selectpicker('val',stringToArray(queryCondition.ml_confd_feedback, '"')); //피드백
	$('#infoTypeSelect').selectpicker('val', stringToArray(queryCondition.ml_confd_class, '"')); // 정보분류	
	$('#serviceTypeSelect').selectpicker('val', stringToArray(queryCondition.svc.join(','), ',')); //서비스
	$('#allOfus').selectpicker('val', queryCondition.allofus);	// 수신자 구분
	$('#recvs_poid').selectpicker('val', stringToArray(queryCondition.recvs_poid.join('|'), '|')); // 직급
	$('#probTypeSelect').selectpicker('val', stringToArray(queryCondition.ml_confd_prob)); // 정보분류
	$('#epmsgTypeSelect').selectpicker('val', stringToArray(queryCondition.epmsg_type, '|'));	//대외비
	
	$('[name=work]:radio[value="' + queryCondition.work.toString() + '"]').click();
	$('[name=receiveSend]:radio[value="' + queryCondition.direction_svc.toString() + '"]').click();
	
	$('#busi').val(queryCondition.businm.join('|')); // 사업장명
	$('#dept').val(queryCondition.deptnm.join('|')); // 부서명
	$('#ocr').val(queryCondition.ocr_attach.join('|')); // OCR
	if(queryCondition.interUser.length != 0) setConUserGroup(queryCondition.interUser); 
	$('#user').val(queryCondition.users.join('|')); // 사용자
	$('#sender').val(queryCondition.senders.join('|')); // 발신자
	$('#account').val(queryCondition.account.join('|')); // 접속계정
	
	for(var i = 0; i < queryCondition.host.length; i++) {
 		 if(queryCondition.host[i] != queryCondition.host_str[i])  {
 		 	queryCondition.host.splice(i, 1);
		    i--;
 		 }
	}
	
	$('#host').val(queryCondition.host.join('|')); // URL
	
	if(queryCon.toCcBcc.length > 0) $('#receive').val(queryCondition.recvss.join('|') + '|' + queryCon.toCcBcc.join('|'));
	else $('#receive').val(queryCondition.recvss.join('|')); // 수신자 + to cc bcc
	
	$('[name=attachYn]:radio[value="' + queryCondition.attached.toString() + '"]').click();
	$('[name=keywordYn]:radio[value="' + queryCondition.kwd.toString() + '"]').click();
	
	if(queryCondition.pi_total.length != 0 && queryCondition.pi_total[0] == 0) $('[name=regexpYn]:radio[value="N"]').click();
	else if(queryCondition.pi_total[0] == 1) $('[name=regexpYn]:radio[value="Y"]').click();
}

function stringToArray( string, spector ){
	if( string == null || string == undefined || string == '' ) return '';
	else if( typeof string !='string') return string;
	else{
		return string.split(spector);
	}
}


function removeAstaric(data) {
	var result = [];
	for(var i = 0; i < data.length; i++) {
		result[i] = data[i].replace('*','');
	}
	
	return result;
}

function setAdminUser(groupItem) {
	var adminGroupSeq = [];
	ui.get({
		url : 'getConAdminUserGroupList.xcn',
		itemList : groupItem.join(','),
		success: function(data, total) {
			if(data.length == 0) {
				$('#user').val($('#user').val() + groupItem.join(' | '));
				return;
			} else {
				for(var i=0; i < data.length; i++) {
					adminGroupSeq.push(data[i].groupSeq);
				}
			}
		},
		error : function(message) {
			
		},
		complete : function() {
			$("#interUserGroupSeq").selectpicker('val', adminGroupSeq);
			$("#interUserGroupSeq").selectpicker('refresh');
		}
	});
}

function setConUserGroup(groupItem) {
	var interGroupSeq = [];
	ui.get({
		url : 'getConUserGroupList.xcn',
		itemList : groupItem.join(','),
		success: function(data, total) {
		
			if(data.length == 0) {
				setAdminUser(groupItem);
				return;
			} else {
				for(var i=0; i < data.length; i++) {
					interGroupSeq.push(data[i].groupCode);
				}
			}
			$("#userGroupSeq").selectpicker('val', interGroupSeq);
			$("#userGroupSeq").selectpicker('refresh');
		},
		error : function(message) {
			
		},
		complete : function() {
		}
	});
}