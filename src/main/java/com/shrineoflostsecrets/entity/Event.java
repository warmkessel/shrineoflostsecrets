package com.shrineoflostsecrets.entity;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.Set;
//import java.util.logging.Logger;
import java.util.stream.Collectors;

import com.shrineoflostsecrets.constants.Constants;
import com.shrineoflostsecrets.constants.EventConstants;
import com.shrineoflostsecrets.util.SOLSCalendar;
import com.google.cloud.Timestamp;
import com.google.cloud.datastore.Entity;
import com.google.cloud.datastore.Key;
import com.google.cloud.datastore.ListValue;
import com.google.cloud.datastore.StringValue;
import com.google.cloud.datastore.Value;
public class Event extends BaseEntity implements Comparable<Event> {

	

	/**
	 * 
	 */
	private static final long serialVersionUID = -361472214131790072L;
	 //private static final Logger log = Logger.getLogger(Event.class.getName());

	private boolean bookmarked = false;

	private long userId = 0;
	private int revision = 0;
	private String world = "";
	private String relm = "";
//	private String kingdom = "";
	private List<? extends Value<?>> tags = null;
	private long eventDate = 0;
	private String title = "";
	private String compactDesc = "";
	private String shortDesc = "";
	private String longDesc = new String("");
	private String media = "";

	public Event() {
	}
	public Event(Key key, List<? extends Value<?>> deleted, boolean bookmarked, Timestamp createdDate, Timestamp updatedDate, int userId, String world, String relm, String kingdom, List<? extends Value<?>> tags, long eventDate, String title, String compactDesc,
			String shortDesc, String longDesc, String media) {
		super(key, deleted, createdDate, updatedDate);
		this.bookmarked = bookmarked;
		this.userId = userId;
		this.world = Objects.requireNonNull(world);
		this.relm = Objects.requireNonNull(relm);
//		this.kingdom = Objects.requireNonNull(kingdom);
		this.tags = Objects.requireNonNull(tags);
		this.eventDate = Objects.requireNonNull(eventDate);
		this.title = Objects.requireNonNull(title);
		this.compactDesc = Objects.requireNonNull(compactDesc);
		this.shortDesc = Objects.requireNonNull(shortDesc);
		this.longDesc = Objects.requireNonNull(longDesc);
		this.media = Objects.requireNonNull(media);
	}

	public boolean isBookmarked() {
		return bookmarked;
	}

	public void setBookmarked(String bookmarked) {
		setBookmarked(new Boolean(bookmarked).booleanValue());
	}

	public void setBookmarked(boolean bookmarked) {
		this.bookmarked = bookmarked;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public int getRevision() {
		return revision;
	}

	public void incRevision() {
		setUpdatedDate();
		setRevision(getRevision() + 1);
	}
	
	public void setRevision(int revision) {
		this.revision = revision;
	}

	public String getWorld() {
		return world;
	}

	public void setWorld(String world) {
		this.world = world;
	}

	public String getRelm() {
		return relm;
	}

	public void setRelm(String relm) {
		this.relm = relm;
	}
//	public String getKingdom() {
//		return kingdom;
//	}
//
//	public void setKingdom(String kingdom) {
//		this.kingdom = kingdom;
//	}
	public String getTagsEncodedString() {
		if(getTags().size() == 0) {
			return "";
		}
		else {
			List<String> tagStrings = getTags().stream().map(Value::get).map(Object::toString).collect(Collectors.toList());
			return String.join("&tags=", tagStrings);
		}
	}
	

	public String getTagsString() {
		if(getTags().size() == 0) {
			return "";
		}
		else {
			List<String> tagStrings = getTags().stream().map(Value::get).map(Object::toString).collect(Collectors.toList());
			return String.join(" ", tagStrings);
		}
	}

	public List<? extends Value<?>> getTags() {

		if(null == tags) {
			tags =  new ArrayList<>();
		}
		return tags;
	}

	public void setTags(String tags) {
		String[] tagsArray = tags.toLowerCase().split(" ");
		setTags(Arrays.stream(tagsArray).map(StringValue::of).collect(Collectors.toList()));
	}

	public void setTags(Set<String> tags) {
	    String[] tagsArray = tags.toArray(new String[tags.size()]);
		setTags(Arrays.stream(tagsArray).map(StringValue::of).collect(Collectors.toList()));
	}
	
	public void setTags(List<? extends Value<?>> tags) {
		this.tags = tags;
	}

	public long getEventDate() {
		return eventDate;
	}
	public SOLSCalendar getEventCalendar() {
		return new SOLSCalendar(getEventDate());
	}

	public void setEventDate(long eventDate) {
		this.eventDate = eventDate;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getCompactDesc() {
		return compactDesc;
	}

	public void setCompactDesc(String compactDesc) {
		this.compactDesc = compactDesc;
	}

	public String getShortDesc() {
		return shortDesc;
	}

	public void setShortDesc(String shortDesc) {
		this.shortDesc = shortDesc;
	}

	public String getLongDesc() {
		return longDesc;
	}


	public void setLongDesc(String longDesc) {
		this.longDesc = longDesc;
	}
	public boolean hasMedia() {
		return (0 != getMedia().length());
	}
	public String getMedia() {
		return media;
	}

	public void setMedia(String media) {
		this.media = media;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null || getClass() != obj.getClass()) {
			return false;
		}
		Event other = (Event) obj;
		return this.getKey().equals(other.getKey());
	}

	@Override
	public int hashCode() {
		int result = super.hashCode();
		result = 31 * result + (bookmarked ? 1 : 0);
		result = 31 * result + new Long(userId).intValue();
		result = 31 * result + revision;
		result = 31 * result + world.hashCode();
		//result = 31 * result + kingdom.hashCode();
		result = 31 * result + getTags().hashCode();
		result = 31 * result + new Long(eventDate).hashCode();
		result = 31 * result + title.hashCode();
		result = 31 * result + compactDesc.hashCode();
		result = 31 * result + shortDesc.hashCode();
		result = 31 * result + longDesc.hashCode();
		result = 31 * result + media.hashCode();
		return result;
	}

	public void save() {
		incRevision();
		Entity.Builder entity = Entity.newBuilder(getKey());
		entity.set(EventConstants.DELETED, getDeleted()).set(EventConstants.BOOKMARKED, isBookmarked()).set(EventConstants.CREATEDDATE, getCreatedDate())
				.set(EventConstants.UPDATEDDATE, getUpdatedDate()).set(EventConstants.USERID, getUserId()).set(EventConstants.REVISION, getRevision())
				.set(EventConstants.WORLD, getWorld()).set(EventConstants.RELM, getRelm()).set(EventConstants.TAGS, getTags()).set(EventConstants.EVENTDATE, getEventDate())
				.set(EventConstants.TITLE, getTitle()).set(EventConstants.COMPACTDESC, getCompactDesc()).set(EventConstants.SHORTDESC, getShortDesc())
				.set(EventConstants.LONGDESC, StringValue.newBuilder(getLongDesc()).setExcludeFromIndexes(true).build()).set(EventConstants.MEDIA, getMedia()).build();
		getDatastore().put(entity.build());
	}

	public static List<? extends Value<?>> convertTags(String[] tags) {
		List<StringValue> stringValues = Arrays.stream(tags).map(StringValue::of).collect(Collectors.toList());
		return Arrays.asList(ListValue.of(stringValues));
	}

	public void loadEvent(String key) {
		loadEvent(new Long(key).longValue());
	}

	public void loadEvent(long key) {
		loadEvent(Key.newBuilder(Constants.SHRINEOFLOSTSECRETS, EventConstants.EVENT, key).build());
	}

	public void loadEvent(Key key) {
		// log.info("key " + key.toString());
		Entity event = getDatastore().get(key);
		loadFromEntity(event);

	}

	public void loadFromEntity(Entity entity) {
		super.loadFromEntity(entity);
		if (null != entity) {
			setBookmarked(entity.getBoolean(EventConstants.BOOKMARKED));
			setUserId(entity.getLong(EventConstants.USERID));
			setRevision(new Long(entity.getLong(EventConstants.REVISION)).intValue());
			setWorld(entity.getString(EventConstants.WORLD));
			setRelm(entity.getString(EventConstants.RELM));
//			setKingdom(entity.getString(EventConstants.KINGDOM));
			setTags(entity.getList(EventConstants.TAGS));
			setEventDate(entity.getLong(EventConstants.EVENTDATE));
			setTitle(entity.getString(EventConstants.TITLE));
			setCompactDesc(entity.getString(EventConstants.COMPACTDESC));
			setShortDesc(entity.getString(EventConstants.SHORTDESC));
			setLongDesc(entity.getString(EventConstants.LONGDESC));
			if (entity.contains(EventConstants.MEDIA)) {
				setMedia(entity.getString(EventConstants.MEDIA));
			}
		}
	}

	public String toString() {
		return "Event{" + "" + Constants.KEY + "='" + getKeyString() + '\'' + ", " + EventConstants.DELETED + "=" + getDeletedString()
				+ ", \" + BOOKMARKED + \"=" + bookmarked + ", \" + CREATEDDATE + \"=" + getCreatedDate()
				+ ", \" + UPDATEDDATE + \"=" + getUpdatedDate() + ", "+ EventConstants.USERID +"=" + userId + ", "+ EventConstants.REVISION +"=" + revision
				+ ", " + EventConstants.WORLD + "='" + world + '\'' +  ", " + EventConstants.RELM + "='" + relm + '\'' + '\'' + ", \" + TAGS + \"='" + getTags()
				+ '\'' + ", \" + EVENTDATE + \"='" + eventDate + '\'' + ", \" + TITLE + \"='" + title + '\''
				+ ", \" + KINGDOM + \"='" + EventConstants.COMPACTDESC + '\'' + ", \" + SHORTDESC + \"='" + shortDesc + '\''
				+ ", \" + LONGDESC + \"='" + longDesc + '\'' + ", \" + MEDIA + \"'" + media + '\'' + '}';
	}

	public int compareTo(Event other) {
		if (this.title == null && other.title == null) {
			return 0;
		} else if (this.title == null) {
			return -1;
		} else if (other.title == null) {
			return 1;
		} else {
			return this.title.compareTo(other.title);
		}
	}
	public String getEventKind() {
		return EventConstants.EVENT;
	}
}
