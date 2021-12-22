package app.screeb.plugin_screeb_example

import android.app.Application
import android.content.Context
import androidx.multidex.MultiDex
import java.util.*

class ExampleApplication: Application() {
    override fun onCreate() {
        super.onCreate()
    }

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}