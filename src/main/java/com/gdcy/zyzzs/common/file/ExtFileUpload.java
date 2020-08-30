package com.gdcy.zyzzs.common.file;

import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * 
 * @author 黄枝良
 *
 */
public class ExtFileUpload extends ServletFileUpload{

	public ExtFileUpload() {
		super();
	}

	public ExtFileUpload(FileItemFactory fileItemFactory) {
		super(fileItemFactory);
	}
	
	public void notify(int uploadBytes){
		notifyListener(uploadBytes);
	}
	
	private void notifyListener(int uploadBytes){
		FileUploadProgressListener listener=(FileUploadProgressListener) super.getProgressListener();
		if(listener!=null){
			long bytes=listener.getProgress().getUploadBytes();
			bytes+=uploadBytes;
			listener.update(bytes, listener.getProgress().getLength(), listener.getProgress().getUploadItems());
		}
	}
}
