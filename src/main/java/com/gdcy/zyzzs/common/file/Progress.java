package com.gdcy.zyzzs.common.file;

import java.math.BigDecimal;
import java.text.NumberFormat;

import com.alibaba.fastjson.JSONObject;

public class Progress {

	/**已上传字节**/
	private long uploadBytes = 0L;
	/**已上传MB**/
	private String uploadMb = "0";
	/**总大小**/
	private long length = 0L;
	/**正在上传第几个文件**/
	private int uploadItems;
	/**已上传百分比**/
	private String uploadPercent;
	/**上传速度**/
	private String uploadSpeed;
	/**上传开始时间**/
	private long startTime = System.currentTimeMillis();

	public long getUploadBytes() {
		return uploadBytes;
	}

	public void setUploadBytes(long uploadBytes) {
		this.uploadBytes = uploadBytes;
	}

	public String getUploadMb() {
		BigDecimal uploadBytes = new BigDecimal(this.uploadBytes);
		if (uploadBytes.equals(new BigDecimal(0)))
			return "0";
		this.uploadMb = uploadBytes.divide(new BigDecimal(1048576), 2,
				BigDecimal.ROUND_DOWN).toString();
		return this.uploadMb;
	}

	public void setUploadMb(String uploadMb) {
		this.uploadMb = uploadMb;
	}

	public long getLength() {
		return length;
	}

	public void setLength(long length) {
		this.length = length;
	}

	public int getUploadItems() {
		return uploadItems;
	}

	public void setUploadItems(int uploadItems) {
		this.uploadItems = uploadItems;
	}

	public String getUploadPercent() {
		NumberFormat percent = NumberFormat.getPercentInstance();
		percent.setMaximumFractionDigits(2);
		BigDecimal a = new BigDecimal(String.valueOf(uploadBytes));
		BigDecimal b = new BigDecimal(String.valueOf(length));
		if (a.equals(new BigDecimal(0)) || b.equals(new BigDecimal(0))
				|| a.equals(new BigDecimal(0.0))
				|| b.equals(new BigDecimal(0.0))) {
			return "0.00%";
		}
		BigDecimal c = a.divide(b, 4, BigDecimal.ROUND_DOWN);
		this.uploadPercent = percent.format(c);
		return this.uploadPercent;
	}

	public void setUploadPercent(String uploadPercent) {
		this.uploadPercent = uploadPercent;
	}

	public String getUploadSpeed() {
//		BigDecimal uploadBytes = new BigDecimal(this.uploadBytes * 1000);
//		BigDecimal useTime = new BigDecimal(System.currentTimeMillis()
//				- startTime);
//		if (uploadBytes.equals(new BigDecimal(0))
//				|| useTime.equals(new BigDecimal(0))) {
//			return "0";
//		}
//		BigDecimal s = uploadBytes.divide(useTime, 2, BigDecimal.ROUND_DOWN);
//		if (s.equals(new BigDecimal(0)))
//			return "0";
//		this.uploadSpeed = s.divide(new BigDecimal(1000), 2,
//				BigDecimal.ROUND_DOWN).toString();
		BigDecimal useTime = new BigDecimal(System.currentTimeMillis() - this.startTime);
		if (useTime.equals(new BigDecimal(0)) || useTime.equals(new BigDecimal(0))) {
			return "0";
		}
		BigDecimal s = useTime.divide(new BigDecimal(1000), 2, BigDecimal.ROUND_DOWN);
		BigDecimal bytes = new BigDecimal(String.valueOf(uploadBytes));
		if (bytes.equals(new BigDecimal(0)) || s.equals(new BigDecimal(0))) {
			return "0";
		}
		BigDecimal kbs = bytes.divide(new BigDecimal(1024), 2, BigDecimal.ROUND_DOWN);
		if (kbs.equals(new BigDecimal(0))){
			return "0";
		}
		BigDecimal speed=kbs.divide(s,2,BigDecimal.ROUND_DOWN);
		BigDecimal mbs=speed.divide(new BigDecimal(1024),2,BigDecimal.ROUND_DOWN);
		if(mbs.compareTo(new BigDecimal(1))==0||mbs.compareTo(new BigDecimal(1))==1){
			this.uploadSpeed=mbs.toString()+"MB/S";
		}else if(mbs.compareTo(new BigDecimal(1))==-1){
			this.uploadSpeed=speed.toString()+"KB/S";
		}
		return this.uploadSpeed;
	}

	public void setUploadSpeed(String uploadSpeed) {
		this.uploadSpeed = uploadSpeed;
	}

	public long getStartTime() {
		return startTime;
	}

	public void setStartTime(long startTime) {
		this.startTime = startTime;
	}

	@Override
	public String toString() {
		JSONObject json = (JSONObject) JSONObject.toJSON(this);
		return json.toJSONString();
	}
	// public static void main(String[] args){
	// Progress p=new Progress();
	// System.out.println(p.getUploadPrecent());
	// }
}
