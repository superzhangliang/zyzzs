package com.gdcy.zyzzs.util;

public class Constants {
	
	/** 缓存登录用户 */
	public static final String SESSION_USER="user";
	
	public static final String SESSION_NODE="node";
	
	/** 服务器路径 */
	public static final String BASEPATH="basepath";
	
	/** 短信签名 */
	public static final String SMSTAIL = "smstail";
	
	//无害化处理入口，1：进场时；2：检疫时
	public static final Integer HARMLESS_OPERATION_TYPE_ENTRY = 1;
	
	public static final Integer HARMLESS_OPERATION_TYPE_QUARANTINE = 2;
	
	
	public static final Integer REPORT_NO = 0;//是否已上报（否）
	
	public static final Integer REPORT_YES = 1;//是否已上报（是）
	
	public static final String REPORT_FLAG_BATCH = "batch";
	
	public static final String REPORT_FLAG_INPUTS = "inputs";
	
	public static final String REPORT_FLAG_OUT = "out";
	
	public static final String REPORT_FLAG_PURCHASE = "purchase";
	
	public static final String REPORT_FLAG_HARVEST = "harvest";
	
	public static final String PRINT_NO = "0";//不打印
	public static final String PRINT_YES = "1";//打印
	
	public static final Integer TYPE_MEAT = 1;//肉类
	public static final Integer TYPE_VEGETABLES = 2;//菜类
	
	public static final String TYPE_NAME_MEAT = "肉类";//1
	public static final String TYPE_NAME_VEGETABLES = "菜类";//2
	
	public static final String TYPE_BREED = "养殖";//1
	public static final String TYPE_PLANT = "种植";//2
	
	//
	public static final Integer ORIGIN_INPUTS_TYPE_SEED=1;//种子
	public static final Integer ORIGIN_INPUTS_TYPE_PESTICIDES=2;//农药
	public static final Integer ORIGIN_INPUTS_TYPE_FERTILIZER=3;//化肥
	public static final Integer ORIGIN_INPUTS_TYPE_PUPS=4;//幼崽
	public static final Integer ORIGIN_INPUTS_TYPE_FEED=5;//饲料
	public static final Integer ORIGIN_INPUTS_TYPE_DRUG=6;//兽药
	public static final Integer ORIGIN_INPUTS_TYPE_OTHER=7;//其他
	
	public static final String ORIGIN_INPUTS_TYPE_SEED_NAME="种子";
	public static final String ORIGIN_INPUTS_TYPE_PESTICIDES_NAME="农药";
	public static final String ORIGIN_INPUTS_TYPE_FERTILIZER_NAME="化肥";
	public static final String ORIGIN_INPUTS_TYPE_PUPS_NAME="幼崽";
	public static final String ORIGIN_INPUTS_TYPE_FEED_NAME="饲料";
	public static final String ORIGIN_INPUTS_TYPE_DRUG_NAME="兽药";
	public static final String ORIGIN_INPUTS_TYPE_OTHER_NAME="其他";
	
	//检测结果
	public static final Integer PURCHASEINPUTS_RESULT_TYPE_UNPASS=0;//检验不合格
	public static final Integer PURCHASEINPUTS_RESULT_TYPE_PASS=1;//检验合格
	public static final String PURCHASEINPUTS_RESULT_TYPE_UNPASS_NAME="检验不合格";
	public static final String PURCHASEINPUTS_RESULT_TYPE_PASS_NAME="检验合格";
	
	//上游是否建立电子台账
	public static final Integer UPPERREACHES_NO=0;//否
	public static final Integer UPPERREACHES_YES=1;//是
	public static final String UPPERREACHES_NO_NAME="否";
	public static final String UPPERREACHES_YES_NAME="是";
	
	//来源类型
	public static final Integer SOURCE_TYPE_SELF_PURCHASE=1;//自购
	public static final Integer SOURCE_TYPE_CULTIVATE=2;//栽培
	public static final Integer SOURCE_TYPE_AUTOTROPHIC=3;//自养
	public static final Integer SOURCE_TYPE_WILD=4;//野生
	public static final String SOURCE_TYPE_SELF_PURCHASE_NAME="自购";
	public static final String SOURCE_TYPE_CULTIVATE_NAME="栽培";
	public static final String SOURCE_TYPE_AUTOTROPHIC_NAME="自养";
	public static final String SOURCE_TYPE_WILD_NAME="野生";
	
	//是否有机
	public static final Integer ORGANIC_FLAG_NO=0;//否
	public static final Integer ORGANIC_FLAG_YES=1;//是
	public static final String ORGANIC_FLAG_NO_NAME="否";
	public static final String ORGANIC_FLAG_YES_NAME="是";
	
	//是否转基因
	public static final Integer TRANSGENIC_FLAG_NO=0;//否
	public static final Integer TRANSGENIC_FLAG_YES=1;//是
	public static final String TRANSGENIC_FLAG_NO_NAME="否";
	public static final String TRANSGENIC_FLAG_YES_NAME="是";
	
	//经营者类型
	public static final Integer BUSINESS_TYPE_SUPPLIER=1;//供应商
	public static final Integer BUSINESS_TYPE_BUYER=2;//买家
	public static final String BUSINESS_TYPE_SUPPLIER_NAME="供应商";
	public static final String BUSINESS_TYPE_BUYER_NAME="买家";
	
	//超级管理员
	public static final Long ROLE_SUPER_ADMIN = -1L;
	
	//投产类型
	public static final Integer FLAG_TYPE_PRODUCTION=1;//投产
	public static final Integer FLAG_TYPE_CONSERVE=2;//养护
	public static final String FLAG_TYPE_PRODUCTION_NAME="投产";
	public static final String FLAG_TYPE_CONSERVE_NAME="养护";
	
}
