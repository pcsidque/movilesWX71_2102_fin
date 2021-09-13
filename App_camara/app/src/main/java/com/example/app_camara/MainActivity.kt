package com.example.app_camara

import android.Manifest
import android.content.pm.PackageManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity : AppCompatActivity() {
    private val CAMERA_REQUEST_CODE = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val btCamara = findViewById<Button>(R.id.btCamara)

        btCamara.setOnClickListener {
            checkCameraPermission()
        }
    }

    private fun checkCameraPermission() {
        // si la camara no tiene permiso
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA)
        != PackageManager.PERMISSION_GRANTED)
        {
            //no tengo permiso
            requestCameraPermission()
        }
        else{
            //tengo permiso
            Toast.makeText(this, "Ya se cuenta con acceso a la camara",
                Toast.LENGTH_LONG).show()
        }
    }

    private fun requestCameraPermission() {
        if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.CAMERA))
        {
            //el permiso fue negado, debe ir a ajustes
            Toast.makeText(this, "Rechazó el permiso antes. Habilítelo manualmente",
                Toast.LENGTH_LONG).show()
        }
        else{
            //1ra vez q se pide el permiso
            Toast.makeText(this, "Debe aceptar el permiso",
                Toast.LENGTH_LONG).show()

            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA),CAMERA_REQUEST_CODE)
        }
    }

    //escuchar la rpta
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when(requestCode){
            CAMERA_REQUEST_CODE -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)
                {
                    //permiso aceptado.
                    Toast.makeText(this, "Se AUTORIZO el permiso",
                        Toast.LENGTH_LONG).show()

                    // Recien aqui se puede llamar a la funcionalidad
                }
                else{
                    //permiso negado
                    Toast.makeText(this, "Se DENEGO el permiso",
                        Toast.LENGTH_LONG).show()
                }
                return
            }
        }
    }
}