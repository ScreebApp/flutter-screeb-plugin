package com.example.example

import android.os.Bundle
import android.content.Intent
import app.screeb.sdk.Screeb
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		Screeb.handleDeepLink(intent)
	}

	override fun onNewIntent(intent: Intent) {
		super.onNewIntent(intent)
		Screeb.handleDeepLink(intent)
	}
}
