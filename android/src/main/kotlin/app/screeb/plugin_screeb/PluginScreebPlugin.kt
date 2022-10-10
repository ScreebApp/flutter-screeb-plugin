package app.screeb.plugin_screeb

import android.content.Context
import androidx.annotation.NonNull
import app.screeb.sdk.Screeb

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.HashMap

/** PluginScreebPlugin */
class PluginScreebPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: android.content.Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugin_screeb")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val arguments = call.arguments as ArrayList<*>

        if (call.method == CALL_INIT_SDK) {
            val channelId = arguments[0] as String
            val userId: String? = arguments[1] as? String
            val properties = (arguments[2] as? Map<*, *>)?.toVisitorProperty()

            if (screeb == null) {
                result.success(false)
                return
            }
            screeb?.pluginInit(channelId, userId, properties)
            result.success(true)
            return
        }

        if (screeb == null) {
            result.error(ERROR_SCREEB_NOT_INIT, null, null)
            return
        }

        when (call.method) {
            CALL_SET_IDENTITY -> {
                val userId = arguments[0] as String
                val properties = (arguments[1] as? Map<*, *>)?.toVisitorProperty()
                screeb?.setIdentity(userId, properties)
                result.success(true)
            }
            CALL_SEND_TRACKING_EVENT -> {
                val eventId = arguments[0] as String
                val properties = (arguments[1] as? Map<*, *>)?.toVisitorProperty()
                screeb?.trackEvent(eventId, properties)
                result.success(true)
            }
            CALL_SEND_TRACKING_SCREEN -> {
                val screen = arguments[0] as String
                val properties = (arguments[1] as? Map<*, *>)?.toVisitorProperty()
                screeb?.trackScreen(screen, properties)
                result.success(true)
            }
            CALL_VISITOR_PROPERTY -> {
                val map = (arguments[0] as Map<*, *>).toVisitorProperty()
                screeb?.setVisitorProperties(map)
                result.success(true)
            }
            CALL_START_SURVEY -> {
                val surveyId = arguments[0] as String
                val allowMultipleResponses = arguments[1] as Boolean
                val hiddenFields = (arguments[2] as Map<*, *>)?.toVisitorProperty()
                screeb?.startSurvey(
                        surveyId,
                        allowMultipleResponses,
                        (hiddenFields?.filterValues { it != null }) as HashMap<String, Any>?
                )
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    companion object {
        var screeb: Screeb? = null
        const val ERROR_SCREEB_NOT_INIT = "ERROR_SCREEB_NOT_INIT"

        const val CALL_INIT_SDK = "initSdk"
        const val CALL_SET_IDENTITY = "setIdentity"
        const val CALL_SEND_TRACKING_EVENT = "trackEvent"
        const val CALL_SEND_TRACKING_SCREEN = "trackScreen"
        const val CALL_VISITOR_PROPERTY = "setProperty"
        const val CALL_START_SURVEY = "startSurvey"

        fun setAppContext(context: Context){
            screeb = Screeb.Builder()
                .withContext(context)
                .withPluginMode(true)
                .build()
        }
    }
}

private fun <K, V> Map<K, V>.toVisitorProperty(): HashMap<String, Any?> {
    return HashMap<String, Any?>().apply {
        this@toVisitorProperty.forEach {
            this[it.key as String] = it.value
        }
    }
}
