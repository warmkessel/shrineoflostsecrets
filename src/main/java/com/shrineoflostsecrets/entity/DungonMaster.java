package com.shrineoflostsecrets.entity;

import com.shrineoflostsecrets.constants.*;
import com.google.cloud.datastore.Entity;

public class DungonMaster extends BaseEntity {

	/**
	 * 
	 */
	public DungonMaster() {
		super();
	}
	public DungonMaster(String email) {
		super();
		setEmail(email);
		setUsername(email.substring(0, email.indexOf("@")).toString());
	}
	public void loadFromEntity(Entity entity) {
		super.loadFromEntity(entity);
		if (null != entity) {
			setEmail(entity.getString(DungonMasterConstants.EMAIL));
			if (entity.contains(DungonMasterConstants.USERNAME)) {
	            setUsername(entity.getString(DungonMasterConstants.USERNAME));
	        } else {
	    		setUsername(email.substring(0, email.indexOf("@")).toString());
	  		}
		}
	}

	private static final long serialVersionUID = 2070834976678167423L;
	private String email = "";
	private String username = "";

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void save() {
		Entity.Builder entity = Entity.newBuilder(getKey());
		entity.set(EventConstants.DELETED, getDeleted()).set(EventConstants.CREATEDDATE, getCreatedDate())
				.set(EventConstants.UPDATEDDATE, getUpdatedDate()).set(DungonMasterConstants.EMAIL, getEmail()).set(DungonMasterConstants.USERNAME, getUsername()).build();
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

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

}
