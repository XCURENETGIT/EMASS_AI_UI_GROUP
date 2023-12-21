package com.xcurenet.emass.analysis.service;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

public class ModelDataCopy {
	private final static String FIRST_GET = "GET";
	private final static String FIRST_SET = "SET";

	public static Object copy(Object original, Object copyObject)
	{
		Class<?> originalClass = original.getClass();
		Class<?> copyClass = copyObject.getClass();

		try {
			for(Method originalMethod : originalClass.getMethods())
			{
				if(methodNameCheck(originalMethod.getName(), FIRST_GET))
				{
					Object result = originalMethod.invoke(original, new Object[]{});

					Method method = getCopySetMethod(copyClass, originalMethod.getName());

					if(method != null)
						method.invoke(copyObject, new Object[]{result});
				}
			}
		} catch (IllegalArgumentException e) {
			//log.error("Model Copy IllegalArgumentException");
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			//log.error("Model Copy IllegalAccessException");
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			//log.error("Model Copy InvocationTargetException");
			e.printStackTrace();
		}

		return copyObject;
	}

	public static List<List<Object>> list(List<?> originalList, String[] methodNames)
	{
		List<List<Object>> list = new ArrayList<>();
		List<Object> objs = new ArrayList<>();

		for (Object original : originalList) {
			Class<?> originalClass = original.getClass();
			objs = new ArrayList<>();
			try {
				for(String methodName : methodNames)
				{
					Method method = getCopyCehckMethod(methodName, originalClass.getMethods());
					if(method != null) {
						Object result = method.invoke(original, new Object[]{});
						objs.add(result);
					}
				}
				list.add(objs);
			} catch (IllegalArgumentException e) {
				//log.error("Model Copy IllegalArgumentException");
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				//log.error("Model Copy IllegalAccessException");
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				//log.error("Model Copy InvocationTargetException");
				e.printStackTrace();
			}
		}

		return list;
	}

	private static boolean methodNameCheck(String originalMethodName, String firstName)
	{
		if(originalMethodName.toUpperCase().indexOf(firstName) == 0)
			return true;
		else
			return false;
	}

	private static Method getCopySetMethod(Class<?> classObject, String methodName)
	{
		methodName = methodName.substring(3);
		for(Method method : classObject.getMethods())
		{
			if(method.getName().toUpperCase().equals(FIRST_SET+methodName.toUpperCase()))
				return method;
		}

		return null;
	}

	private static Method getCopyCehckMethod(String checkMethodName, Method[] originalMethods)
	{
		for(Method method : originalMethods)
		{
			String methodName = method.getName();
			if(methodNameCheck(methodName, FIRST_GET))
			{
				if(checkMethodName.toUpperCase().equals(methodName.substring(3).toUpperCase()))
					return method;
			}
		}

		return null;
	}
}
