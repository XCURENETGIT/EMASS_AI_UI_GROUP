package com.xcurenet.common.util;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class SolrQueryString {

	private StringBuffer query = new StringBuffer();

	@Override
	public String toString() {
		String queryString = query.toString();
		return Common.isEmpty(queryString) ? "*:*" : queryString;
	}

	/**
	 * Wildcard 포함.
	 * @param name
	 * @param value
	 * @return SolrQueryString
	 */
	public SolrQueryString add(String name, Object value) {
		return add(name, value, true);
	}

	/**
	 * Wildcard 포함.
	 * @param name
	 * @param value
	 * @param addAnd
	 * @return SolrQueryString
	 */
	public SolrQueryString add(String name, Object value, boolean addAnd) {
		if(Common.isEmpty(value)) return this;

		add(name, value, addAnd, false);
		return this;
	}

	/**
	 * Wildcard 없거나 직접 입력시 사용.
	 * @param name
	 * @param value
	 * @param addAnd
	 * @param wildcardYN
	 * @return SolrQueryString
	 */
	public SolrQueryString add(String name, Object value, boolean addAnd, boolean wildcardYN) {
		value = deleteBlank(value);
		if(Common.isEmpty(value)) return this;

		if(addAnd)	and();
		if(wildcardYN) {
			query.append(name).append(":*").append(spaceCheck(String.valueOf(value))).append("*");
		} else {
			if(String.valueOf(value).indexOf("*") > -1) {
				query.append(name).append(":").append(spaceCheck(String.valueOf(value)));
			} else {
				if(String.valueOf(value).indexOf(" ") > -1
						&& !(String.valueOf(value).indexOf("(") == 0 && String.valueOf(value).indexOf(")") == (String.valueOf(value).length()-1))
						|| (String.valueOf(value).indexOf("(") > 0 || String.valueOf(value).indexOf(")") > 0)
						|| (String.valueOf(value).indexOf("[") > 0 || String.valueOf(value).indexOf("]") > 0)
						|| (String.valueOf(value).indexOf("{") > 0 || String.valueOf(value).indexOf("}") > 0)) {
					query.append(name).append(":").append("(").append("\"").append(String.valueOf(value)).append("\"").append(")");
				} else if(String.valueOf(value).indexOf(",") > -1){
					String[] values = String.valueOf(value).split(",");
					String val = Arrays.stream(values).map(v -> " (\"".concat(v).concat("\")")).collect(Collectors.joining());
					query.append(name).append(":").append("(").append(String.valueOf(val)).append(")");
				}
				else {
					query.append(name).append(":").append("\"").append(value).append("\"").append(" ");
				}
			}
		}

		return this;
	}

	/**
	 * 여러개 값 입력
	 * @param name
	 * @param valueList
	 * @return SolrQueryString
	 */
	public SolrQueryString add(String name, List<Object> valueList) {
		return add(name, valueList, true);
	}

	/**
	 * 여러개 값 입력
	 * @param name
	 * @param valueList
	 * @param addAnd
	 * @return SolrQueryString
	 */
	public SolrQueryString add(String name, List<Object> valueList, boolean addAnd) {
		if(valueList == null || valueList.isEmpty()) {
			return this;
		}

		if(addAnd)	and();
		StringBuffer sb = new StringBuffer();
//		sb.append("(");
		sb.append("<");
		for (Object object : valueList) {
			sb.append("\"").append(object).append("\" ");
		}
//		sb.append(")");
		sb.append(">");
		query.append(name).append(":").append(sb).append(" ");
		return this;
	}

	/**
	 * 여러개 name 입력
	 * @param name
	 * @param value
	 * @return SolrQueryString
	 */
	public SolrQueryString add(String[] names, String value) {
		return add(names, value, true);
	}

	/**
	 * 여러개 name 입력
	 * @param name
	 * @param value
	 * @param addAnd
	 * @return SolrQueryString
	 */
	public SolrQueryString add(String[] names, String value, boolean addAnd) {
		value = deleteBlank(value);
		if(Common.isEmpty(value) || names.length == 0) return this;

		if(addAnd) and();
//		beforeParen();
		add(names[0], value, false);
		for (int i = 1; i < names.length; i++) {
			or();
			add(names[i], value, false);
		}
//		afterParen();
		return this;
	}

	/**
	 * n글자 이하 차이가 나는 문자열에 대해서도 검색을 한다.
	 * @param name
	 * @param value
	 * @param n
	 * @param addAnd
	 * @return SolrQueryString
	 */
	public SolrQueryString addFuzzy(String name, String value, int n, boolean addAnd) {
		value = deleteBlank(value);
		if(Common.isEmpty(value) || Common.isEmpty(name)) return this;

		if(addAnd)	and();
		query.append(name).append(":").append(spaceCheck(value)).append("~").append(n);
		return this;
	}

	/**
	 * first와 second 사이에 n개 이하의 단어가 들어간 것도 검색한다.
	 * 예) "jakarta apache"~10 이라고 쓰면 jakarta와 apache 사이에 10개 이하의 단어가 들어간 것도 검색한다.
	 * @param name
	 * @param first
	 * @param second
	 * @param n
	 * @return SolrQueryString
	 */
	public SolrQueryString addProximity(String name, String first, String second, int n) {
		return addProximity(name, first, second, n, true);
	}

	/**
	 * first와 second 사이에 n개 이하의 단어가 들어간 것도 검색한다.
	 * 예) "jakarta apache"~10 이라고 쓰면 jakarta와 apache 사이에 10개 이하의 단어가 들어간 것도 검색한다.
	 * @param name
	 * @param first
	 * @param second
	 * @param n
	 * @param addAnd
	 * @return SolrQueryString
	 */
	public SolrQueryString addProximity(String name, String first, String second, int n, boolean addAnd) {
		if(addAnd)	and();
		query.append(name).append(":\"").append(first).append(" ").append(second).append("\"~").append(n);
		return this;
	}

	/**
	 * 작성한 Query 입력
	 * @param solrQuery
	 */
	public SolrQueryString add(String inputQuery) {
		if(Common.isNotEmpty(inputQuery)) {
			and();
			query.append("(").append(inputQuery).append(")");
		}
		return this;
	}

	/**
	 * 작성한 Query 입력
	 * @param solrQuery
	 */
	public SolrQueryString justAdd(String inputQuery) {
		if(Common.isNotEmpty(inputQuery)) {
			and();
			query.append(inputQuery);
		}
		return this;
	}

	/**
	 * 작성한 Query 입력
	 * @param solrQuery
	 */
	public SolrQueryString add(SolrQueryString solrQuery) {
		if(Common.isNotEmpty(solrQuery)) {
			query.append(solrQuery);
		}
		return this;
	}

	/**
	 * 기간 입력 (앞뒤 값 포함)
	 * @param name
	 * @param start
	 * @param end
	 * @return SolrQueryString
	 */
	public SolrQueryString addRange(String name, Object start, Object end) {
		return addRange(name, start, end, true);
	}

	/**
	 * 기간 입력 (앞뒤 값 포함)
	 * @param name
	 * @param start
	 * @param end
	 * @param addAnd
	 * @return SolrQueryString
	 */
	public SolrQueryString addRange(String name, Object start, Object end, boolean addAnd) {
		return addRange(name, start, end, addAnd, true, true);
	}

	/**
	 * 기간 입력 (앞뒤 값 포함 선택)
	 * @param name
	 * @param start
	 * @param end
	 * @param addAnd
	 * @param startIncludeYN
	 * @param endIncludeYN
	 * @return SolrQueryString
	 */
	public SolrQueryString addRange(String name, Object start, Object end, boolean addAnd, boolean startIncludeYN, boolean endIncludeYN) {

		start = deleteBlank(start);
		end = deleteBlank(end);
		if(Common.isEmpty(name) || (Common.isEmpty(start) && Common.isEmpty(end))) return this;
		if(Common.isEmpty(start)) start = "*";
		if(Common.isEmpty(end)) end = "*";
		if(addAnd)	and();

		query.append(name).append(":");
		if(startIncludeYN) {
			query.append("[");
		} else {
			query.append("{");
		}
		query.append(start).append(" TO ").append(end);
		if(endIncludeYN) {
			query.append("]");
		} else {
			query.append("}");
		}
		return this;
	}

	public SolrQueryString plus() {
		if(query.length() > 3) {
			query.append("+");
		}
		return this;
	}

	public SolrQueryString minus() {
//		if(query.length() > 3) {
		query.append("-");
//		}
		return this;
	}

	public SolrQueryString and() {
		if(query.length() > 3) {
			query.append(" && ");
		}
		return this;
	}

	public SolrQueryString and(String value) {
		if(Common.isNotEmpty(value)) {
			query.append(" && ");
		}
		return this;
	}

	public SolrQueryString or() {
		if(query.length() > 3) {
			query.append(" || ");
		}
		return this;
	}

	public SolrQueryString or(String value) {
		if(Common.isNotEmpty(value)) {
			query.append(" || ");
		}
		return this;
	}

	public SolrQueryString beforeParen() {
		query.append("(");
		return this;
	}

	public SolrQueryString afterParen() {
		if(query.indexOf("(") > -1) {
			query.append(")");
		}
		return this;
	}

	public SolrQueryString not() {
		query.append("!");
		return this;
	}

	public SolrQueryString question() {
		query.append("?");
		return this;
	}

	public SolrQueryString space() {
		query.append(" ");
		return this;
	}

	/**
	 * 값에서 공백 체크하여 있으면 "붙혀서 넘김.
	 * @param value
	 * @return
	 */
	private String spaceCheck(String value) {
		StringBuffer sb = new StringBuffer();
		return (value.contains(" ") ? sb.append("\"").append(value).append("\"") : sb.append(value)).toString();
	}

	private String deleteBlank(String value) {
		return Common.isEmpty(value) ? "" : value.toString().trim();
	}

	private Object deleteBlank(Object value) {
		if(value instanceof String) {
			return Common.isEmpty(value) ? "" : value.toString().trim();
		}
		return value;
	}
}
