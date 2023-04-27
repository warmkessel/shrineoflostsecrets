package com.shrineoflostsecrets.ai;

import java.util.logging.Logger;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.appengine.api.urlfetch.HTTPHeader;
import com.google.appengine.api.urlfetch.HTTPMethod;
import com.google.appengine.api.urlfetch.HTTPRequest;
import com.google.appengine.api.urlfetch.HTTPResponse;
import com.google.appengine.api.urlfetch.URLFetchService;
import com.google.appengine.api.urlfetch.URLFetchServiceFactory;
import com.shrineoflostsecrets.constants.*;

public class  AIImageManager{

	private static final Logger log = Logger.getLogger(AIImageManager.class.getName());


	public static String buildImage(String size,String input) {
		return extactText(fetchImage(size, input));
	}
	public static String fetchImage(String size,String input ) {
		String theReturn = "";
		input = AIManager.removeUnusal(input);
		try {

			// Encode the API key in Base64 format and set it as Authorization header
			String apiKey = AIKey.API_KEY;
			String auth = "Bearer " + apiKey;


//			curl https://api.openai.com/v1/images/generations \
//				  -H "Content-Type: application/json" \
//				  -H "Authorization: Bearer $OPENAI_API_KEY" \
//				  -d '{
//				    "prompt": "A cute baby sea otter",
//				    "n": 2,
//				    "size": "1024x1024"
//				  }'
		
			String endpoint = "https://api.openai.com/v1/images/generations";
			String requestBody = "{\"prompt\": \"" + input + "\",\"n\": 2,\n\"size\": \"" + size + "\"}";
			URLFetchService urlFetchService = URLFetchServiceFactory.getURLFetchService();
			HTTPRequest httpRequest = new HTTPRequest(new java.net.URL(endpoint), HTTPMethod.POST);
			httpRequest.getFetchOptions().setDeadline(60000d);
			httpRequest.addHeader(new HTTPHeader("Content-Type", "application/json"));
			httpRequest.addHeader(new HTTPHeader("Authorization", auth));
			httpRequest.setPayload(requestBody.getBytes());
			log.info("requestBody:" + requestBody);

			// Get the response
			HTTPResponse httpResponse = urlFetchService.fetch(httpRequest);
			theReturn = new String(httpResponse.getContent()).trim();
		} catch (Exception e) {
			log.warning("Failed to execute OpenAI API request: " + e.getMessage());
		}
		return theReturn;
	}

	public static String extactText(String jsonStr) {
		String theReturn = "";
		try {
			if (jsonStr.startsWith("{")) {
				JSONObject json = new JSONObject(jsonStr);
//				JSONObject messages = json.getJSONObject("messages");
				JSONArray data = json.getJSONArray("data");
				JSONObject model = data.getJSONObject(0);
				return  model.getString("url");
				}
		} catch (JSONException e) {
			log.info("jsonStr" + jsonStr);
			e.printStackTrace();
		}
		return theReturn;
	}
	
}