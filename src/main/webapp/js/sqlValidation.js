//过滤URL非法SQL字符
var sqlReg=/select|update|and|or|delete|insert|trancate|char|into|substr|ascii|declare|exec|count|master|into|drop|execute|'|;|>|<|%/i;

var sqlErrorTips = '您输入的内容中包含敏感字（select、update、and、or、delete、insert、trancate、char、'
	+'into、substr、ascii、declare、exec、count、master、into、drop、execute、\'、;、>、<、%等），请删除后再试！';

/**
 * 校验字符串是否包含sql注入敏感字
 * @param paramVal	需要校验的字符串
 * return	是否包含敏感字，true-包含，false-不包含
 */
function containSql(paramVal) {
	if (paramVal && paramVal != '') {
		if (sqlReg.test(paramVal)) {
			return true;
		} else {
			return false;
		}
	} else {
		return false;
	}
}

/**
 * 校验输入控件的值是否包含sql敏感字
 * @param inputId	控件ID。当flag为1时填入表单ID，检验表单内所有输入控件的输入值；
 * 	当flag为2时，填入需要验证的多个输入控件的ID值，多个以“,”分隔
 * @param flag	校验方式。1-表单验证，2-多控件逐个验证
 * return	是否包含sql敏感字，true-包含，false-不包含
 */
function validateSql(inputId, flag) {
	if (inputId && inputId != '' && flag) {
		if (flag == 1) {//表单校验
			var fields = $("#" + inputId).serializeArray();
			if (fields && fields.length > 0) {
				var obj, isContain = false;
				for (var i = 0, len = fields.length; i < len; i++) {
					obj = fields[i];
					if (obj && obj.value && $.trim(obj.value) != '' 
							&& containSql(obj.value)) {
						isContain = true;
						break;
					}
				}
				return isContain;
			} else {
				return false;
			}
		} else if (flag == 2) {//多控件校验
			var idArr = inputId.split(",");
			var val, isContain = false;
			for (var i = 0, len = idArr.length; i < len; i++) {
				if ($("#" + idArr[i])) {//如果对象存在
					val = $("#" + idArr[i]).val();
					if (val && $.trim(val) != '' && containSql(val)) {
						isContain = true;
						break;
					}
				}
			}
			return isContain;
		} else {
			return false;
		}
	} else {
		return false;
	}
}