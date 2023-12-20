package com.xcurenet.common.snmp;

import lombok.extern.log4j.Log4j2;
import net.percederberg.mibble.*;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.*;
import java.util.Map.Entry;

/**
 * Mib 파일을 읽고 해당하는 OID 값을 미리 메모리에 저장 해 놓는다. SNMP로 통신을 담당하지는 않으며, 단순히 파일의 OID만을
 * 추출 한다.
 *
 * @author jochangmin
 * @since 2012-11-14
 */
@Log4j2
@Service
public class SnmpMibLoader {

	private static List<TreeMap<String, String>> xcurenetMib;

	private static final String MIBPATH = "/users/emasspro/conf/mibs/";

	@PostConstruct
	public void load() throws Exception {
		log.info("SNMP MIBS LOADER START....");
		xcurenetMib = new ArrayList<>();
		loadOid(mibLoader());
		log.info("SNMP MIBS LOADER END....");
	}

	/**
	 * TableName to Table Field map key fieldName, value oid
	 *
	 */
	public TreeMap<String, String> getTableEntry(String tableName) {
		for (TreeMap<String, String> item : xcurenetMib) {
			if (item.get(tableName) != null) return item;
		}
		return new TreeMap<String, String>();
	}

	/**
	 * TableName to Table Field map key oid, value fieldName
	 *
	 */
	public TreeMap<String, String> getTableEntryOid(String tableName) {
		TreeMap<String, String> result = new TreeMap<String, String>();
		for (TreeMap<String, String> item : xcurenetMib) {
			if (item.get(tableName) != null) {
				for (Entry<String, String> entry : item.entrySet()) {
					result.put(item.get(entry.getKey()), entry.getKey());
				}
			}
		}
		return result;
	}

	/**
	 * entryName to OID
	 *
	 */
	public String getOID(String entryName) {
		String result = "";
		if (xcurenetMib == null) return result;
		for (TreeMap<String, String> item : xcurenetMib) {
			if (item.get(entryName) != null) return item.get(entryName);
		}
		return result;
	}

	/**
	 * Xcurenet에서 사용되는 Mib List OID Loader
	 *
	 */
	private void loadOid(Mib[] mib) throws Exception {
		if (mib == null) throw new Exception("Mib file was not loaded normally.");

		for (Mib element : mib) {
			if (!element.isLoaded()) continue;

			for (Object mibinfo : element.getAllSymbols()) {
				if (!(mibinfo instanceof MibValueSymbol)) continue;
				MibValueSymbol value = (MibValueSymbol) mibinfo;

				if (value.isTableColumn()) continue;

				if (value.isTable() && value.getChildCount() > 0) {
					TreeMap<String, String> item = new TreeMap<String, String>();
					item.put(value.getName(), "." + value.getValue().toString());

					MibValueSymbol child = value.getChild(0);
					for (int i = 0; i < child.getChildCount(); i++) {
						MibValueSymbol column = child.getChild(i);
						item.put(column.getName(), "." + column.getValue().toString());
					}
					addItem(item);
				} else if (value.getChildCount() == 0) {
					addItem(value.getName(), "." + value.getValue().toString() + ".0");
				}
			}
		}
	}

	private void addItem(String name, String oid) {
		TreeMap<String, String> item = new TreeMap<String, String>();
		item.put(name, oid);
		addItem(item);
	}

	private void addItem(TreeMap<String, String> item) {
		xcurenetMib.add(item);
	}

	/**
	 * Mib Loader
	 *
	 */
	private Mib[] mibLoader() throws Exception {
		Mib[] result = null;
		MibLoader loader = new MibLoader();
		File file = new File(MIBPATH);
		if (file.isDirectory()) {
			String[] list = file.list(new FilenameFilter() {
				@Override
				public boolean accept(File dir, String name) {
					return name.endsWith(".mib");
				}
			});
			loader.addDir(file);
			try {
				for (String s : list) {
					loader.load(new File(file.getAbsolutePath() + File.separator + s));
				}
			} catch (MibLoaderException e) {
				log.error("", e);
			}
		}
		result = loader.getAllMibs();
		return result;
	}
}
