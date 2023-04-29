package com.shrineoflostsecrets.datastore;

import java.util.List;
import com.google.appengine.api.users.*;
//import java.util.logging.Logger;

import com.google.cloud.datastore.*;
import com.google.cloud.datastore.StructuredQuery.*;
import com.google.common.collect.Lists;
import com.shrineoflostsecrets.constants.*;
import com.shrineoflostsecrets.entity.DungonMaster;
public class DungonMasterList {
	

	
	public static DungonMaster getDungonMaster(User theUser) {
		if(null == theUser || null == theUser.getEmail()) {
			return  new DungonMaster();
		}
		else {
			return getDungonMaster(theUser.getEmail());
		}
	}
	private static DungonMaster getDungonMaster(String email) {
		Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
		Query<Entity> query = Query.newEntityQueryBuilder().setKind(DungonMasterConstants.DUNGONMASTER)
				.setFilter( PropertyFilter.eq(DungonMasterConstants.EMAIL, email)).build();
		// Run the query and retrieve a list of matching entities
		QueryResults<Entity> results = datastore.run(query);
		List<Entity> entities = Lists.newArrayList(results);
		if(entities.size() == 0) {
			DungonMaster theReturn = new DungonMaster(email);
			theReturn.save();
			return getDungonMaster(email);
		}
		else{
			DungonMaster theReturn = new DungonMaster();
			theReturn.loadFromEntity(entities.get(0));
			return theReturn;
		}
		
	}

}