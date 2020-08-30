package com.gdcy.zyzzs.common.file;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

/**
 * 重写CommonsMultipartResolver，加入上传进度监听器
 * 
 * @author 黄枝良
 * 
 */
public class FileResolver extends CommonsMultipartResolver {

	private HttpServletRequest request;

	@Override
	protected FileUpload newFileUpload(FileItemFactory fileItemFactory) {
		ExtFileUpload upload = new ExtFileUpload(fileItemFactory);
		upload.setSizeMax(-1);
		if (request != null) {
			FileUploadProgressListener uploadProgressListener = new FileUploadProgressListener(
					request.getSession());
			upload.setProgressListener(uploadProgressListener);
		}
		return upload;
	}

	@Override
	public MultipartParsingResult parseRequest(HttpServletRequest request)
			throws MultipartException {
		HttpSession session = request.getSession();
		String encoding = determineEncoding(request);
		FileUpload fileUpload = prepareFileUpload(encoding);
		FileUploadProgressListener progressListener = new FileUploadProgressListener(
				session);
		fileUpload.setProgressListener(progressListener);
		try {
			List<FileItem> fileItems = ((ServletFileUpload) fileUpload)
					.parseRequest(request);
			return parseFileItems(fileItems, encoding);
		} catch (FileUploadBase.SizeLimitExceededException ex) {
			throw new MaxUploadSizeExceededException(fileUpload.getSizeMax(),
					ex);
		} catch (FileUploadException ex) {
			throw new MultipartException(
					"Could not parse multipart servlet request", ex);
		}
	}

	public MultipartHttpServletRequest resolveMultipart(
			HttpServletRequest request) throws MultipartException {
		this.request = request;
		return super.resolveMultipart(request);
	}
	
	@Override
    public boolean isMultipart(HttpServletRequest request) {
        String dir = request.getParameter("dir");
        // kindeditor 上传图片的时候 不进行request 的转换
        if(dir!=null){  
            return false;
        }
        return super.isMultipart(request);
    }
}
