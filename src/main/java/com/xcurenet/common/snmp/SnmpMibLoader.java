package com.xcurenet.common.snmp;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;

import javax.annotation.PostConstruct;

import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;
import net.percederberg.mibble.Mib;
import net.percederberg.mibble.MibLoader;
import net.percederberg.mibble.MibLoaderException;
import net.percederberg.mibble.MibLoaderLog;
import net.percederberg.mibble.MibValueSymbol;

/**
 * Mib 파일을 읽고 해당하는 OID 값을 미리 메모리에 저장 해 놓는다. SNMP로 통신을 담당하지는 않으며, 단순히 파일의 OID만을
 * 추출 한다.
 *
 * @author jochangmin
 * @since 2012-11-14
 */
@Service
@Slf4j
public class SnmpMibLoader {

	private static List<TreeMap<String, String>> xcurenetMib;

	private static final String MIBPATH = "/users/apache/mibs/";

	@PostConstruct
	public void load() throws Exception {
		log.info("SNMP MIBS LOADER START....");
		xcurenetMib = new ArrayList<TreeMap<String, String>>();
		loadOid(mibLoader());
		log.info("SNMP MIBS LOADER END....");
	}

	/**
	 * TableName to Table Field map key fieldName, value oid
	 *
	 * @param tableName
	 * @return
	 */
	public TreeMap<String, String> getTableEntry(String tableName) {
		for (int i = 0; i < xcurenetMib.size(); i++) {
			TreeMap<String, String> item = xcurenetMib.get(i);
			if (item.get(tableName) != null) return item;
		}
		return new TreeMap<String, String>();
	}

	/**
	 * TableName to Table Field map key oid, value fieldName
	 *
	 * @param tableName
	 * @return
	 */
	public TreeMap<String, String> getTableEntryOid(String tableName) {
		TreeMap<String, String> result = new TreeMap<String, String>();
		for (int i = 0; i < xcurenetMib.size(); i++) {
			TreeMap<String, String> item = xcurenetMib.get(i);
			if (item.get(tableName) != null) {
				Iterator<Entry<String, String>> iterator = item.entrySet().iterator();
				while (iterator.hasNext()) {
					Map.Entry<String, String> entry = iterator.next();
					result.put(item.get(entry.getKey()), entry.getKey());
				}
			}
		}
		return result;
	}

	/**
	 * entryName to OID
	 *
	 * @param entryName
	 * @return
	 */
	public String getOID(String entryName) {
		String result = "";
		if (xcurenetMib == null) return result;
		for (int i = 0; i < xcurenetMib.size(); i++) {
			TreeMap<String, String> item = xcurenetMib.get(i);
			if (item.get(entryName) != null) return item.get(entryName);
		}
		return result;
	}

	/**
	 * Xcurenet에서 사용되는 Mib List OID Loader
	 *
	 * @param mib
	 * @throws Exception
	 */
	private void loadOid(Mib[] mib) throws Exception {
		if (mib == null) throw new Exception("Mib file was not loaded normally.");

		for (int j = 0; j < mib.length; j++) {
			if (!mib[j].isLoaded()) continue;

			Iterator<?> iterator = mib[j].getAllSymbols().iterator();
			while (iterator.hasNext()) {
				Object mibinfo = iterator.next();
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
	 * @return
	 * @throws MibLoaderException
	 * @throws IOException
	 */
	private Mib[] mibLoader() throws Exception {
		Mib[] result = null;
		MibLoader loader = new MibLoader();
		File file = new File(MIBPATH);
		if (file != null) {
			if (file.isDirectory()) {
				String[] list = file.list(new FilenameFilter() {
					@Override
					public boolean accept(File dir, String name) {
						return name.endsWith(".mib");
					}
				});
				loader.addDir(file);
				try {
					for (int j = 0; j < list.length; j++) {
						loader.load(new File(file.getAbsolutePath() + File.separator + list[j]));
					}
				} catch (MibLoaderException e) {
					MibLoaderLog log = e.getLog();
					log.printTo(System.out);
					e.printStackTrace();
				}
			}
			result = loader.getAllMibs();
		}
		return result;
	}
}
