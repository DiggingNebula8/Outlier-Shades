using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class OutlierShadesGUITrasparent : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {

        Texture2D shaderBanner = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/OutlierShades/Outlier-Shades/Editor/ShaderBanner.png", typeof(Texture2D));

        //base.OnGUI(materialEditor, properties);
        MaterialProperty _MaterialMode = ShaderGUI.FindProperty("_MaterialMode", properties);
        MaterialProperty _UseToonRamp = ShaderGUI.FindProperty("_UseToonRamp", properties);
        MaterialProperty _UseSpecularRamp = ShaderGUI.FindProperty("_UseSpecularRamp", properties);
        MaterialProperty _ForceGrayscale = ShaderGUI.FindProperty("_ForceGrayscale", properties);

        MaterialProperty _LightIntensity = ShaderGUI.FindProperty("_LightIntensity", properties);
        MaterialProperty _AdditionalLightIntensity = ShaderGUI.FindProperty("_AdditionalLightIntensity", properties);

        MaterialProperty _RampBias = ShaderGUI.FindProperty("_RampBias", properties);
        MaterialProperty _RampScale = ShaderGUI.FindProperty("_RampScale", properties);
        MaterialProperty _ScaleandOffset = ShaderGUI.FindProperty("_ScaleandOffset", properties);

        MaterialProperty _UseRimLight = ShaderGUI.FindProperty("_UseRimLight", properties);
        MaterialProperty _UseEmission = ShaderGUI.FindProperty("_UseEmission", properties);

        MaterialProperty _Albedo = ShaderGUI.FindProperty("_Albedo", properties);
        MaterialProperty _Tint = ShaderGUI.FindProperty("_Tint", properties);


        MaterialProperty _Normal = ShaderGUI.FindProperty("_Normal", properties);
        MaterialProperty _NormalScale = ShaderGUI.FindProperty("_NormalScale", properties);

        MaterialProperty _Gloss = ShaderGUI.FindProperty("_Gloss", properties);
        MaterialProperty _Specular = ShaderGUI.FindProperty("_Specular", properties);
        MaterialProperty _SpecInten = ShaderGUI.FindProperty("_SpecInten", properties);
        MaterialProperty _SpecularTint = ShaderGUI.FindProperty("_SpecularTint", properties);
        MaterialProperty _SpecTintBlend = ShaderGUI.FindProperty("_SpecTintBlend", properties);

        MaterialProperty _UseAlpha = ShaderGUI.FindProperty("_UseAlpha", properties);
        MaterialProperty _Alpha = ShaderGUI.FindProperty("_Alpha", properties);




        if (!shaderBanner)
        {
            Debug.LogError("Missing texture, assign a texture in the inspector");
        }
        GUILayout.Box(shaderBanner, GUILayout.Width(450), GUILayout.Height(75), GUILayout.ExpandWidth(true));

        GUILayout.Label("Material Mode", EditorStyles.boldLabel);
        GUILayout.Space(10);
        materialEditor.ShaderProperty(_MaterialMode, _MaterialMode.displayName);
        GUILayout.Space(20);

        GUILayout.Label("Light Settings", EditorStyles.boldLabel);
        GUILayout.Space(10);
        materialEditor.ShaderProperty(_LightIntensity, _LightIntensity.displayName);
        materialEditor.ShaderProperty(_AdditionalLightIntensity, _AdditionalLightIntensity.displayName);
        GUILayout.Space(20);


        GUILayout.Label("Albedo", EditorStyles.boldLabel);
        GUILayout.Space(10);
        materialEditor.ShaderProperty(_Albedo, _Albedo.displayName);
        materialEditor.ShaderProperty(_Tint, _Tint.displayName);
        GUILayout.Space(20);

        GUILayout.Label("Normal", EditorStyles.boldLabel);
        GUILayout.Space(10);
        materialEditor.ShaderProperty(_Normal, _Normal.displayName);
        materialEditor.ShaderProperty(_NormalScale, _NormalScale.displayName);
        GUILayout.Space(20);

        if (_MaterialMode.floatValue != 0)
        {
            GUILayout.Label("Specular", EditorStyles.boldLabel);
            GUILayout.Space(10);
            materialEditor.ShaderProperty(_Gloss, _Gloss.displayName);
            materialEditor.ShaderProperty(_Specular, _Specular.displayName);
            materialEditor.ShaderProperty(_SpecInten, _SpecInten.displayName);
            materialEditor.ShaderProperty(_SpecularTint, _SpecularTint.displayName);
            materialEditor.ShaderProperty(_SpecTintBlend, _SpecTintBlend.displayName);
            GUILayout.Space(20);
        }

        GUILayout.Label("Toon Ramp", EditorStyles.boldLabel);
        GUILayout.Space(10);
        if (_MaterialMode.floatValue == 0)
        {
            materialEditor.ShaderProperty(_UseToonRamp, _UseToonRamp.displayName);
        }
        if (_MaterialMode.floatValue == 1)
        {
            materialEditor.ShaderProperty(_UseSpecularRamp, _UseSpecularRamp.displayName);
        }
        if (_MaterialMode.floatValue == 2)
        {
            materialEditor.ShaderProperty(_UseToonRamp, _UseToonRamp.displayName);
            materialEditor.ShaderProperty(_UseSpecularRamp, _UseSpecularRamp.displayName);
        }

        if (_UseToonRamp.floatValue == 1)
        {

            MaterialProperty _ToonRamp = ShaderGUI.FindProperty("_ToonRamp", properties);

            GUILayout.Space(10);
            materialEditor.ShaderProperty(_ToonRamp, _ToonRamp.displayName);
            GUILayout.Space(10);
        }
        if (_UseSpecularRamp.floatValue == 1)
        {
            MaterialProperty _SpecularRamp = ShaderGUI.FindProperty("_SpecularRamp", properties);

            GUILayout.Space(10);
            materialEditor.ShaderProperty(_SpecularRamp, _SpecularRamp.displayName);
            GUILayout.Space(10);
        }

        materialEditor.ShaderProperty(_ForceGrayscale, _ForceGrayscale.displayName);
        materialEditor.ShaderProperty(_RampBias, _RampBias.displayName);
        materialEditor.ShaderProperty(_RampScale, _RampScale.displayName);
        materialEditor.ShaderProperty(_ScaleandOffset, _ScaleandOffset.displayName);

        GUILayout.Space(20);
        GUILayout.Label("Settings", EditorStyles.boldLabel);
        GUILayout.Space(10);
        materialEditor.ShaderProperty(_UseAlpha, _UseAlpha.displayName);
        //materialEditor.ShaderProperty(_UseHatching, _UseHatching.displayName);
        materialEditor.ShaderProperty(_UseRimLight, _UseRimLight.displayName);
        materialEditor.ShaderProperty(_UseEmission, _UseEmission.displayName);
        GUILayout.Space(20);


        if (_UseRimLight.floatValue == 1)
        {
            MaterialProperty _RimTint = ShaderGUI.FindProperty("_RimTint", properties);
            MaterialProperty _RimOffset = ShaderGUI.FindProperty("_RimOffset", properties);
            MaterialProperty _RimPower = ShaderGUI.FindProperty("_RimPower", properties);

            GUILayout.Label("Rim", EditorStyles.boldLabel);
            GUILayout.Space(10);
            materialEditor.ShaderProperty(_RimTint, _RimTint.displayName);
            materialEditor.ShaderProperty(_RimOffset, _RimOffset.displayName);
            materialEditor.ShaderProperty(_RimPower, _RimPower.displayName);
            GUILayout.Space(20);

        }

        if (_UseAlpha.floatValue == 1)
        {
            GUILayout.Label("Alpha", EditorStyles.boldLabel);
            GUILayout.Space(10);

            GUILayout.Label("Alpha Map", EditorStyles.label);
            materialEditor.ShaderProperty(_Alpha, _Alpha.displayName);
            GUILayout.Space(10);
        }

        if (_UseEmission.floatValue == 1)
        {
            MaterialProperty _EmissiveIntensity = ShaderGUI.FindProperty("_EmissiveIntensity", properties);
            MaterialProperty _EmissiveMap = ShaderGUI.FindProperty("_EmissiveMap", properties);
            MaterialProperty _FresnelPower = ShaderGUI.FindProperty("_FresnelPower", properties);

            GUILayout.Label("Rim", EditorStyles.boldLabel);
            GUILayout.Space(10);
            materialEditor.ShaderProperty(_EmissiveMap, _EmissiveMap.displayName);
            materialEditor.ShaderProperty(_EmissiveIntensity, _EmissiveIntensity.displayName);
            materialEditor.ShaderProperty(_FresnelPower, _FresnelPower.displayName);
            GUILayout.Space(20);

        }
    }
}
