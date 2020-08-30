package com.gdcy.zyzzs.common.file;

import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.ProgressListener;

/**
 * 文件上传进度监听器
 * @author 黄枝良
 *
 */
public class FileUploadProgressListener implements ProgressListener {
	
	private HttpSession session;
	private Progress progress;

	public FileUploadProgressListener() {
	}

	public FileUploadProgressListener(HttpSession session) {
		this.session = session;
		progress=new Progress();
		session.setAttribute("progress", progress);
	}

	public void update(long uploadBytes, long length, int uploadItems) {
		Progress progress = (Progress) session.getAttribute("progress");
		progress.setUploadBytes(uploadBytes);
		progress.setLength(length);
		progress.setUploadItems(uploadItems);
		session.setAttribute("progress", progress);
		this.progress=progress;
	}

	public Progress getProgress() {
		return progress;
	}

	public void setProgress(Progress progress) {
		this.progress = progress;
	}
	
}
