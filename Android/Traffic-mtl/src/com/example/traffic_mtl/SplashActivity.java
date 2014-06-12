package com.example.traffic_mtl;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;

public class SplashActivity extends Activity {
	
	private static final ScheduledExecutorService worker = Executors.newSingleThreadScheduledExecutor();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_splash);
		
		Runnable task = new Runnable() {
		    public void run() {
		    	Intent i = new Intent(getApplicationContext(), MainActivity.class);
				startActivity(i);
		    }
		  };
		  worker.schedule(task, 3, TimeUnit.SECONDS);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.splash, menu);
		return true;
	}

}
