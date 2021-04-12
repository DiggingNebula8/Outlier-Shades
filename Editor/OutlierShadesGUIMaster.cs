using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class OutlierShadesGUIMaster : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {

        Texture2D shaderBanner = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/OutlierShades/Editor/ShaderBanner.png", typeof(Texture2D));

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
        MaterialProperty _RAlbedo = ShaderGUI.FindProperty("_RAlbedo", properties);
        MaterialProperty _GAlbedo = ShaderGUI.FindProperty("_GAlbedo", properties);
        MaterialProperty _BAlbedo = ShaderGUI.FindProperty("_BAlbedo", properties);
        MaterialProperty _Tint = ShaderGUI.FindProperty("_Tint", properties);
        //MaterialProperty _UseAlpha = ShaderGUI.FindProperty("_UseAlpha", properties);
        //MaterialProperty _Alpha = ShaderGUI.FindProperty("_Alpha", properties);
        

        MaterialProperty _Normal = ShaderGUI.FindProperty("_Normal", properties);
        MaterialProperty _RNormal = ShaderGUI.FindProperty("_RNormal", properties);
        MaterialProperty _GNormal = ShaderGUI.FindProperty("_GNormal", properties);
        MaterialProperty _BNormal = ShaderGUI.FindProperty("_BNormal", properties);
        MaterialProperty _NormalScale = ShaderGUI.FindProperty("_NormalScale", properties);
        
        MaterialProperty _Gloss = ShaderGUI.FindProperty("_Gloss", properties);
        MaterialProperty _Specular = ShaderGUI.FindProperty("_Specular", properties);
        MaterialProperty _SpecInten = ShaderGUI.FindProperty("_SpecInten", properties);
        MaterialProperty _SpecularTint = ShaderGUI.FindProperty("_SpecularTint", properties);
        MaterialProperty _SpecTintBlend = ShaderGUI.FindProperty("_SpecTintBlend", properties);

        MaterialProperty _UseVertexColours = ShaderGUI.FindProperty("_UseVertexColours", properties);
        MaterialProperty _NoiseSpread = ShaderGUI.FindProperty("_NoiseSpread", properties);
        MaterialProperty _NoiseScale = ShaderGUI.FindProperty("_NoiseScale", properties);

        MaterialProperty _UseRockLayering = ShaderGUI.FindProperty("_UseRockLayering", properties);
        MaterialProperty _GeoScaling = ShaderGUI.FindProperty("_GeoScaling", properties);
        MaterialProperty _GeoGradientAlbedo = ShaderGUI.FindProperty("_GeoGradientAlbedo", properties);
        MaterialProperty _GeoGradientNormal = ShaderGUI.FindProperty("_GeoGradientNormal", properties);
        MaterialProperty _GeoLayerOpacity = ShaderGUI.FindProperty("_GeoLayerOpacity", properties);
        MaterialProperty _GeoNoise = ShaderGUI.FindProperty("_GeoNoise", properties);
        MaterialProperty _GeoWarp = ShaderGUI.FindProperty("_GeoWarp", properties);
        MaterialProperty _NoiseSize = ShaderGUI.FindProperty("_NoiseSize", properties);
        MaterialProperty _UseTopCoverage = ShaderGUI.FindProperty("_UseTopCoverage", properties);
        MaterialProperty _CoverageAlbedo = ShaderGUI.FindProperty("_CoverageAlbedo", properties);
        MaterialProperty _CoverageNormal = ShaderGUI.FindProperty("_CoverageNormal", properties);
        MaterialProperty _CoverageTiling = ShaderGUI.FindProperty("_CoverageTiling", properties);
        MaterialProperty _CoverageAmount = ShaderGUI.FindProperty("_CoverageAmount", properties);
        MaterialProperty _CoverageNoiseScale = ShaderGUI.FindProperty("_CoverageNoiseScale", properties);
        MaterialProperty _CoverageSpread = ShaderGUI.FindProperty("_CoverageSpread", properties);

        MaterialProperty _UseWorldGradient = ShaderGUI.FindProperty("_UseWorldGradient", properties);
        MaterialProperty _GradientTone = ShaderGUI.FindProperty("_GradientTone", properties);
        MaterialProperty _GradientScale = ShaderGUI.FindProperty("_GradientScale", properties);


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
       // materialEditor.ShaderProperty(_UseAlpha, _UseAlpha.displayName);
        //materialEditor.ShaderProperty(_UseHatching, _UseHatching.displayName);
        materialEditor.ShaderProperty(_UseRimLight, _UseRimLight.displayName);
        materialEditor.ShaderProperty(_UseEmission, _UseEmission.displayName);
        materialEditor.ShaderProperty(_UseVertexColours, _UseVertexColours.displayName);
        materialEditor.ShaderProperty(_UseRockLayering, _UseRockLayering.displayName);
        materialEditor.ShaderProperty(_UseWorldGradient, _UseWorldGradient.displayName);
        materialEditor.ShaderProperty(_UseTopCoverage, _UseTopCoverage.displayName);
        GUILayout.Space(20);

        /*
        if (_UseAlpha.floatValue == 1)
        {
            GUILayout.Label("Alpha", EditorStyles.boldLabel);
            GUILayout.Space(10);

            GUILayout.Label("Edge Noise", EditorStyles.label);
            materialEditor.ShaderProperty(_Alpha, _Alpha.displayName);
            GUILayout.Space(10);
        }
        */


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

        if (_UseEmission.floatValue == 1)
        {
            MaterialProperty _EmissiveIntensity = ShaderGUI.FindProperty("_EmissiveIntensity", properties);
            MaterialProperty _EmissiveMap = ShaderGUI.FindProperty("_EmissiveMap", properties);
            MaterialProperty _FresnelPower = ShaderGUI.FindProperty("_FresnelPower", properties);

            GUILayout.Label("Emission", EditorStyles.boldLabel);
            GUILayout.Space(10);
            materialEditor.ShaderProperty(_EmissiveMap, _EmissiveMap.displayName);
            materialEditor.ShaderProperty(_EmissiveIntensity, _EmissiveIntensity.displayName);
            materialEditor.ShaderProperty(_FresnelPower, _FresnelPower.displayName);
            GUILayout.Space(20);

        }

        if (_UseVertexColours.floatValue == 1)
        {
            GUILayout.Label("Vertex Colours", EditorStyles.boldLabel);
            GUILayout.Space(10);

            GUILayout.Label("Edge Noise", EditorStyles.label);
            materialEditor.ShaderProperty(_NoiseSpread, _NoiseSpread.displayName);
            materialEditor.ShaderProperty(_NoiseScale, _NoiseScale.displayName);
            GUILayout.Space(10);

            GUILayout.Label("R Channel", EditorStyles.label);
            materialEditor.ShaderProperty(_RAlbedo, _RAlbedo.displayName);
            materialEditor.ShaderProperty(_RNormal, _RNormal.displayName);
            GUILayout.Space(10);

            GUILayout.Label("G Channel", EditorStyles.label);
            materialEditor.ShaderProperty(_GAlbedo, _GAlbedo.displayName);
            materialEditor.ShaderProperty(_GNormal, _GNormal.displayName);
            GUILayout.Space(10);

            GUILayout.Label("B Channel", EditorStyles.label);
            materialEditor.ShaderProperty(_BAlbedo, _BAlbedo.displayName);
            materialEditor.ShaderProperty(_BNormal, _BNormal.displayName);
            GUILayout.Space(20);
        }

        if (_UseTopCoverage.floatValue == 1)
        {
            GUILayout.Label("Top Coverage", EditorStyles.boldLabel);
            GUILayout.Space(10);

            materialEditor.ShaderProperty(_CoverageAlbedo, _CoverageAlbedo.displayName);
            materialEditor.ShaderProperty(_CoverageNormal, _CoverageNormal.displayName);
            materialEditor.ShaderProperty(_CoverageTiling, _CoverageTiling.displayName);
            materialEditor.ShaderProperty(_CoverageAmount, _CoverageAmount.displayName);
            materialEditor.ShaderProperty(_CoverageNoiseScale, _CoverageNoiseScale.displayName);
            materialEditor.ShaderProperty(_CoverageSpread, _CoverageSpread.displayName);
            GUILayout.Space(20);
        }

        if (_UseRockLayering.floatValue == 1)
        {
            GUILayout.Label("Rock Layering", EditorStyles.boldLabel);
            GUILayout.Space(10);
            materialEditor.ShaderProperty(_GeoGradientAlbedo, _GeoGradientAlbedo.displayName);
            materialEditor.ShaderProperty(_GeoGradientNormal, _GeoGradientNormal.displayName);
            materialEditor.ShaderProperty(_GeoLayerOpacity, _GeoLayerOpacity.displayName);
            materialEditor.ShaderProperty(_GeoScaling, _GeoScaling.displayName);
            materialEditor.ShaderProperty(_GeoNoise, _GeoNoise.displayName);
            materialEditor.ShaderProperty(_GeoWarp, _GeoWarp.displayName);
            materialEditor.ShaderProperty(_NoiseSize, _NoiseSize.displayName);
            GUILayout.Space(20);
        }

        if (_UseWorldGradient.floatValue == 1)
        {
            GUILayout.Label("World Gradient", EditorStyles.boldLabel);
            GUILayout.Space(10);
            materialEditor.ShaderProperty(_GradientTone, _GradientTone.displayName);
            materialEditor.ShaderProperty(_GradientScale, _GradientScale.displayName);
            GUILayout.Space(20);
        }

        /*
        if (_UseHatching.floatValue == 1)
        {
            MaterialProperty _InkThickness = ShaderGUI.FindProperty("_InkThickness", properties);
            MaterialProperty _HatchingMap = ShaderGUI.FindProperty("_HatchingMap", properties);
            MaterialProperty _DistanceHatchingMap = ShaderGUI.FindProperty("_DistanceHatchingMap", properties);
            MaterialProperty _UseCrossHatch = ShaderGUI.FindProperty("_UseCrossHatch", properties);
            MaterialProperty _SecondHatchingMap = ShaderGUI.FindProperty("_SecondHatchingMap", properties);
            MaterialProperty _ThirdHatchingMap = ShaderGUI.FindProperty("_ThirdHatchingMap", properties);
            MaterialProperty _ForthHatchingMap = ShaderGUI.FindProperty("_ForthHatchingMap", properties);
            MaterialProperty _FirstTransition = ShaderGUI.FindProperty("_FirstTransition", properties);
            MaterialProperty _SecondTransition = ShaderGUI.FindProperty("_SecondTransition", properties);
            MaterialProperty _ThirdTransition = ShaderGUI.FindProperty("_ThirdTransition", properties);
            MaterialProperty _Distance = ShaderGUI.FindProperty("_Distance", properties);
            MaterialProperty _BlendPower = ShaderGUI.FindProperty("_BlendPower", properties);
            MaterialProperty _HatchNearTiling = ShaderGUI.FindProperty("_HatchNearTiling", properties);
            MaterialProperty _HatchFarTiling = ShaderGUI.FindProperty("_HatchFarTiling", properties);
            MaterialProperty _HatchBlend = ShaderGUI.FindProperty("_HatchBlend", properties);
            MaterialProperty _HatchContrast = ShaderGUI.FindProperty("_HatchContrast", properties);

            GUILayout.Label("Hatching", EditorStyles.boldLabel);
            GUILayout.Space(10);
            GUILayout.Label("Distance Blend Settings", EditorStyles.label);
            GUILayout.Space(10);
            materialEditor.ShaderProperty(_Distance, _Distance.displayName);
            materialEditor.ShaderProperty(_BlendPower, _BlendPower.displayName);
            materialEditor.ShaderProperty(_HatchNearTiling, _HatchNearTiling.displayName);
            materialEditor.ShaderProperty(_HatchFarTiling, _HatchFarTiling.displayName);
            GUILayout.Space(10);
            GUILayout.Label("Hatch Settings", EditorStyles.label);
            GUILayout.Space(10);
            materialEditor.ShaderProperty(_InkThickness, _InkThickness.displayName);
            materialEditor.ShaderProperty(_HatchBlend, _HatchBlend.displayName);
            materialEditor.ShaderProperty(_HatchContrast, _HatchContrast.displayName);
            GUILayout.Space(10);
            GUILayout.Label("Hatch Maps", EditorStyles.label);
            GUILayout.Space(10);
            materialEditor.ShaderProperty(_UseCrossHatch, _UseCrossHatch.displayName);
            materialEditor.ShaderProperty(_HatchingMap, _HatchingMap.displayName);
            materialEditor.ShaderProperty(_DistanceHatchingMap, _DistanceHatchingMap.displayName);
            if (_UseCrossHatch.floatValue == 1)
            {
                materialEditor.ShaderProperty(_SecondHatchingMap, _SecondHatchingMap.displayName);
                materialEditor.ShaderProperty(_ThirdHatchingMap, _ThirdHatchingMap.displayName);
                materialEditor.ShaderProperty(_ForthHatchingMap, _ForthHatchingMap.displayName);
                GUILayout.Space(10);
                GUILayout.Label("Cross-Hatch Settings", EditorStyles.label);
                GUILayout.Space(10);
                materialEditor.ShaderProperty(_FirstTransition, _FirstTransition.displayName);
                materialEditor.ShaderProperty(_SecondTransition, _SecondTransition.displayName);
                materialEditor.ShaderProperty(_ThirdTransition, _ThirdTransition.displayName);
            }
        }
        */
    }
}
