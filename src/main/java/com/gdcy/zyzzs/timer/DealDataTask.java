package com.gdcy.zyzzs.timer;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.controller.BaseController;
import com.gdcy.zyzzs.pojo.Business;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.service.BusinessService;
import com.gdcy.zyzzs.service.NodeService;
import com.gdcy.zyzzs.util.PropertiesUtil;

@Component("dealDataTask")
public class DealDataTask {
	private Logger log = Logger.getLogger(this.getClass());
	
	@Resource
	private NodeService nodeService;
	
	@Resource
	private BusinessService businessService;
	
	/**
	 * 经营者信息上报
	 */
	public void saveBusiness(){
		try{
			log.info("经营者信息上报开始·····································································");
			Node nodeRecord = new Node();
			nodeRecord.setIsDelete(0);
			List<Node> listNode = this.nodeService.selectByEntity(nodeRecord);
			if( listNode != null && listNode.size() > 0 ){
				for( Node node : listNode ){
					Business businessRecord = new Business();
					businessRecord.setIsDelete(0);
					businessRecord.setNodeId(node.getId());
					List<Business> listBusiness = this.businessService.selectByEntity(businessRecord);
					if( listBusiness != null && listBusiness.size() > 0 ){
						JSONObject jo = new JSONObject();
						jo.put("method", "sBusinessBaseInfo");
						jo.put("recordNodeId", node.getCode() );
						jo.put("recordNodeName", node.getName() );
						List<JSONObject> list = new ArrayList<JSONObject>();
						for( Business business : listBusiness ){
							JSONObject job = new JSONObject();
							job.put("bizId", business.getCode());
							job.put("bizName", business.getName());
							job.put("regId", business.getRegId());
							job.put("property", business.getProperty());
							job.put("businessType", business.getType());
							job.put("recordDate", business.getRecordDate());
							job.put("legalRepresent", business.getLegalRepresent());
							job.put("tel", business.getTel());
							list.add(job);
						}
						jo.put("list", list);
						
						BaseController bc = new BaseController();
						String cszsURL = (String) PropertiesUtil.getProperty("cszsURL", PropertiesUtil.PROP_CONSTANTS_FILE);
						String joStr = JSON.toJSONString(jo);
						bc.dealDataToCszs(cszsURL, joStr);
					}
				}
			}
		}catch( Exception e ){
			log.error("经营者信息上报异常！", e);
		}
	}
	
}
