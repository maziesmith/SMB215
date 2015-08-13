package com.example.scanqr;

import java.io.IOException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.example.scanqr.MyNotificationService.LongRunningGetIO;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class Stock_Alert extends Activity {
	HttpClient client;
	final static String URL = "http://192.168.10.110:8080/STK_PRD_WS/webresources/entities.stkprd/notifications/";
	
	JSONArray json;
	SharedPreferences getPrefs ;
	String site;
	TextView info;
	TextView qty;
	TextView qtynot;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_stock_alert);
		info = (TextView) findViewById(R.id.tvbarcode);
		qty = (TextView) findViewById(R.id.tvqty);
		qtynot = (TextView) findViewById(R.id.tvqtynot);
		getPrefs = PreferenceManager.getDefaultSharedPreferences(getBaseContext());
		site = getPrefs.getString("Siteid", "09");
		client = new DefaultHttpClient();
		new LongRunningGetIO().execute();
		
	}
	
	
	
public JSONArray lastNotifications() throws ClientProtocolException,IOException,JSONException{
		
		StringBuilder url = new StringBuilder(URL+site);
		
		
		HttpGet get = new HttpGet(url.toString());
		HttpResponse r = client.execute(get);
		int status = r.getStatusLine().getStatusCode();
		if (status == 200) {
			HttpEntity entity = r.getEntity();
			String data = EntityUtils.toString(entity);
			JSONArray timeline = new JSONArray(data); // return all the result into a JSON Array
			//JSONObject last = timeline.getJSONObject(0); // return the first record of the JSON Array 
			return timeline;
		}
		Toast.makeText(Stock_Alert.this, "error", Toast.LENGTH_SHORT).show();
		return null;
	}
	
	
	class LongRunningGetIO extends  AsyncTask <Void, Void, String>{

		

		@Override
		protected void onPostExecute(String result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			for (int i = 0 ;i<json.length();i++){
				try {
					JSONObject current = json.getJSONObject(i);
					JSONObject jsonPr = new JSONObject();
					
					jsonPr = current.getJSONObject("product");
					
					info.setText(info.getText()+jsonPr.get("description").toString()+"\n");
					qty.setText(qty.getText()+current.get("qty").toString()+"\n");
					qtynot.setText(qtynot.getText()+current.get("qtyNotification").toString()+"\n");
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}

			
		}

		@Override
		protected String doInBackground(Void... params) {
			// TODO Auto-generated method stub
			
			try {
				
				json = lastNotifications();
			} catch (ClientProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return null;
		}
		
		
		
		

	}
		
		
	
	
	
}
