package app.screeb.plugin_screeb

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

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugin_screeb")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val arguments = call.arguments as ArrayList<*>
        if (call.method == CALL_INIT_SDK) {
            val channelId = arguments[0] as String
            screeb = Screeb.Builder()
                    .withContext(this)
                    .withChannelId(channelId)
                    .build();
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
                screeb?.setIdentity(userId)
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
        const val CALL_SEND_TRACKING_EVENT = "sendTrackingEvent"
        const val CALL_SEND_TRACKING_SCREEN = "sendTrackingScreen"
        const val CALL_VISITOR_PROPERTY = "visitorProperty"
    }
}

private fun <K, V> Map<K, V>.toVisitorProperty(): HashMap<String, Any?> {
    return HashMap<String, Any?>().apply {
        this@toVisitorProperty.forEach {
            this[it.key as String] = it.value
        }
    }
}
