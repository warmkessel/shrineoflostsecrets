package com.shrineoflostsecrets.datastore;

import java.util.Iterator;
import java.util.List;
//import java.util.logging.Logger;
import java.util.Set;

import com.google.cloud.datastore.*;
import com.google.cloud.datastore.StructuredQuery.CompositeFilter;
import com.google.cloud.datastore.StructuredQuery.OrderBy;
import com.google.cloud.datastore.StructuredQuery.PropertyFilter;
import com.google.common.collect.Lists;
import com.shrineoflostsecrets.constants.Constants;
import com.shrineoflostsecrets.constants.EventConstants;
import com.shrineoflostsecrets.entity.DungonMaster;
import com.shrineoflostsecrets.util.SOLSCalendar;

public class EventsList {
	
	public static List<Entity> listEvents(SOLSCalendar startCal, SOLSCalendar endCal, String world, String relm, DungonMaster theMaster, Set<String> tag) {
		return listEvents(startCal.getTime(), endCal.getTime(), world, relm, theMaster.getKeyLong(), tag);
	}
	private static List<Entity> listEvents(long startTime, long endTime, String world, String relm, long userId,
			Set<String> tag) {
		Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
		Query<Entity> query = null;

		if (null != tag && tag.size() > 0) {
			query = buildquery(startTime, endTime, world, relm, userId, tag);
		} else {
			query = buildquery(startTime, endTime, world, relm, userId);

		}
		// Run the query and retrieve a list of matching entities
		QueryResults<Entity> results = datastore.run(query);
		List<Entity> entities = Lists.newArrayList(results);

		Iterator<Entity> it = entities.iterator();
		
		StringValue du0 = StringValue.of(String.valueOf(Constants.UNIVERSALUSER));
		StringValue du1 = StringValue.of(String.valueOf(userId));

		while (it.hasNext()) {
			Entity ent = (Entity) it.next();
			long eventUserID = ent.getLong(EventConstants.USERID);
			if(Constants.UNIVERSALUSER != eventUserID && userId != eventUserID){
				 it.remove(); 
			}
			else {
				List<? extends Value<?>> list = ent.getList(EventConstants.DELETED);
				if (list.size() > 0 && (list.contains(du0) || list.contains(du1))) {
					 it.remove(); 
				}
			}
		}
		return entities;
	}

	private static Query<Entity> buildquery(long startTime, long endTime, String world, String relm, long userId) {
		// Define a query to retrieve all entities of kind "Event" with specified
		// filters and ordering
		Query<Entity> query = Query.newEntityQueryBuilder().setKind(EventConstants.EVENT)
				.setFilter(CompositeFilter.and(PropertyFilter.ge(EventConstants.EVENTDATE, startTime),
						PropertyFilter.le(EventConstants.EVENTDATE, endTime),
						PropertyFilter.eq(EventConstants.WORLD, world),
						PropertyFilter.eq(EventConstants.RELM, relm)))
				.setOrderBy(OrderBy.asc(EventConstants.EVENTDATE)).build();
		return query;

	}

	private static Query<Entity> buildquery(long startTime, long endTime, String world, String relm, long userId,
			Set<String> tag) {
		String[] tagArray = tag.toArray(new String[tag.size()]);

		ListValue.Builder listBuilder1 = ListValue.newBuilder().addValue(StringValue.newBuilder(tagArray[0]).build());

		ListValue.Builder listBuilder2 = ListValue.newBuilder();
		if (tagArray.length >= 2) {
			listBuilder2.addValue(StringValue.newBuilder(tagArray[1]).build());
		} else {
			listBuilder2.addValue(StringValue.newBuilder(tagArray[0]).build());
		}
		ListValue.Builder listBuilder3 = ListValue.newBuilder();
		if (tagArray.length >= 3) {
			listBuilder3.addValue(StringValue.newBuilder(tagArray[2]).build());
		} else {
			listBuilder3.addValue(StringValue.newBuilder(tagArray[0]).build());
		}
		ListValue.Builder listBuilder4 = ListValue.newBuilder();
		if (tagArray.length >= 4) {
			listBuilder4.addValue(StringValue.newBuilder(tagArray[3]).build());
		} else {
			listBuilder4.addValue(StringValue.newBuilder(tagArray[0]).build());
		}
		ListValue.Builder listBuilder5 = ListValue.newBuilder();
		if (tagArray.length >= 5) {
			listBuilder5.addValue(StringValue.newBuilder(tagArray[4]).build());
		} else {
			listBuilder5.addValue(StringValue.newBuilder(tagArray[0]).build());
		}

		// Define a query to retrieve all entities of kind "Event" with specified
		// filters and ordering
		Query<Entity> query = Query.newEntityQueryBuilder().setKind(EventConstants.EVENT)
				.setFilter(CompositeFilter.and(
						PropertyFilter.ge(EventConstants.EVENTDATE, startTime),
						PropertyFilter.le(EventConstants.EVENTDATE, endTime),
						PropertyFilter.eq(EventConstants.WORLD, world),
						PropertyFilter.eq(EventConstants.RELM, relm),
						PropertyFilter.in(EventConstants.TAGS, listBuilder1.build()),
						PropertyFilter.in(EventConstants.TAGS, listBuilder2.build()),
						PropertyFilter.in(EventConstants.TAGS, listBuilder3.build()),
						PropertyFilter.in(EventConstants.TAGS, listBuilder4.build()),
						PropertyFilter.in(EventConstants.TAGS, listBuilder5.build())
						))
				.setOrderBy(OrderBy.asc(EventConstants.EVENTDATE)).build();
		return query;
	}

}