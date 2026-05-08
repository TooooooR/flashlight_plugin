package com.example.flashlight_plugin

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlashlightPlugin */
class FlashlightPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var cameraManager: CameraManager? = null
    private var torchCameraId: String? = null
    private var torchEnabled = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flashlight_plugin")
        channel.setMethodCallHandler(this)

        val manager =
            flutterPluginBinding.applicationContext.getSystemService(Context.CAMERA_SERVICE)
                as CameraManager
        cameraManager = manager
        torchCameraId = resolveTorchCameraId(manager)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "toggle" -> toggleTorch(result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        cameraManager = null
        torchCameraId = null
    }

    private fun toggleTorch(result: Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            result.error("UNSUPPORTED", "Torch requires Android 6.0+", null)
            return
        }

        val manager = cameraManager
        val cameraId = torchCameraId
        if (manager == null || cameraId == null) {
            result.error("NO_FLASH", "No camera with flash available", null)
            return
        }

        val newState = !torchEnabled
        try {
            manager.setTorchMode(cameraId, newState)
            torchEnabled = newState
            result.success(torchEnabled)
        } catch (e: Exception) {
            result.error("TORCH_ERROR", e.message, null)
        }
    }

    private fun resolveTorchCameraId(manager: CameraManager): String? {
        for (cameraId in manager.cameraIdList) {
            val characteristics = manager.getCameraCharacteristics(cameraId)
            val hasFlash =
                characteristics.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
            if (hasFlash) {
                return cameraId
            }
        }
        return null
    }
}
