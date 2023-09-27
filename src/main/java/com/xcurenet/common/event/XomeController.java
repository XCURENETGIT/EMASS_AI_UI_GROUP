//package com.xcurenet.common.event;
//
//import java.io.IOException;
//import java.net.MalformedURLException;
//import java.net.URL;
//import java.util.ArrayList;
//import java.util.List;
//
//import javax.annotation.PostConstruct;
//
//import org.jsoup.Jsoup;
//import org.jsoup.nodes.Document;
//import org.jsoup.nodes.Element;
//import org.jsoup.select.Elements;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.annotation.Description;
//import org.springframework.messaging.handler.annotation.MessageMapping;
//import org.springframework.messaging.simp.SimpMessagingTemplate;
//import org.springframework.scheduling.TaskScheduler;
//import org.springframework.scheduling.concurrent.ConcurrentTaskScheduler;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestMethod;
//
//import com.xcurenet.common.util.Common;
//
//@Controller
//public class XomeController {
//
//	@Autowired
//	private SimpMessagingTemplate template;
//	private TaskScheduler scheduler = new ConcurrentTaskScheduler();
//	private List<Stock> stockPrices = new ArrayList<Stock>();
//
//	private final static String STOCK_URL = "http://hyper.moneta.co.kr/fcgi-bin/DelayedCurrPrice10.fcgi?code=%s&isReal=true";
//	private final static String SEARCHSTOCK = "http://paxnet.moneta.co.kr/stock/searchStock/searchStock.jsp?section=1";
//	private final static String SEARCHSTOCK2 = "http://paxnet.moneta.co.kr/stock/searchStock/searchStock.jsp?section=0";
//
//	private void updatePriceAndBroadcast() {
//		for (int i = 0; i < stockPrices.size(); i++) {
//			Stock stock = stockPrices.get(i);
//			try {
//				Document doc = Jsoup.parse(new URL(String.format(STOCK_URL, stock.getCode())), 2000);
//				stock.setNowToday(Common.nvz(doc.select(".item_info_lt strong").text().replaceAll(",", "")));
//
//				if (stock.getOldPrice() != stock.getNowToday() && stock.getNowToday() > 0) {
//
//					String str = "<div id=\"" + stock.getCode() + "\" class=\"item_info_lt\">";
//					str += "<h2><span>" + doc.select(".item_info_lt h2").html() + "</span></h2>";
//					str += doc.select(".item_info_lt span").outerHtml();
//					str += "<div>";
//					str += doc.select(".item_info_lt strong").outerHtml();
//					str += doc.select(".item_info_lt em").outerHtml();
//					str += doc.select(".item_info_lt p").outerHtml();
//					str += "</div>";
//					str += "<div>";
//					str += "<input type=\"button\" code=\"" + stock.getCode() + "\" onclick=\"deleteCode(this);\" value=\"Delete\" />";
//					str += "</div>";
//					str += "</div>";
//					stock.setHtml(str);
//					stock.setOldPrice(stock.getNowToday());
//					stockPrices.set(i, stock);
//
//					Stock s = new Stock();
//					s.setNowToday(stock.getNowToday());
//					s.setRate(doc.select(".item_info_lt em").html());
//					template.convertAndSendToUser("sysadmin", "/price", s);
//					//template.convertAndSendToUser("sysadmin", "/price", stock);
//					//System.out.println(stock.getCode() + " changed...");
//				}
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//
//		}
//	}
//
//	@PostConstruct
//	private void broadcastTimePeriodically() {
//		if(Common.isWindow()) return;
//		scheduler.scheduleAtFixedRate(new Runnable() {
//			@Override
//			public void run() {
//				updatePriceAndBroadcast();
//			}
//		}, 500);
//	}
//
//	@MessageMapping("/addStock")
//	public void addStock(Stock stock) throws Exception {
//		System.out.println(stock.getCode() + " addStock...");
//		boolean addFlag = true;
//		for (Stock so : stockPrices) {
//			if (Common.isEquals(so.getCode(), stock.getCode())) addFlag = false;
//		}
//		if (addFlag) {
//			updatePriceAndBroadcast();
//			stockPrices.add(stock);
//			template.convertAndSendToUser("sysadmin", "/addStock", stock);
//		}
//	}
//
//	@MessageMapping("/removeStocks")
//	public void removeStocks(Stock stock) {
//		System.out.println(stock.getCode() + " removeStocks...");
//		for (Stock stockItem : stockPrices) {
//			if (stockItem.getCode().equals(stock.getCode())) {
//				stockPrices.remove(stockItem);
//				template.convertAndSendToUser("sysadmin", "/removeItem", stock);
//				break;
//			}
//		}
//	}
//
//	@MessageMapping("/removeAllStocks")
//	public void removeAllStocks() {
//		System.out.println(" removeAllStocks...");
//		stockPrices.clear();
//		template.convertAndSendToUser("sysadmin", "/removeAll", stockPrices);
//	}
//
//	@MessageMapping("/getAllStock")
//	public List<Stock> getAllStock() throws Exception {
//		System.out.println(" getAllStock...");
//		template.convertAndSendToUser("sysadmin", "/getAllStock", stockPrices);
//		return stockPrices;
//	}
//
//	@MessageMapping("/getStockName")
//	public void getStockName(String name) throws MalformedURLException, IOException {
//		List<Stock> stocks = new ArrayList<Stock>();
//		stocks.addAll(searchStockName(SEARCHSTOCK, name));
//		if(stocks.size()<5){
//			stocks.addAll(searchStockName(SEARCHSTOCK2, name));
//		}
//		template.convertAndSendToUser("sysadmin", "/getStockName", stocks);
//	}
//
//	@MessageMapping("/getStockNow")
//	public void getStockNow(String code) throws MalformedURLException, IOException {
//		System.out.println("getStockNow:" + code);
//		List<Stock> stocks = new ArrayList<Stock>();
//		for (Stock s : stocks) {
//			if( s.getCode().equals(code) ){
//				template.convertAndSendToUser("sysadmin", "/getStockNow", s.getNowToday());
//				return;
//			}
//		}
//	}
//
//	private List<Stock> searchStockName(String url, String name) throws MalformedURLException, IOException {
//		List<Stock> stocks = new ArrayList<Stock>();
//		Document doc = Jsoup.parse(new URL(url), 2000);
//		Elements elements = doc.select(".tbl_type a");
//		for (int i = 0; i < elements.size(); i++) {
//			Element el = elements.get(i);
//			if (el.text().indexOf(name) > -1) {
//				System.out.println(el.text());
//				Stock stock = new Stock();
//				stock.setCode(el.attr("href").substring(el.attr("href").indexOf("code=") + 5));
//				stock.setName(el.text());
//				stocks.add(stock);
//				if(stocks.size()>=5) break;
//			}
//		}
//		return stocks;
//	}
//
//	@Description("테스트 페이지")
//	@RequestMapping(value = "/homex", method = RequestMethod.GET)
//	public String home() {
//		return "home";
//	}
//
//	public static void main(String[] args) {
//		String aa = "http://paxnet.asiae.co.kr/asiae/stockIntro/indCurrent.jsp?code=230240";
//
//		System.out.println(aa.substring(aa.indexOf("code=") + 5));
//	}
//}
