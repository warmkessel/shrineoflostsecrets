package com.shrineoflostsecrets.entity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
//import java.util.logging.Logger;
import java.util.stream.Collectors;

import com.google.cloud.datastore.Datastore;
import com.google.cloud.datastore.DatastoreOptions;
import com.google.cloud.datastore.Entity;
import com.google.cloud.datastore.Key;
import com.google.cloud.datastore.KeyFactory;
import com.google.cloud.datastore.StringValue;
import com.google.cloud.datastore.Value;
import com.shrineoflostsecrets.constants.BaseEntityConstants;
import com.google.cloud.Timestamp;

public  abstract class BaseEntity implements  Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 7160882192926634429L;
//	private static final Logger log = Logger.getLogger(BaseEntity.class.getName());


	private Key key = null;
//	private boolean deleted = false;
	private List<? extends Value<?>> deleted = null;
	private Timestamp createdDate = Timestamp.now();
	private Timestamp updatedDate = Timestamp.now();

	public BaseEntity() {

	}

	public BaseEntity(Key key, List<? extends Value<?>> deleted, Timestamp createdDate, Timestamp updatedDate) {

		this.key = Objects.requireNonNull(key);
		this.deleted = deleted;
		this.createdDate = Objects.requireNonNull(createdDate);
		this.updatedDate = Objects.requireNonNull(updatedDate);
	}

	@Override
	public int hashCode() {
		int result = 17;
		result = 31 * result + key.hashCode();
		result = 31 * result + deleted.hashCode();
		result = 31 * result + createdDate.hashCode();
		result = 31 * result + updatedDate.hashCode();
		return result;
	}
	public void loadFromEntity(Entity entity) {		  
		if(null != entity) {
			setKey(entity.getKey());
			setDeleted(entity.getList(BaseEntityConstants.DELETED));
			setCreatedDate(entity.getTimestamp(BaseEntityConstants.CREATEDDATE));
			setUpdatedDate(entity.getTimestamp(BaseEntityConstants.UPDATEDDATE));
		}	
	}
	public abstract String getEventKind();
	
	public Key getKey() {
		 if(null == key) {
			 KeyFactory keyFactory = getDatastore().newKeyFactory().setKind(getEventKind());  
			 key = getDatastore().allocateId(keyFactory.newKey());
		 }
		return key;
	}
	public Long getKeyLong() {
		//log.info("getKey " + ((getKey() == null) ? "null" : "not Null"));
		return getKey().getId();
	}
	public String getKeyString() {
		return Long.toString(getKeyLong());
	}

	public void setKey(Key key) {
		this.key = key;
	}

	public String getDeletedString() {
		if(null == deleted || deleted.size() == 0) {
			return "";
		}
		else {
			List<String> deletedStrings = getDeleted().stream().map(Value::get).map(Object::toString).collect(Collectors.toList());
			return String.join(" ", deletedStrings);
		}
	}
	public boolean isDeleted(DungonMaster dm) {
		return isDeleted(dm.getKeyLong());
	}
	private boolean isDeleted(Long userId) {
		return isDeleted(userId.toString());
	}
	private boolean isDeleted(String userId) {
		return (null != getDeleted() && (getDeleted().contains(StringValue.of(userId))));
	}

	public List<? extends Value<?>> getDeleted() {
		if(null == deleted) {
			deleted =  new ArrayList<>();
		}
		return deleted;
	}
	public void setUnDeleted(DungonMaster dm) {     
		setUnDeleted(dm.getKeyLong());	
	}	
	public void setUnDeleted(Long userId) {     
		setUnDeleted(userId.toString());	
	}	
	
	public void setUnDeleted(String userId) {     
		setUnDeleted(StringValue.newBuilder(userId).build());	
	}	
	public void setUnDeleted(Value<?> userId) {     
	    List<Value<?>> updatedDeletedList = new ArrayList<>(getDeleted());
	    updatedDeletedList.remove(userId);
	    setDeleted(updatedDeletedList);
	}
	
	public void setDeleted(DungonMaster dm) {
		setDeleted(dm.getKeyLong());
	}
	
	public void setDeleted(Long userId) {     
		setDeleted(userId.toString());
	}
	
	
	private void setDeleted(String userId) {     
		setDeleted(StringValue.newBuilder(userId).build());	
	}	
	public void setDeleted(Value<?> userId) {     
	    List<Value<?>> updatedDeletedList = new ArrayList<>(getDeleted());
	    updatedDeletedList.add(userId);
	    setDeleted(updatedDeletedList);
	}
	
	public void setDeleted(List<? extends Value<?>> deleted) {
		this.deleted = deleted;
	}

	public Timestamp getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Timestamp createdDate) {
		this.createdDate = createdDate;
	}

	public Timestamp getUpdatedDate() {
		return updatedDate;
	}
	public void setUpdatedDate() {
		setUpdatedDate(Timestamp.now());
	}
	
	public void setUpdatedDate(Timestamp updatedDate) {
		this.updatedDate = updatedDate;
	}

	protected Datastore getDatastore() {
		return DatastoreOptions.getDefaultInstance().getService();

	}
}
