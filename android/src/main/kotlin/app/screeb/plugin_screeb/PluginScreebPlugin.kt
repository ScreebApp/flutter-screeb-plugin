package app.screeb.plugin_screeb

import android.content.Context
import androidx.annotation.NonNull
import app.screeb.sdk.Screeb

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import java.util.HashMap

class PluginScreebPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugin_screeb")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        Screeb.setSecondarySDK("flutter", "2.2.3")
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val arguments = call.arguments as ArrayList<*>

        when (call.method) {
            CALL_INIT_SDK -> {
                val channelId = arguments[0] as String
                val userId: String? = arguments[1] as? String
                val properties = (arguments[2] as? Map<*, *>)?.toProperty()
                val initOptions = (arguments[3] as? Map<*, *>)?.toProperty()
                val hooks = (arguments[4] as? Map<*, *>)?.toProperty()
                val language: String? = arguments[5] as? String
                var mapHooks = hashMapOf<String, Any>()
                if (hooks != null) {
                    hooks.forEach { (key, value) ->
                        if (key == "version"){
                            mapHooks[key as String] = value as String
                        } else {
                            mapHooks[key as String] = { payload: Any -> channel.invokeMethod("handleHooks", hashMapOf("hookId" to value, "payload" to payload.toString()), object : MethodChannel.Result {
                                override fun success(result: Any?) {
                                    val obj = payload as? JSONObject ?: return
                                    val hookId = obj.getString("hook_id") ?: return
                                    Screeb.onHookResult(hookId, result)
                                }

                                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                                    println("error: $errorCode, $errorMessage, $errorDetails")
                                }

                                override fun notImplemented() {}
                            }) }
                        }
                    }
                }

                Screeb.pluginInit(channelId, userId, properties, initOptions, mapHooks, language)
                return result.success(true)
            }
            CALL_SET_IDENTITY -> {
                val userId = arguments[0] as String
                val properties = (arguments[1] as? Map<*, *>)?.toProperty()
                Screeb.setIdentity(userId, properties)
                result.success(true)
            }
            CALL_VISITOR_PROPERTY -> {
                val map = (arguments[0] as Map<*, *>).toProperty()
                Screeb.setVisitorProperties(map)
                result.success(true)
            }
            CALL_SEND_ASSIGN_GROUP -> {
                val groupType = arguments[0] as? String
                val groupName = arguments[1] as String
                val map = (arguments[2] as? Map<*, *>)?.toProperty()
                Screeb.assignGroup(groupType, groupName, map)
                result.success(true)
            }
            CALL_SEND_UNASSIGN_GROUP -> {
                val groupType = arguments[0] as? String
                val groupName = arguments[1] as String
                val map = (arguments[2] as? Map<*, *>)?.toProperty()
                Screeb.unassignGroup(groupType, groupName, map)
                result.success(true)
            }
            CALL_SEND_TRACKING_EVENT -> {
                val eventId = arguments[0] as String
                val properties = (arguments[1] as? Map<*, *>)?.toProperty()
                Screeb.trackEvent(eventId, properties)
                result.success(true)
            }
            CALL_SEND_TRACKING_SCREEN -> {
                val screen = arguments[0] as String
                val properties = (arguments[1] as? Map<*, *>)?.toProperty()
                Screeb.trackScreen(screen, properties)
                result.success(true)
            }
            CALL_START_SURVEY -> {
                val surveyId = arguments[0] as String
                val allowMultipleResponses = arguments[1] as Boolean
                val hiddenFields = (arguments[2] as? Map<*, *>)?.toProperty()
                val ignoreSurveyStatus = arguments[3] as Boolean
                val hooks = (arguments[4] as? Map<*, *>)?.toProperty()
                val language = arguments[5] as? String
                val distributionId = arguments[6] as? String
                var mapHooks = hashMapOf<String, Any>()
                if (hooks != null) {
                    hooks.forEach { (key, value) ->
                        if (key == "version"){
                            mapHooks[key as String] = value as String
                        } else {
                            mapHooks[key as String] = { payload:Any -> channel.invokeMethod("handleHooks", hashMapOf("hookId" to value, "payload" to payload.toString()), object : MethodChannel.Result {
                                override fun success(result: Any?) {
                                    val obj = payload as? JSONObject ?: return
                                    val hookId = obj.getString("hook_id") ?: return
                                    Screeb.onHookResult(hookId, result)
                                }

                                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                                    println("error: $errorCode, $errorMessage, $errorDetails")
                                }

                                override fun notImplemented() {}
                            }) }
                        }
                    }
                }

                Screeb.startSurvey(
                    surveyId = surveyId,
                    allowMultipleResponses,
                    (hiddenFields?.filterValues { it != null }) as HashMap<String, Any?>?,
                    ignoreSurveyStatus,
                    mapHooks.isNotEmpty().let { if (it) mapHooks else null },
                    language,
                    distributionId
                )
                result.success(true)
            }
            CALL_START_MESSAGE -> {
                val messageId = arguments[0] as String
                val allowMultipleResponses = arguments[1] as Boolean
                val hiddenFields = (arguments[2] as? Map<*, *>)?.toProperty()
                val ignoreMessageStatus = arguments[3] as Boolean
                val hooks = (arguments[4] as? Map<*, *>)?.toProperty()
                val language = arguments[5] as? String
                val distributionId = arguments[6] as? String
                var mapHooks = hashMapOf<String, Any>()
                if (hooks != null) {
                    hooks.forEach { (key, value) ->
                        if (key == "version"){
                            mapHooks[key as String] = value as String
                        } else {
                            mapHooks[key as String] = { payload:Any -> channel.invokeMethod("handleHooks", hashMapOf("hookId" to value, "payload" to payload.toString()), object : MethodChannel.Result {
                                override fun success(result: Any?) {
                                    val obj = payload as? JSONObject ?: return
                                    val hookId = obj.getString("hook_id") ?: return
                                    Screeb.onHookResult(hookId, result)
                                }

                                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                                    println("error: $errorCode, $errorMessage, $errorDetails")
                                }

                                override fun notImplemented() {}
                            }) }
                        }
                    }
                }

                Screeb.startMessage(
                    messageId = messageId,
                    allowMultipleResponses,
                    (hiddenFields?.filterValues { it != null }) as HashMap<String, Any?>?,
                    ignoreMessageStatus,
                    mapHooks.isNotEmpty().let { if (it) mapHooks else null },
                    language,
                    distributionId
                )
                result.success(true)
            }
            CALL_CLOSE_SDK -> {
                Screeb.closeSdk()
                result.success(true)
            }
            CALL_CLOSE_SURVEY -> {
                val surveyId: String? = arguments[0] as? String
                Screeb.closeSurvey(surveyId = surveyId)
                result.success(true)
            }
            CALL_CLOSE_MESSAGE -> {
                val messageId: String? = arguments[0] as? String
                Screeb.closeMessage(messageId = messageId)
                result.success(true)
            }
            CALL_RESET_IDENTITY -> {
                Screeb.resetIdentity()
                result.success(true)
            }
            CALL_DEBUG -> {
                Screeb.debug()
                result.success(true)
            }
            CALL_DEBUG_TARGETING -> {
                Screeb.debugTargeting()
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
        const val CALL_INIT_SDK = "initSdk"
        const val CALL_SET_IDENTITY = "setIdentity"
        const val CALL_VISITOR_PROPERTY = "setProperty"
        const val CALL_SEND_ASSIGN_GROUP = "assignGroup"
        const val CALL_SEND_UNASSIGN_GROUP = "unassignGroup"
        const val CALL_SEND_TRACKING_EVENT = "trackEvent"
        const val CALL_SEND_TRACKING_SCREEN = "trackScreen"
        const val CALL_START_SURVEY = "startSurvey"
        const val CALL_START_MESSAGE = "startMessage"
        const val CALL_CLOSE_SDK = "closeSdk"
        const val CALL_CLOSE_SURVEY = "closeSurvey"
        const val CALL_CLOSE_MESSAGE = "closeMessage"
        const val CALL_RESET_IDENTITY = "resetIdentity"
        const val CALL_DEBUG = "debug"
        const val CALL_DEBUG_TARGETING = "debugTargeting"

        fun setAppContext(context: Context){
            Screeb.initSdkWithContextOnly(context)
        }
    }
}

private fun <K, V> Map<K, V>.toProperty(): HashMap<String, Any?> {
    return HashMap<String, Any?>().apply {
        this@toProperty.forEach {
            this[it.key as String] = it.value
        }
    }
}
