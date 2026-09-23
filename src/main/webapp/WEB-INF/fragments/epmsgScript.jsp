<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">
    /**
     * KNOX 메일 종류 : 코드 → 이름 매칭용 목록 (최초 1회만 조회해서 재사용)
     */
    var epmsgTypeNameMap = null;

    function getEpmsgTypeNameMap() {
        if (epmsgTypeNameMap != null) return epmsgTypeNameMap;
        epmsgTypeNameMap = {};
        ui.get({
            url: 'getEpmsgTypeNameList.xcn',
            asyncFlag: false,
            success: function (data, total) {
                for (var i = 0; i < data.length; i++) {
                    epmsgTypeNameMap[data[i].epmsgTypeCode] = data[i].epmsgTypeName;
                }
            },
            error: function (status, message) {
            }
        });
        return epmsgTypeNameMap;
    }

    /**
     * KNOX 메일 종류 : 저장된 조건값(코드)을 화면 표시용 이름으로 변환
     * 등록되지 않은 코드는 코드 그대로 표시
     */
    function getEpmsgTypeNameStr() {
        var map = getEpmsgTypeNameMap();
        var names = [];
        for (var i = 0; i < arguments.length; i++) {
            var val = arguments[i];
            if (val == null || val == undefined || val == '') continue;
            var codes = val.toString().split(',');
            for (var j = 0; j < codes.length; j++) {
                var code = codes[j];
                if (code == '') continue;
                names.push(map[code] != undefined ? map[code] : code);
            }
        }
        return names.join(',');
    }
</script>
