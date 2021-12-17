package app.screeb.plugin_screeb_example

import android.app.Application
import android.content.Context
import androidx.multidex.MultiDex
import app.screeb.plugin_screeb.PluginScreebPlugin.Companion.screeb
import app.screeb.sdk.Screeb
import app.screeb.sdk.init.model.VisitorProperties
import java.util.*

class ExampleApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        screeb = Screeb.Builder()
            .withContext(this)
            .withChannelId("082b7590-1621-4f72-8030-731a98cd1448") // Preview survey
            .withVisitorId("clement2@screeb.app")
            .withVisitorProperties(VisitorProperties().apply {
                this["email"] = "flutter_plugin@screeb.app"
                this["age"] = 32
                this["company"] = "Flutter"
                this["logged_at"] = Date()
            })
            .build()
    }

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}