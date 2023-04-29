package com.shrineoflostsecrets.entity;

import java.util.List;
import com.shrineoflostsecrets.constants.*;
import com.google.cloud.Timestamp;
import com.google.cloud.datastore.Entity;
import com.google.cloud.datastore.Key;
import com.google.cloud.datastore.Value;

public class DungonMaster extends BaseEntity {

	/**
	 * 
	 */
	public DungonMaster() {
		
	}
	public DungonMaster(Entity entity) {
		this(entity.getString(DungonMasterConstants.EMAIL));
	}
	public DungonMaster(String email) {
		super();
		this.email = email;
	}
	public DungonMaster(Key key, List<? extends Value<?>> deleted, Timestamp createdDate, Timestamp updatedDate, String email) {
		super(key, deleted, createdDate, updatedDate);
		this.email = email;
	}
	public void loadFromEntity(Entity entity) {
		super.loadFromEntity(entity);
		if (null != entity) {
			setEmail(entity.getString(DungonMasterConstants.EMAIL));
		}
	}
	
	
	private static final long serialVersionUID = 2070834976678167423L;
	private String email = "";

	

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}


	public void save() {
		Entity.Builder entity = Entity.newBuilder(getKey());
		entity.set(EventConstants.DELETED, getDeleted()).set(EventConstants.CREATEDDATE, getCreatedDate())
				.set(EventConstants.UPDATEDDATE, getUpdatedDate()).set(DungonMasterConstants.EMAIL, getEmail()).build();
		getDatastore().put(entity.build());
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null || getClass() != obj.getClass()) {
			return false;
		}
		DungonMaster other = (DungonMaster) obj;
		return this.getKey().equals(other.getKey());
	}

	@Override
	public int hashCode() {
		int result = super.hashCode();
		result = 31 * result + getEmail().hashCode();
		return result;
	}

	public String getEventKind() {
		return DungonMasterConstants.DUNGONMASTER;
	}

}


