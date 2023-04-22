package com.shrineoflostsecrets.util;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
//import java.util.logging.Logger;

import org.json.JSONArray;
import org.json.JSONObject;

import com.google.cloud.datastore.Value;

public class TagRepo {
//	 private static final Logger log = Logger.getLogger(TagRepo.class.getName());

    public enum FontSize {
        SMALL(10),
        MEDIUM(15),
        LARGE(20);

        private int size;

        private FontSize(int size) {
            this.size = size;
        }

        public int getSize() {
            return size;
        }

        public static FontSize isValidSize(String inputSize) {
            for (FontSize fontSize : FontSize.values()) {
                if (fontSize.name().equalsIgnoreCase(inputSize)) {
                    return fontSize;
                }
            }
            return SMALL;
        }
    }

    private TreeMap<String, Integer> repo = new TreeMap<String, Integer>();
    private FontSize size = FontSize.SMALL;

    public static final int MaxSize = 75;
    public TagRepo() {
        this(0);
    }

    public TagRepo(int theSize) {
//    	log.info("theSize " + theSize);

    	if(theSize < 25) {
        	size = FontSize.LARGE;
        }
        else if (25 <= theSize && theSize < 50){
        	size = FontSize.MEDIUM;
        }
        else if (theSize < 50){
        	size = FontSize.SMALL;
        }
    	
    }
    private int getStartingSize() {
    	int theReturn = 10;
    	if (FontSize.LARGE.equals(size)){
    		theReturn = 24;
    	}
    	else if (FontSize.MEDIUM.equals(size)){
    		theReturn = 15;

    	}
    	return theReturn;
    }
    private int getIncrementSize() {
    	int theReturn = 3;
    	if (FontSize.LARGE.equals(size)){
    		theReturn = 6;
    	}
    	else if (FontSize.MEDIUM.equals(size)){
    		theReturn = 5;

    	}
    	return theReturn;
    }

    public TreeMap<String, Integer> getRepo() {
        return repo;
    }

    public List<Map.Entry<String, Integer>> exportRepo() {
        List<Map.Entry<String, Integer>> entryList = new ArrayList<>(getRepo().entrySet());
        entryList.sort(Map.Entry.comparingByValue(Comparator.reverseOrder()));
        return entryList;
    }

    public void addTag(String tag) {
        if (getRepo().containsKey(tag)) {
            int count = getRepo().get(tag);

            if (count < MaxSize) {
                getRepo().put(tag, count + getIncrementSize());
            } else {
                getRepo().put(tag, MaxSize);
            }
        } else {
            getRepo().put(tag, getStartingSize());
        }
    }

    public void addTags(List<? extends Value<?>> tags) {
        for (Value<?> tag : tags) {
            addTag((String) tag.get());
        }
    }

    @Override
    public String toString() {
        StringBuilder theReturn = new StringBuilder();
        for (Map.Entry<String, Integer> entry : exportRepo()) {
            theReturn.append(entry.getKey()).append(":").append(entry.getValue()).append(" ");
        }
        return theReturn.toString();
    }

    public JSONArray toJSON() {
//    	log.info("FontSize " + size.toString());
        JSONArray jsonArray = new JSONArray();
        int x = 0;
        for (Map.Entry<String, Integer> entry : exportRepo()) {
            if (x >= 65) {
                break;
            }
            x++;
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("word", CaseControl.capFirstLetter(entry.getKey()));
            jsonObject.put("frequency", entry.getValue());
            jsonArray.put(jsonObject);
        }
        return jsonArray;
    }
}