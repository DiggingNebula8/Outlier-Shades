// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "OutlierShades/ToonieV2 Master Opaque"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[KeywordEnum(Flat,Metallic,SpecMap)] _MaterialMode("Material Mode", Float) = 0
		_Albedo("Albedo", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,0)
		_Normal("Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 1)) = 0.4098032
		_Specular("Specular", 2D) = "white" {}
		_Gloss("Gloss", Range( 0 , 1)) = 0
		_SpecularTint("Specular Tint", Color) = (1,1,1,0)
		_SpecInten("Spec Inten", Range( 0 , 1)) = 0
		_CoverageNoiseScale("CoverageNoiseScale", Float) = 100
		_CoverageSpread("CoverageSpread", Float) = 5.83
		[Toggle(_INVERTGRADIENT_ON)] _InvertGradient("Invert Gradient", Float) = 0
		_GeoGradientNormal("Geo Gradient Normal", 2D) = "bump" {}
		_GeoGradientAlbedo("Geo Gradient Albedo", 2D) = "white" {}
		_GeoWarp("Geo Warp", Range( 0 , 10)) = 0.05
		_NoiseSize("Noise Size", Range( 0 , 10)) = 0.3
		_GeoNoise("Geo Noise", Range( 1 , 200)) = 100
		_GeoScaling("Geo Scaling", Range( 0 , 1)) = 1
		_GeoLayerOpacity("Geo Layer Opacity", Range( 0.5 , 1)) = 0.5
		_SpecTintBlend("Spec Tint Blend", Range( 0 , 1)) = 0
		[Toggle(_USETOONRAMP_ON)] _UseToonRamp("Use Toon Ramp?", Float) = 0
		[Toggle(_USESPECULARRAMP_ON)] _UseSpecularRamp("Use Specular Ramp?", Float) = 0
		_EmissiveMap("Emissive Map", 2D) = "white" {}
		_SpecularRamp("Specular Ramp", 2D) = "white" {}
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		_ScaleandOffset("Scale and Offset", Float) = 0.5
		_RimTint("RimTint", Color) = (0.6226415,0.6226415,0.6226415,0)
		[Toggle(_USEEMISSION_ON)] _UseEmission("Use Emission?", Float) = 0
		_EmissiveIntensity("Emissive Intensity", Range( 1 , 50)) = 1
		_RAlbedo("R Albedo", 2D) = "white" {}
		_FresnelPower("Fresnel Power", Range( 0 , 1)) = 1
		_RimOffset("Rim Offset", Float) = 0.5
		_GAlbedo("G Albedo", 2D) = "white" {}
		_RimPower("Rim Power", Range( 0 , 1)) = 0.6361759
		_BAlbedo("B Albedo", 2D) = "white" {}
		_CoverageAlbedo("Coverage Albedo", 2D) = "white" {}
		_RampBias("Ramp Bias", Range( 0 , 2)) = 1
		[Toggle(_FORCEGRAYSCALE_ON)] _ForceGrayscale("Force Grayscale", Float) = 0
		_RampScale("Ramp Scale", Range( 0 , 2)) = 1
		_AdditionalLightIntensity("Additional Light Intensity", Range( 0 , 20)) = 3
		_RNormal("R Normal", 2D) = "white" {}
		_LightIntensity("Light Intensity", Range( 0 , 20)) = 3
		_GNormal("G Normal", 2D) = "white" {}
		_BNormal("B Normal", 2D) = "white" {}
		_CoverageNormal("Coverage Normal", 2D) = "white" {}
		[Toggle(_USEVERTEXCOLOURS_ON)] _UseVertexColours("Use Vertex Colours?", Float) = 0
		[Toggle(_USERIMLIGHT_ON)] _UseRimLight("Use Rim Light", Float) = 0
		[Toggle(_USEROCKLAYERING_ON)] _UseRockLayering("Use Rock Layering?", Float) = 0
		[Toggle(_USETOPCOVERAGE_ON)] _UseTopCoverage("Use Top Coverage?", Float) = 0
		[Toggle(_USEWORLDGRADIENT_ON)] _UseWorldGradient("Use World Gradient?", Float) = 0
		_NoiseSpread("Noise Spread", Range( 0 , 10)) = 1
		_NoiseScale("Noise Scale", Range( 0 , 200)) = 100
		_CoverageAmount("Coverage Amount", Float) = 0
		_GradientScale("Gradient Scale", Range( 0 , 20)) = 20
		_CoverageTiling("Coverage Tiling", Float) = 1
		[ASEEnd]_GradientTone("Gradient Tone", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
		Cull Front
		AlphaToMask Off
		HLSLINCLUDE
		#pragma target 5.0

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS

		ENDHLSL

		
		Pass
		{
			Name "ExtraPrePass"
			
			
			Blend One Zero
			Cull Back
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 100302

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma shader_feature_local _USEEMISSION_ON
			#pragma shader_feature_local _USEWORLDGRADIENT_ON
			#pragma shader_feature_local _USETOPCOVERAGE_ON
			#pragma shader_feature_local _USEROCKLAYERING_ON
			#pragma shader_feature_local _USEVERTEXCOLOURS_ON
			#pragma shader_feature_local _INVERTGRADIENT_ON
			#pragma shader_feature_local _FORCEGRAYSCALE_ON
			#pragma shader_feature_local _USETOONRAMP_ON
			#pragma shader_feature_local _USESPECULARRAMP_ON
			#pragma shader_feature_local _MATERIALMODE_FLAT _MATERIALMODE_METALLIC _MATERIALMODE_SPECMAP
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma shader_feature_local _USERIMLIGHT_ON
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Tint;
			float4 _RimTint;
			float4 _SpecularTint;
			float4 _Specular_ST;
			float4 _GradientTone;
			float4 _RNormal_ST;
			float4 _GNormal_ST;
			float4 _BNormal_ST;
			float4 _Normal_ST;
			float4 _EmissiveMap_ST;
			float4 _GAlbedo_ST;
			float4 _Albedo_ST;
			float4 _BAlbedo_ST;
			float4 _RAlbedo_ST;
			float _EmissiveIntensity;
			float _RimPower;
			float _RimOffset;
			float _SpecInten;
			float _SpecTintBlend;
			float _Gloss;
			float _AdditionalLightIntensity;
			float _LightIntensity;
			float _RampScale;
			float _RampBias;
			float _GeoWarp;
			float _ScaleandOffset;
			float _GradientScale;
			float _CoverageNoiseScale;
			float _FresnelPower;
			float _NoiseSpread;
			float _NoiseScale;
			float _GeoScaling;
			float _NormalScale;
			float _NoiseSize;
			float _CoverageSpread;
			float _CoverageTiling;
			float _GeoLayerOpacity;
			float _GeoNoise;
			float _CoverageAmount;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Albedo;
			sampler2D _BAlbedo;
			sampler2D _GAlbedo;
			sampler2D _RAlbedo;
			sampler2D _GeoGradientAlbedo;
			sampler2D _CoverageAlbedo;
			sampler2D _Normal;
			sampler2D _BNormal;
			sampler2D _GNormal;
			sampler2D _RNormal;
			sampler2D _GeoGradientNormal;
			sampler2D _CoverageNormal;
			sampler2D _ToonRamp;
			sampler2D _SpecularRamp;
			sampler2D _Specular;
			sampler2D _EmissiveMap;


			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			
			float3x3 Inverse3x3(float3x3 input)
			{
				float3 a = input._11_21_31;
				float3 b = input._12_22_32;
				float3 c = input._13_23_33;
				return float3x3(cross(b,c), cross(c,a), cross(a,b)) * (1.0 / dot(a,cross(b,c)));
			}
			
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			
			float3 AdditionalLightsLambert( float3 WorldPosition, float3 WorldNormal )
			{
				float3 Color = 0;
				#ifdef _ADDITIONAL_LIGHTS
				int numLights = GetAdditionalLightsCount();
				for(int i = 0; i<numLights;i++)
				{
					Light light = GetAdditionalLight(i, WorldPosition);
					half3 AttLightColor = light.color *(light.distanceAttenuation * light.shadowAttenuation);
					Color +=LightingLambert(AttLightColor, light.direction, WorldNormal);
					
				}
				#endif
				return Color;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord4.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord5.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord6.xyz = ase_worldBitangent;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				#ifdef ASE_FOG
				o.fogFactor = ComputeFogFactor( positionCS.z );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif
				float2 uv_Albedo = IN.ase_texcoord3.xy * _Albedo_ST.xy + _Albedo_ST.zw;
				float4 albedo34 = ( _Tint * tex2D( _Albedo, uv_Albedo ) );
				float2 uv_BAlbedo = IN.ase_texcoord3.xy * _BAlbedo_ST.xy + _BAlbedo_ST.zw;
				float2 uv_GAlbedo = IN.ase_texcoord3.xy * _GAlbedo_ST.xy + _GAlbedo_ST.zw;
				float2 uv_RAlbedo = IN.ase_texcoord3.xy * _RAlbedo_ST.xy + _RAlbedo_ST.zw;
				float temp_output_44_0_g190 = _NoiseSpread;
				float temp_output_9_0_g193 = IN.ase_color.r;
				float2 texCoord2_g193 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_53_0_g190 = _NoiseScale;
				float simpleNoise3_g193 = SimpleNoise( texCoord2_g193*temp_output_53_0_g190 );
				float4 temp_cast_0 = (( ( temp_output_9_0_g193 + simpleNoise3_g193 ) * temp_output_9_0_g193 )).xxxx;
				float4 clampResult8_g193 = clamp( CalculateContrast(temp_output_44_0_g190,temp_cast_0) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_96_0_g190 = clampResult8_g193;
				float4 lerpResult62_g190 = lerp( tex2D( _RAlbedo, uv_RAlbedo ) , albedo34 , temp_output_96_0_g190);
				float temp_output_9_0_g191 = IN.ase_color.g;
				float2 texCoord2_g191 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float simpleNoise3_g191 = SimpleNoise( texCoord2_g191*temp_output_53_0_g190 );
				float4 temp_cast_1 = (( ( temp_output_9_0_g191 + simpleNoise3_g191 ) * temp_output_9_0_g191 )).xxxx;
				float4 clampResult8_g191 = clamp( CalculateContrast(temp_output_44_0_g190,temp_cast_1) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_95_0_g190 = clampResult8_g191;
				float4 lerpResult60_g190 = lerp( tex2D( _GAlbedo, uv_GAlbedo ) , lerpResult62_g190 , temp_output_95_0_g190);
				float temp_output_9_0_g192 = IN.ase_color.b;
				float2 texCoord2_g192 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float simpleNoise3_g192 = SimpleNoise( texCoord2_g192*temp_output_53_0_g190 );
				float4 temp_cast_2 = (( ( temp_output_9_0_g192 + simpleNoise3_g192 ) * temp_output_9_0_g192 )).xxxx;
				float4 clampResult8_g192 = clamp( CalculateContrast(temp_output_44_0_g190,temp_cast_2) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_94_0_g190 = clampResult8_g192;
				float4 lerpResult58_g190 = lerp( tex2D( _BAlbedo, uv_BAlbedo ) , lerpResult60_g190 , temp_output_94_0_g190);
				#ifdef _USEVERTEXCOLOURS_ON
				float4 staticSwitch236 = lerpResult58_g190;
				#else
				float4 staticSwitch236 = albedo34;
				#endif
				float4 VertColoursColour201 = staticSwitch236;
				float2 temp_cast_3 = (_GeoNoise).xx;
				float2 texCoord27_g187 = IN.ase_texcoord3.xy * temp_cast_3 + float2( 0,0 );
				float simplePerlin3D31_g187 = snoise( ( ( WorldPosition * _NoiseSize ) * float3( texCoord27_g187 ,  0.0 ) ) );
				simplePerlin3D31_g187 = simplePerlin3D31_g187*0.5 + 0.5;
				float temp_output_41_0_g187 = ( ( 1.0 - _GeoScaling ) * ( WorldPosition.y + ( simplePerlin3D31_g187 * _GeoWarp ) ) );
				float2 temp_cast_5 = (temp_output_41_0_g187).xx;
				float4 blendOpSrc37_g187 = tex2D( _GeoGradientAlbedo, temp_cast_5 );
				float4 blendOpDest37_g187 = VertColoursColour201;
				float4 lerpBlendMode37_g187 = lerp(blendOpDest37_g187,(( blendOpDest37_g187 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest37_g187 ) * ( 1.0 - blendOpSrc37_g187 ) ) : ( 2.0 * blendOpDest37_g187 * blendOpSrc37_g187 ) ),_GeoLayerOpacity);
				#ifdef _USEROCKLAYERING_ON
				float4 staticSwitch238 = ( saturate( lerpBlendMode37_g187 ));
				#else
				float4 staticSwitch238 = VertColoursColour201;
				#endif
				float4 rocklayeralbedo225 = staticSwitch238;
				float2 temp_cast_7 = (_CoverageTiling).xx;
				float2 texCoord185 = IN.ase_texcoord3.xy * temp_cast_7 + float2( 0,0 );
				float2 uv_Normal = IN.ase_texcoord3.xy * _Normal_ST.xy + _Normal_ST.zw;
				float normalscale231 = _NormalScale;
				float3 unpack23 = UnpackNormalScale( tex2D( _Normal, uv_Normal ), normalscale231 );
				unpack23.z = lerp( 1, unpack23.z, saturate(normalscale231) );
				float3 tex2DNode23 = unpack23;
				float3 normal25 = tex2DNode23;
				float2 uv_BNormal = IN.ase_texcoord3.xy * _BNormal_ST.xy + _BNormal_ST.zw;
				float3 unpack217 = UnpackNormalScale( tex2D( _BNormal, uv_BNormal ), normalscale231 );
				unpack217.z = lerp( 1, unpack217.z, saturate(normalscale231) );
				float2 uv_GNormal = IN.ase_texcoord3.xy * _GNormal_ST.xy + _GNormal_ST.zw;
				float3 unpack203 = UnpackNormalScale( tex2D( _GNormal, uv_GNormal ), normalscale231 );
				unpack203.z = lerp( 1, unpack203.z, saturate(normalscale231) );
				float2 uv_RNormal = IN.ase_texcoord3.xy * _RNormal_ST.xy + _RNormal_ST.zw;
				float3 unpack197 = UnpackNormalScale( tex2D( _RNormal, uv_RNormal ), normalscale231 );
				unpack197.z = lerp( 1, unpack197.z, saturate(normalscale231) );
				float3 lerpResult51_g190 = lerp( unpack197 , normal25 , temp_output_96_0_g190.rgb);
				float3 lerpResult50_g190 = lerp( unpack203 , lerpResult51_g190 , temp_output_95_0_g190.rgb);
				float3 lerpResult52_g190 = lerp( unpack217 , lerpResult50_g190 , temp_output_94_0_g190.rgb);
				#ifdef _USEVERTEXCOLOURS_ON
				float3 staticSwitch237 = lerpResult52_g190;
				#else
				float3 staticSwitch237 = normal25;
				#endif
				float3 VertColoursNormal190 = staticSwitch237;
				float2 temp_cast_12 = (temp_output_41_0_g187).xx;
				float3 blendOpSrc47_g187 = UnpackNormalScale( tex2D( _GeoGradientNormal, temp_cast_12 ), 1.0f );
				float3 blendOpDest47_g187 = VertColoursNormal190;
				float3 lerpBlendMode47_g187 = lerp(blendOpDest47_g187,(( blendOpDest47_g187 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest47_g187 ) * ( 1.0 - blendOpSrc47_g187 ) ) : ( 2.0 * blendOpDest47_g187 * blendOpSrc47_g187 ) ),_GeoLayerOpacity);
				#ifdef _USEROCKLAYERING_ON
				float3 staticSwitch239 = ( saturate( lerpBlendMode47_g187 ));
				#else
				float3 staticSwitch239 = VertColoursNormal190;
				#endif
				float3 rocklayernormal235 = staticSwitch239;
				float3 temp_output_26_0_g194 = rocklayernormal235;
				float3 ase_worldTangent = IN.ase_texcoord4.xyz;
				float3 ase_worldNormal = IN.ase_texcoord5.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord6.xyz;
				float3x3 ase_worldToTangent = float3x3(ase_worldTangent,ase_worldBitangent,ase_worldNormal);
				float3x3 ase_tangentToWorldPrecise = Inverse3x3( ase_worldToTangent );
				float3 tangentToWorldPos8_g194 = mul( ase_tangentToWorldPrecise, temp_output_26_0_g194 );
				float temp_output_9_0_g194 = ( 1.0 - _CoverageAmount );
				float clampResult21_g194 = clamp( ( ( ( ( tangentToWorldPos8_g194.y + 0.1 ) - temp_output_9_0_g194 ) * 20.0 ) + temp_output_9_0_g194 ) , 0.0 , 1.0 );
				float temp_output_9_0_g195 = clampResult21_g194;
				float2 texCoord2_g195 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float simpleNoise3_g195 = SimpleNoise( texCoord2_g195*_CoverageNoiseScale );
				float4 temp_cast_13 = (( ( temp_output_9_0_g195 + simpleNoise3_g195 ) * temp_output_9_0_g195 )).xxxx;
				float4 clampResult8_g195 = clamp( CalculateContrast(_CoverageSpread,temp_cast_13) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_55_0_g194 = clampResult8_g195;
				float3 lerpResult22_g194 = lerp( rocklayeralbedo225.rgb , tex2D( _CoverageAlbedo, texCoord185 ).rgb , temp_output_55_0_g194.rgb);
				#ifdef _USETOPCOVERAGE_ON
				float4 staticSwitch240 = float4( lerpResult22_g194 , 0.0 );
				#else
				float4 staticSwitch240 = rocklayeralbedo225;
				#endif
				float4 TopCoverAlbedo215 = staticSwitch240;
				float temp_output_14_0_g186 = saturate( ( (( WorldPosition / ( _GradientScale * 2.0 ) )).y + 0.0 ) );
				#ifdef _INVERTGRADIENT_ON
				float staticSwitch18_g186 = ( 1.0 - temp_output_14_0_g186 );
				#else
				float staticSwitch18_g186 = temp_output_14_0_g186;
				#endif
				float4 lerpResult15_g186 = lerp( _GradientTone , TopCoverAlbedo215 , staticSwitch18_g186);
				#ifdef _USEWORLDGRADIENT_ON
				float4 staticSwitch245 = lerpResult15_g186;
				#else
				float4 staticSwitch245 = TopCoverAlbedo215;
				#endif
				float4 gradientAlbedo207 = staticSwitch245;
				float4 finalalbedo249 = gradientAlbedo207;
				Gradient gradient146 = NewGradient( 1, 5, 2, float4( 0.2, 0.2, 0.2, 0.2 ), float4( 0.4, 0.4, 0.4, 0.3499962 ), float4( 0.6, 0.6, 0.6, 0.5000076 ), float4( 0.8, 0.8, 0.8, 0.8 ), float4( 1, 1, 1, 1 ), 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float3 unpack228 = UnpackNormalScale( tex2D( _CoverageNormal, texCoord185 ), normalscale231 );
				unpack228.z = lerp( 1, unpack228.z, saturate(normalscale231) );
				float3 lerpResult23_g194 = lerp( temp_output_26_0_g194 , unpack228 , temp_output_55_0_g194.rgb);
				#ifdef _USETOPCOVERAGE_ON
				float3 staticSwitch241 = lerpResult23_g194;
				#else
				float3 staticSwitch241 = rocklayernormal235;
				#endif
				float3 TopCoverNormal199 = staticSwitch241;
				float3 finalnormal250 = TopCoverNormal199;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal6 = finalnormal250;
				float3 worldNormal6 = normalize( float3(dot(tanToWorld0,tanNormal6), dot(tanToWorld1,tanNormal6), dot(tanToWorld2,tanNormal6)) );
				float dotResult5 = dot( worldNormal6 , SafeNormalize(_MainLightPosition.xyz) );
				float normalLightDir11 = dotResult5;
				float temp_output_18_0 = (normalLightDir11*_ScaleandOffset + _ScaleandOffset);
				float2 temp_cast_20 = (temp_output_18_0).xx;
				#ifdef _USETOONRAMP_ON
				float4 staticSwitch147 = tex2D( _ToonRamp, temp_cast_20 );
				#else
				float4 staticSwitch147 = SampleGradient( gradient146, temp_output_18_0 );
				#endif
				Gradient gradient154 = NewGradient( 0, 8, 2, float4( 0.245283, 0.245283, 0.245283, 0 ), float4( 0.2, 0.2, 0.2, 0.0147097 ), float4( 0.2, 0.2, 0.2, 0.1176471 ), float4( 0.6, 0.6, 0.6, 0.3529412 ), float4( 0.4, 0.4, 0.4, 0.5794156 ), float4( 0.2209278, 0.2209278, 0.2209278, 0.7176471 ), float4( 0.2, 0.2, 0.2, 0.8323491 ), float4( 1, 1, 1, 1 ), float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 temp_cast_21 = (temp_output_18_0).xx;
				#ifdef _USESPECULARRAMP_ON
				float4 staticSwitch155 = tex2D( _SpecularRamp, temp_cast_21 );
				#else
				float4 staticSwitch155 = SampleGradient( gradient154, temp_output_18_0 );
				#endif
				float4 temp_cast_22 = (0.0).xxxx;
				float4 temp_cast_23 = (0.0).xxxx;
				float4 temp_cast_24 = (1.0).xxxx;
				float2 uv_Specular = IN.ase_texcoord3.xy * _Specular_ST.xy + _Specular_ST.zw;
				float4 tex2DNode109 = tex2D( _Specular, uv_Specular );
				float4 SpecularMap157 = tex2DNode109;
				#if defined(_MATERIALMODE_FLAT)
				float4 staticSwitch156 = temp_cast_22;
				#elif defined(_MATERIALMODE_METALLIC)
				float4 staticSwitch156 = temp_cast_24;
				#elif defined(_MATERIALMODE_SPECMAP)
				float4 staticSwitch156 = SpecularMap157;
				#else
				float4 staticSwitch156 = temp_cast_22;
				#endif
				float4 lerpResult159 = lerp( staticSwitch147 , staticSwitch155 , staticSwitch156);
				float grayscale160 = Luminance(lerpResult159.rgb);
				float4 temp_cast_26 = (grayscale160).xxxx;
				#ifdef _FORCEGRAYSCALE_ON
				float4 staticSwitch161 = temp_cast_26;
				#else
				float4 staticSwitch161 = lerpResult159;
				#endif
				float4 shadow17 = ( finalalbedo249 * ( ( staticSwitch161 + ( 1.0 - _RampBias ) ) * _RampScale ) );
				float3 WorldPosition5_g185 = WorldPosition;
				float3 WorldNormal5_g185 = finalnormal250;
				float3 localAdditionalLightsLambert5_g185 = AdditionalLightsLambert( WorldPosition5_g185 , WorldNormal5_g185 );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float4 temp_output_48_0 = ( ( _MainLightColor * _LightIntensity ) * float4( ( ( localAdditionalLightsLambert5_g185 * _AdditionalLightIntensity ) + ase_lightAtten ) , 0.0 ) );
				float4 ligthing41 = ( shadow17 * temp_output_48_0 );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = SafeNormalize( ase_worldViewDir );
				float3 tanNormal95 = finalnormal250;
				float3 worldNormal95 = normalize( float3(dot(tanToWorld0,tanNormal95), dot(tanToWorld1,tanNormal95), dot(tanToWorld2,tanNormal95)) );
				float dotResult97 = dot( ( ase_worldViewDir + _MainLightPosition.xyz ) , worldNormal95 );
				float saferPower98 = max( dotResult97 , 0.0001 );
				float smoothstepResult100 = smoothstep( 1.1 , 1.12 , pow( saferPower98 , _Gloss ));
				float4 lerpResult114 = lerp( _SpecularTint , _MainLightColor , _SpecTintBlend);
				float4 Spec107 = ( ( ( smoothstepResult100 * ( tex2DNode109 * lerpResult114 ) ) * _SpecInten ) * ase_lightAtten );
				float4 colour124 = ( ligthing41 + Spec107 );
				float4 temp_cast_28 = (0.0).xxxx;
				float3 tanNormal9 = finalnormal250;
				float3 worldNormal9 = normalize( float3(dot(tanToWorld0,tanNormal9), dot(tanToWorld1,tanNormal9), dot(tanToWorld2,tanNormal9)) );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float dotResult10 = dot( worldNormal9 , ase_worldViewDir );
				float normalViewDir12 = dotResult10;
				float saferPower75 = max( ( 1.0 - saturate( ( _RimOffset + normalViewDir12 ) ) ) , 0.0001 );
				float4 rimLight58 = ( saturate( ( pow( saferPower75 , _RimPower ) * ( normalLightDir11 * ase_lightAtten ) ) ) * ( _MainLightColor * _RimTint ) );
				#ifdef _USERIMLIGHT_ON
				float4 staticSwitch251 = rimLight58;
				#else
				float4 staticSwitch251 = temp_cast_28;
				#endif
				float4 extrasPassColour133 = ( colour124 + staticSwitch251 );
				float fresnelNdotV263 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode263 = ( ( 1.0 - _FresnelPower ) + 1.0 * pow( 1.0 - fresnelNdotV263, _FresnelPower ) );
				float4 temp_output_261_0 = ( ( finalalbedo249 * _EmissiveIntensity ) * fresnelNode263 );
				float2 uv_EmissiveMap = IN.ase_texcoord3.xy * _EmissiveMap_ST.xy + _EmissiveMap_ST.zw;
				float4 tex2DNode272 = tex2D( _EmissiveMap, uv_EmissiveMap );
				float4 lerpResult265 = lerp( extrasPassColour133 , temp_output_261_0 , tex2DNode272);
				#ifdef _USEEMISSION_ON
				float4 staticSwitch275 = lerpResult265;
				#else
				float4 staticSwitch275 = extrasPassColour133;
				#endif
				float4 extrafinal267 = staticSwitch275;
				
				float3 Color = extrafinal267.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_FOG
					Color = MixFog( Color, IN.fogFactor );
				#endif

				return half4( Color, Alpha );
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 100302

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma shader_feature_local _USEEMISSION_ON
			#pragma shader_feature_local _USEWORLDGRADIENT_ON
			#pragma shader_feature_local _USETOPCOVERAGE_ON
			#pragma shader_feature_local _USEROCKLAYERING_ON
			#pragma shader_feature_local _USEVERTEXCOLOURS_ON
			#pragma shader_feature_local _INVERTGRADIENT_ON
			#pragma shader_feature_local _FORCEGRAYSCALE_ON
			#pragma shader_feature_local _USETOONRAMP_ON
			#pragma shader_feature_local _USESPECULARRAMP_ON
			#pragma shader_feature_local _MATERIALMODE_FLAT _MATERIALMODE_METALLIC _MATERIALMODE_SPECMAP
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Tint;
			float4 _RimTint;
			float4 _SpecularTint;
			float4 _Specular_ST;
			float4 _GradientTone;
			float4 _RNormal_ST;
			float4 _GNormal_ST;
			float4 _BNormal_ST;
			float4 _Normal_ST;
			float4 _EmissiveMap_ST;
			float4 _GAlbedo_ST;
			float4 _Albedo_ST;
			float4 _BAlbedo_ST;
			float4 _RAlbedo_ST;
			float _EmissiveIntensity;
			float _RimPower;
			float _RimOffset;
			float _SpecInten;
			float _SpecTintBlend;
			float _Gloss;
			float _AdditionalLightIntensity;
			float _LightIntensity;
			float _RampScale;
			float _RampBias;
			float _GeoWarp;
			float _ScaleandOffset;
			float _GradientScale;
			float _CoverageNoiseScale;
			float _FresnelPower;
			float _NoiseSpread;
			float _NoiseScale;
			float _GeoScaling;
			float _NormalScale;
			float _NoiseSize;
			float _CoverageSpread;
			float _CoverageTiling;
			float _GeoLayerOpacity;
			float _GeoNoise;
			float _CoverageAmount;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Albedo;
			sampler2D _BAlbedo;
			sampler2D _GAlbedo;
			sampler2D _RAlbedo;
			sampler2D _GeoGradientAlbedo;
			sampler2D _CoverageAlbedo;
			sampler2D _Normal;
			sampler2D _BNormal;
			sampler2D _GNormal;
			sampler2D _RNormal;
			sampler2D _GeoGradientNormal;
			sampler2D _CoverageNormal;
			sampler2D _ToonRamp;
			sampler2D _SpecularRamp;
			sampler2D _Specular;
			sampler2D _EmissiveMap;


			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			
			float3x3 Inverse3x3(float3x3 input)
			{
				float3 a = input._11_21_31;
				float3 b = input._12_22_32;
				float3 c = input._13_23_33;
				return float3x3(cross(b,c), cross(c,a), cross(a,b)) * (1.0 / dot(a,cross(b,c)));
			}
			
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			
			float3 AdditionalLightsLambert( float3 WorldPosition, float3 WorldNormal )
			{
				float3 Color = 0;
				#ifdef _ADDITIONAL_LIGHTS
				int numLights = GetAdditionalLightsCount();
				for(int i = 0; i<numLights;i++)
				{
					Light light = GetAdditionalLight(i, WorldPosition);
					half3 AttLightColor = light.color *(light.distanceAttenuation * light.shadowAttenuation);
					Color +=LightingLambert(AttLightColor, light.direction, WorldNormal);
					
				}
				#endif
				return Color;
			}
			
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord4.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord5.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord6.xyz = ase_worldBitangent;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				#ifdef ASE_FOG
				o.fogFactor = ComputeFogFactor( positionCS.z );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif
				float2 uv_Albedo = IN.ase_texcoord3.xy * _Albedo_ST.xy + _Albedo_ST.zw;
				float4 albedo34 = ( _Tint * tex2D( _Albedo, uv_Albedo ) );
				float2 uv_BAlbedo = IN.ase_texcoord3.xy * _BAlbedo_ST.xy + _BAlbedo_ST.zw;
				float2 uv_GAlbedo = IN.ase_texcoord3.xy * _GAlbedo_ST.xy + _GAlbedo_ST.zw;
				float2 uv_RAlbedo = IN.ase_texcoord3.xy * _RAlbedo_ST.xy + _RAlbedo_ST.zw;
				float temp_output_44_0_g190 = _NoiseSpread;
				float temp_output_9_0_g193 = IN.ase_color.r;
				float2 texCoord2_g193 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_53_0_g190 = _NoiseScale;
				float simpleNoise3_g193 = SimpleNoise( texCoord2_g193*temp_output_53_0_g190 );
				float4 temp_cast_0 = (( ( temp_output_9_0_g193 + simpleNoise3_g193 ) * temp_output_9_0_g193 )).xxxx;
				float4 clampResult8_g193 = clamp( CalculateContrast(temp_output_44_0_g190,temp_cast_0) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_96_0_g190 = clampResult8_g193;
				float4 lerpResult62_g190 = lerp( tex2D( _RAlbedo, uv_RAlbedo ) , albedo34 , temp_output_96_0_g190);
				float temp_output_9_0_g191 = IN.ase_color.g;
				float2 texCoord2_g191 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float simpleNoise3_g191 = SimpleNoise( texCoord2_g191*temp_output_53_0_g190 );
				float4 temp_cast_1 = (( ( temp_output_9_0_g191 + simpleNoise3_g191 ) * temp_output_9_0_g191 )).xxxx;
				float4 clampResult8_g191 = clamp( CalculateContrast(temp_output_44_0_g190,temp_cast_1) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_95_0_g190 = clampResult8_g191;
				float4 lerpResult60_g190 = lerp( tex2D( _GAlbedo, uv_GAlbedo ) , lerpResult62_g190 , temp_output_95_0_g190);
				float temp_output_9_0_g192 = IN.ase_color.b;
				float2 texCoord2_g192 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float simpleNoise3_g192 = SimpleNoise( texCoord2_g192*temp_output_53_0_g190 );
				float4 temp_cast_2 = (( ( temp_output_9_0_g192 + simpleNoise3_g192 ) * temp_output_9_0_g192 )).xxxx;
				float4 clampResult8_g192 = clamp( CalculateContrast(temp_output_44_0_g190,temp_cast_2) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_94_0_g190 = clampResult8_g192;
				float4 lerpResult58_g190 = lerp( tex2D( _BAlbedo, uv_BAlbedo ) , lerpResult60_g190 , temp_output_94_0_g190);
				#ifdef _USEVERTEXCOLOURS_ON
				float4 staticSwitch236 = lerpResult58_g190;
				#else
				float4 staticSwitch236 = albedo34;
				#endif
				float4 VertColoursColour201 = staticSwitch236;
				float2 temp_cast_3 = (_GeoNoise).xx;
				float2 texCoord27_g187 = IN.ase_texcoord3.xy * temp_cast_3 + float2( 0,0 );
				float simplePerlin3D31_g187 = snoise( ( ( WorldPosition * _NoiseSize ) * float3( texCoord27_g187 ,  0.0 ) ) );
				simplePerlin3D31_g187 = simplePerlin3D31_g187*0.5 + 0.5;
				float temp_output_41_0_g187 = ( ( 1.0 - _GeoScaling ) * ( WorldPosition.y + ( simplePerlin3D31_g187 * _GeoWarp ) ) );
				float2 temp_cast_5 = (temp_output_41_0_g187).xx;
				float4 blendOpSrc37_g187 = tex2D( _GeoGradientAlbedo, temp_cast_5 );
				float4 blendOpDest37_g187 = VertColoursColour201;
				float4 lerpBlendMode37_g187 = lerp(blendOpDest37_g187,(( blendOpDest37_g187 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest37_g187 ) * ( 1.0 - blendOpSrc37_g187 ) ) : ( 2.0 * blendOpDest37_g187 * blendOpSrc37_g187 ) ),_GeoLayerOpacity);
				#ifdef _USEROCKLAYERING_ON
				float4 staticSwitch238 = ( saturate( lerpBlendMode37_g187 ));
				#else
				float4 staticSwitch238 = VertColoursColour201;
				#endif
				float4 rocklayeralbedo225 = staticSwitch238;
				float2 temp_cast_7 = (_CoverageTiling).xx;
				float2 texCoord185 = IN.ase_texcoord3.xy * temp_cast_7 + float2( 0,0 );
				float2 uv_Normal = IN.ase_texcoord3.xy * _Normal_ST.xy + _Normal_ST.zw;
				float normalscale231 = _NormalScale;
				float3 unpack23 = UnpackNormalScale( tex2D( _Normal, uv_Normal ), normalscale231 );
				unpack23.z = lerp( 1, unpack23.z, saturate(normalscale231) );
				float3 tex2DNode23 = unpack23;
				float3 normal25 = tex2DNode23;
				float2 uv_BNormal = IN.ase_texcoord3.xy * _BNormal_ST.xy + _BNormal_ST.zw;
				float3 unpack217 = UnpackNormalScale( tex2D( _BNormal, uv_BNormal ), normalscale231 );
				unpack217.z = lerp( 1, unpack217.z, saturate(normalscale231) );
				float2 uv_GNormal = IN.ase_texcoord3.xy * _GNormal_ST.xy + _GNormal_ST.zw;
				float3 unpack203 = UnpackNormalScale( tex2D( _GNormal, uv_GNormal ), normalscale231 );
				unpack203.z = lerp( 1, unpack203.z, saturate(normalscale231) );
				float2 uv_RNormal = IN.ase_texcoord3.xy * _RNormal_ST.xy + _RNormal_ST.zw;
				float3 unpack197 = UnpackNormalScale( tex2D( _RNormal, uv_RNormal ), normalscale231 );
				unpack197.z = lerp( 1, unpack197.z, saturate(normalscale231) );
				float3 lerpResult51_g190 = lerp( unpack197 , normal25 , temp_output_96_0_g190.rgb);
				float3 lerpResult50_g190 = lerp( unpack203 , lerpResult51_g190 , temp_output_95_0_g190.rgb);
				float3 lerpResult52_g190 = lerp( unpack217 , lerpResult50_g190 , temp_output_94_0_g190.rgb);
				#ifdef _USEVERTEXCOLOURS_ON
				float3 staticSwitch237 = lerpResult52_g190;
				#else
				float3 staticSwitch237 = normal25;
				#endif
				float3 VertColoursNormal190 = staticSwitch237;
				float2 temp_cast_12 = (temp_output_41_0_g187).xx;
				float3 blendOpSrc47_g187 = UnpackNormalScale( tex2D( _GeoGradientNormal, temp_cast_12 ), 1.0f );
				float3 blendOpDest47_g187 = VertColoursNormal190;
				float3 lerpBlendMode47_g187 = lerp(blendOpDest47_g187,(( blendOpDest47_g187 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest47_g187 ) * ( 1.0 - blendOpSrc47_g187 ) ) : ( 2.0 * blendOpDest47_g187 * blendOpSrc47_g187 ) ),_GeoLayerOpacity);
				#ifdef _USEROCKLAYERING_ON
				float3 staticSwitch239 = ( saturate( lerpBlendMode47_g187 ));
				#else
				float3 staticSwitch239 = VertColoursNormal190;
				#endif
				float3 rocklayernormal235 = staticSwitch239;
				float3 temp_output_26_0_g194 = rocklayernormal235;
				float3 ase_worldTangent = IN.ase_texcoord4.xyz;
				float3 ase_worldNormal = IN.ase_texcoord5.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord6.xyz;
				float3x3 ase_worldToTangent = float3x3(ase_worldTangent,ase_worldBitangent,ase_worldNormal);
				float3x3 ase_tangentToWorldPrecise = Inverse3x3( ase_worldToTangent );
				float3 tangentToWorldPos8_g194 = mul( ase_tangentToWorldPrecise, temp_output_26_0_g194 );
				float temp_output_9_0_g194 = ( 1.0 - _CoverageAmount );
				float clampResult21_g194 = clamp( ( ( ( ( tangentToWorldPos8_g194.y + 0.1 ) - temp_output_9_0_g194 ) * 20.0 ) + temp_output_9_0_g194 ) , 0.0 , 1.0 );
				float temp_output_9_0_g195 = clampResult21_g194;
				float2 texCoord2_g195 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float simpleNoise3_g195 = SimpleNoise( texCoord2_g195*_CoverageNoiseScale );
				float4 temp_cast_13 = (( ( temp_output_9_0_g195 + simpleNoise3_g195 ) * temp_output_9_0_g195 )).xxxx;
				float4 clampResult8_g195 = clamp( CalculateContrast(_CoverageSpread,temp_cast_13) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_55_0_g194 = clampResult8_g195;
				float3 lerpResult22_g194 = lerp( rocklayeralbedo225.rgb , tex2D( _CoverageAlbedo, texCoord185 ).rgb , temp_output_55_0_g194.rgb);
				#ifdef _USETOPCOVERAGE_ON
				float4 staticSwitch240 = float4( lerpResult22_g194 , 0.0 );
				#else
				float4 staticSwitch240 = rocklayeralbedo225;
				#endif
				float4 TopCoverAlbedo215 = staticSwitch240;
				float temp_output_14_0_g186 = saturate( ( (( WorldPosition / ( _GradientScale * 2.0 ) )).y + 0.0 ) );
				#ifdef _INVERTGRADIENT_ON
				float staticSwitch18_g186 = ( 1.0 - temp_output_14_0_g186 );
				#else
				float staticSwitch18_g186 = temp_output_14_0_g186;
				#endif
				float4 lerpResult15_g186 = lerp( _GradientTone , TopCoverAlbedo215 , staticSwitch18_g186);
				#ifdef _USEWORLDGRADIENT_ON
				float4 staticSwitch245 = lerpResult15_g186;
				#else
				float4 staticSwitch245 = TopCoverAlbedo215;
				#endif
				float4 gradientAlbedo207 = staticSwitch245;
				float4 finalalbedo249 = gradientAlbedo207;
				Gradient gradient146 = NewGradient( 1, 5, 2, float4( 0.2, 0.2, 0.2, 0.2 ), float4( 0.4, 0.4, 0.4, 0.3499962 ), float4( 0.6, 0.6, 0.6, 0.5000076 ), float4( 0.8, 0.8, 0.8, 0.8 ), float4( 1, 1, 1, 1 ), 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float3 unpack228 = UnpackNormalScale( tex2D( _CoverageNormal, texCoord185 ), normalscale231 );
				unpack228.z = lerp( 1, unpack228.z, saturate(normalscale231) );
				float3 lerpResult23_g194 = lerp( temp_output_26_0_g194 , unpack228 , temp_output_55_0_g194.rgb);
				#ifdef _USETOPCOVERAGE_ON
				float3 staticSwitch241 = lerpResult23_g194;
				#else
				float3 staticSwitch241 = rocklayernormal235;
				#endif
				float3 TopCoverNormal199 = staticSwitch241;
				float3 finalnormal250 = TopCoverNormal199;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal6 = finalnormal250;
				float3 worldNormal6 = normalize( float3(dot(tanToWorld0,tanNormal6), dot(tanToWorld1,tanNormal6), dot(tanToWorld2,tanNormal6)) );
				float dotResult5 = dot( worldNormal6 , SafeNormalize(_MainLightPosition.xyz) );
				float normalLightDir11 = dotResult5;
				float temp_output_18_0 = (normalLightDir11*_ScaleandOffset + _ScaleandOffset);
				float2 temp_cast_20 = (temp_output_18_0).xx;
				#ifdef _USETOONRAMP_ON
				float4 staticSwitch147 = tex2D( _ToonRamp, temp_cast_20 );
				#else
				float4 staticSwitch147 = SampleGradient( gradient146, temp_output_18_0 );
				#endif
				Gradient gradient154 = NewGradient( 0, 8, 2, float4( 0.245283, 0.245283, 0.245283, 0 ), float4( 0.2, 0.2, 0.2, 0.0147097 ), float4( 0.2, 0.2, 0.2, 0.1176471 ), float4( 0.6, 0.6, 0.6, 0.3529412 ), float4( 0.4, 0.4, 0.4, 0.5794156 ), float4( 0.2209278, 0.2209278, 0.2209278, 0.7176471 ), float4( 0.2, 0.2, 0.2, 0.8323491 ), float4( 1, 1, 1, 1 ), float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 temp_cast_21 = (temp_output_18_0).xx;
				#ifdef _USESPECULARRAMP_ON
				float4 staticSwitch155 = tex2D( _SpecularRamp, temp_cast_21 );
				#else
				float4 staticSwitch155 = SampleGradient( gradient154, temp_output_18_0 );
				#endif
				float4 temp_cast_22 = (0.0).xxxx;
				float4 temp_cast_23 = (0.0).xxxx;
				float4 temp_cast_24 = (1.0).xxxx;
				float2 uv_Specular = IN.ase_texcoord3.xy * _Specular_ST.xy + _Specular_ST.zw;
				float4 tex2DNode109 = tex2D( _Specular, uv_Specular );
				float4 SpecularMap157 = tex2DNode109;
				#if defined(_MATERIALMODE_FLAT)
				float4 staticSwitch156 = temp_cast_22;
				#elif defined(_MATERIALMODE_METALLIC)
				float4 staticSwitch156 = temp_cast_24;
				#elif defined(_MATERIALMODE_SPECMAP)
				float4 staticSwitch156 = SpecularMap157;
				#else
				float4 staticSwitch156 = temp_cast_22;
				#endif
				float4 lerpResult159 = lerp( staticSwitch147 , staticSwitch155 , staticSwitch156);
				float grayscale160 = Luminance(lerpResult159.rgb);
				float4 temp_cast_26 = (grayscale160).xxxx;
				#ifdef _FORCEGRAYSCALE_ON
				float4 staticSwitch161 = temp_cast_26;
				#else
				float4 staticSwitch161 = lerpResult159;
				#endif
				float4 shadow17 = ( finalalbedo249 * ( ( staticSwitch161 + ( 1.0 - _RampBias ) ) * _RampScale ) );
				float3 WorldPosition5_g185 = WorldPosition;
				float3 WorldNormal5_g185 = finalnormal250;
				float3 localAdditionalLightsLambert5_g185 = AdditionalLightsLambert( WorldPosition5_g185 , WorldNormal5_g185 );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float4 temp_output_48_0 = ( ( _MainLightColor * _LightIntensity ) * float4( ( ( localAdditionalLightsLambert5_g185 * _AdditionalLightIntensity ) + ase_lightAtten ) , 0.0 ) );
				float4 ligthing41 = ( shadow17 * temp_output_48_0 );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = SafeNormalize( ase_worldViewDir );
				float3 tanNormal95 = finalnormal250;
				float3 worldNormal95 = normalize( float3(dot(tanToWorld0,tanNormal95), dot(tanToWorld1,tanNormal95), dot(tanToWorld2,tanNormal95)) );
				float dotResult97 = dot( ( ase_worldViewDir + _MainLightPosition.xyz ) , worldNormal95 );
				float saferPower98 = max( dotResult97 , 0.0001 );
				float smoothstepResult100 = smoothstep( 1.1 , 1.12 , pow( saferPower98 , _Gloss ));
				float4 lerpResult114 = lerp( _SpecularTint , _MainLightColor , _SpecTintBlend);
				float4 Spec107 = ( ( ( smoothstepResult100 * ( tex2DNode109 * lerpResult114 ) ) * _SpecInten ) * ase_lightAtten );
				float4 colour124 = ( ligthing41 + Spec107 );
				float4 basePassColour129 = colour124;
				ase_worldViewDir = normalize(ase_worldViewDir);
				float fresnelNdotV263 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode263 = ( ( 1.0 - _FresnelPower ) + 1.0 * pow( 1.0 - fresnelNdotV263, _FresnelPower ) );
				float4 temp_output_261_0 = ( ( finalalbedo249 * _EmissiveIntensity ) * fresnelNode263 );
				float2 uv_EmissiveMap = IN.ase_texcoord3.xy * _EmissiveMap_ST.xy + _EmissiveMap_ST.zw;
				float4 tex2DNode272 = tex2D( _EmissiveMap, uv_EmissiveMap );
				float4 lerpResult273 = lerp( basePassColour129 , temp_output_261_0 , tex2DNode272);
				#ifdef _USEEMISSION_ON
				float4 staticSwitch274 = lerpResult273;
				#else
				float4 staticSwitch274 = basePassColour129;
				#endif
				float4 basefinal262 = staticSwitch274;
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = basefinal262.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_FOG
					Color = MixFog( Color, IN.fogFactor );
				#endif

				return half4( Color, Alpha );
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 100302

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Tint;
			float4 _RimTint;
			float4 _SpecularTint;
			float4 _Specular_ST;
			float4 _GradientTone;
			float4 _RNormal_ST;
			float4 _GNormal_ST;
			float4 _BNormal_ST;
			float4 _Normal_ST;
			float4 _EmissiveMap_ST;
			float4 _GAlbedo_ST;
			float4 _Albedo_ST;
			float4 _BAlbedo_ST;
			float4 _RAlbedo_ST;
			float _EmissiveIntensity;
			float _RimPower;
			float _RimOffset;
			float _SpecInten;
			float _SpecTintBlend;
			float _Gloss;
			float _AdditionalLightIntensity;
			float _LightIntensity;
			float _RampScale;
			float _RampBias;
			float _GeoWarp;
			float _ScaleandOffset;
			float _GradientScale;
			float _CoverageNoiseScale;
			float _FresnelPower;
			float _NoiseSpread;
			float _NoiseScale;
			float _GeoScaling;
			float _NormalScale;
			float _NoiseSize;
			float _CoverageSpread;
			float _CoverageTiling;
			float _GeoLayerOpacity;
			float _GeoNoise;
			float _CoverageAmount;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir( v.ase_normal );

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = clipPos;

				return o;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 100302

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Tint;
			float4 _RimTint;
			float4 _SpecularTint;
			float4 _Specular_ST;
			float4 _GradientTone;
			float4 _RNormal_ST;
			float4 _GNormal_ST;
			float4 _BNormal_ST;
			float4 _Normal_ST;
			float4 _EmissiveMap_ST;
			float4 _GAlbedo_ST;
			float4 _Albedo_ST;
			float4 _BAlbedo_ST;
			float4 _RAlbedo_ST;
			float _EmissiveIntensity;
			float _RimPower;
			float _RimOffset;
			float _SpecInten;
			float _SpecTintBlend;
			float _Gloss;
			float _AdditionalLightIntensity;
			float _LightIntensity;
			float _RampScale;
			float _RampBias;
			float _GeoWarp;
			float _ScaleandOffset;
			float _GradientScale;
			float _CoverageNoiseScale;
			float _FresnelPower;
			float _NoiseSpread;
			float _NoiseScale;
			float _GeoScaling;
			float _NormalScale;
			float _NoiseSize;
			float _CoverageSpread;
			float _CoverageTiling;
			float _GeoLayerOpacity;
			float _GeoNoise;
			float _CoverageAmount;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = TransformWorldToHClip( positionWS );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

	
	}
	CustomEditor "OutlierShadesGUIMaster"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18900
200.8;73.6;2247.6;1342.2;5197.469;3001.615;3.706245;True;False
Node;AmplifyShaderEditor.CommentaryNode;168;-3520.261,-5941.738;Inherit;False;2172.435;4166.021;Comment;13;207;245;221;206;177;173;172;170;171;246;247;249;250;Features;0.6792453,0.2012104,0.2012104,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;14;-2984.615,46.22726;Inherit;False;789.8;391.5998;Comment;4;8;10;9;12;Normal View Direction;1,0.8461648,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;259;-3837.45,6133.329;Inherit;False;2271.816;764.7842;Comment;16;275;274;273;272;271;270;269;268;267;266;265;264;263;262;261;260;Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;132;-571.4774,872.5413;Inherit;False;1246.425;449.4248;Comment;6;131;133;57;252;251;56;Colour + Rim Light = Extra Pass Final Colour;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;29;-4208.581,1945.269;Inherit;False;4178.516;1447.517;Comment;26;148;144;156;17;158;160;147;37;159;36;16;146;154;18;155;161;15;163;162;149;19;254;255;256;257;258;Shadows;0.490566,0.490566,0.490566,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;35;-2990.13,-1310.052;Inherit;False;923.8;484.5552;Comment;4;32;33;31;34;Albedo;0,0.8734226,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-3567.477,847.933;Inherit;False;1901.173;748.2403;Comment;14;39;166;167;47;164;165;48;40;38;59;46;51;41;45;Lighting;0.9750406,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;171;-3279.554,-4791.993;Inherit;False;1637.01;506.063;Comment;6;239;238;225;235;234;195;Rock layering;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;135;-486.7379,564.526;Inherit;False;917.2329;245.0294;Comment;2;123;129;Colour + Outline Dimming = Base Pass Final Colour;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;172;-3313.617,-4243.288;Inherit;False;1759.281;1436.738;Comment;15;201;190;186;175;229;223;217;214;209;203;200;197;183;237;236;Vertex Colours;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;126;-458.1025,243.153;Inherit;False;735.7894;257.8125;Comment;4;124;111;42;108;Spec + Lighting = Colour;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;87;-3699.013,4027.864;Inherit;False;2122.391;602.8799;Comment;17;71;76;72;73;74;78;79;80;77;82;83;84;85;75;86;58;69;Rim Lighting;0.5283019,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;26;-3501.39,3561.785;Inherit;False;1628.8;418;Comment;7;23;64;25;24;63;231;232;Normals;0.3568441,0.4018087,0.9339623,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;117;-3837.331,4719.628;Inherit;False;2438.868;1250.917;Comment;22;104;116;92;93;97;109;96;98;95;94;105;106;100;103;107;99;112;113;115;114;110;157;Specular;0,0.03687976,0.5188679,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;170;-3257.618,-5574.906;Inherit;False;1600.346;757.0337;Comment;13;241;240;194;196;228;224;215;212;199;192;244;243;242;Top Coverage;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-3001.744,-587.569;Inherit;False;801.3999;381.6;Comment;4;5;11;6;7;Normal Light;1,0.8470588,0,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;9;-2932.185,96.2273;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;97;-3248.331,4970.359;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-2342.031,5000.151;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-2870.571,1233.049;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-2167.577,4331.923;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-997.3425,2650.61;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-2733.502,4296.817;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;80;-3257.395,4424.142;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-3258.59,4334.317;Inherit;False;11;normalLightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-2398.723,1366.897;Inherit;False;rimLightAtten;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;45;-3334.28,1283.892;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-2446.743,-443.5688;Inherit;False;normalLightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-387.8753,642.1555;Inherit;False;124;colour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;156;-2607.783,2632.054;Inherit;False;Property;_MaterialMode;Material Mode;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;3;Flat;Metallic;SpecMap;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;18;-3843.383,2778.092;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-2579.981,5239.849;Inherit;False;Property;_SpecInten;Spec Inten;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;10;-2635.614,252.2273;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;39;-3059.914,919.3137;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightColorNode;83;-2379.553,4294.796;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;69;-3633.577,4077.863;Inherit;False;Property;_RimOffset;Rim Offset;34;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;255;-1754.048,2812.26;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;72;-3255.485,4086.819;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;73;-3075.03,4080.396;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;82;-2320.87,4151.085;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-1643.263,5014.053;Inherit;False;Spec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;161;-1950.629,2598.761;Inherit;False;Property;_ForceGrayscale;Force Grayscale;40;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;95;-3503.331,5046.359;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;238;-2633.358,-4623.247;Inherit;False;Property;_UseRockLayering;Use Rock Layering?;50;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;32;-2940.13,-1055.497;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;164;-3395.254,1190.258;Inherit;False;Property;_AdditionalLightIntensity;Additional Light Intensity;42;0;Create;True;0;0;0;False;0;False;3;4;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-3513.499,4875.86;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-3787.331,5126.358;Inherit;False;250;finalnormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;63;-2637.429,3736.463;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;74;-3133.653,4206.896;Inherit;False;Property;_RimPower;Rim Power;36;0;Create;True;0;0;0;False;0;False;0.6361759;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-2738.739,1055.515;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;263;-3351.562,6509.393;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;7;-2951.744,-386.5688;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-3083.93,1121.32;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;203;-3263.617,-3425.092;Inherit;True;Property;_GNormal;G Normal;45;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;8;-2902.615,252.2273;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;108;-408.1024,293.1528;Inherit;False;107;Spec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;240;-2363.662,-5236.346;Inherit;False;Property;_UseTopCoverage;Use Top Coverage?;51;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;250;-1816.581,-2073.492;Inherit;False;finalnormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;113;-3356.522,5724.254;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;251;-198.3235,1057.883;Inherit;False;Property;_UseRimLight;Use Rim Light;49;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-391.3441,1123.884;Inherit;False;Constant;_Float2;Float 2;43;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;-1461.452,2945.742;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;92;-3734.788,4769.628;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GradientNode;146;-3462.156,3030.315;Inherit;False;1;5;2;0.2,0.2,0.2,0.2;0.4,0.4,0.4,0.3499962;0.6,0.6,0.6,0.5000076;0.8,0.8,0.8,0.8;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.OneMinusNode;266;-3510.144,6528.97;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;270;-3564.012,6405.47;Inherit;False;Property;_EmissiveIntensity;Emissive Intensity;31;0;Create;True;0;0;0;False;0;False;1;1;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-3011.075,6423.329;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;265;-2417.77,6637.359;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;267;-1807.237,6507.506;Inherit;False;extrafinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;249;-1825.581,-2162.492;Inherit;False;finalalbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;260;-3522.75,6313.921;Inherit;False;249;finalalbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;268;-3058.088,6185.457;Inherit;False;129;basePassColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;272;-3055.976,6668.113;Inherit;True;Property;_EmissiveMap;Emissive Map;25;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;271;-3749.45,6601.358;Inherit;False;Property;_FresnelPower;Fresnel Power;33;0;Create;True;0;0;0;False;0;False;1;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;273;-2744.587,6307.452;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;262;-2055.345,6192.43;Inherit;False;basefinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;269;-3177.756,6363.763;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;75;-2771.539,4109.45;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;274;-2446.458,6183.329;Inherit;False;Property;_UseEmission;Use Emission?;30;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;144;-3256.475,2967.534;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-2599.417,4995.961;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-3310.331,5102.359;Inherit;False;Property;_Gloss;Gloss;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;94;-3781.813,4952.37;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-799.0086,2649.983;Inherit;False;shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1812.262,4997.153;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-3649.013,4184.616;Inherit;False;12;normalViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;148;-3268.392,2412.725;Inherit;True;Property;_SpecularRamp;Specular Ramp;26;0;Create;True;0;0;0;False;0;False;-1;bdf685e2a68dd4d4d83df0269e6da878;bdf685e2a68dd4d4d83df0269e6da878;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2247.35,1135.342;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientNode;154;-3564.028,2181.939;Inherit;False;0;8;2;0.245283,0.245283,0.245283,0;0.2,0.2,0.2,0.0147097;0.2,0.2,0.2,0.1176471;0.6,0.6,0.6,0.3529412;0.4,0.4,0.4,0.5794156;0.2209278,0.2209278,0.2209278,0.7176471;0.2,0.2,0.2,0.8323491;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;231;-3123.989,3857.172;Inherit;False;normalscale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-3409.57,5855.146;Inherit;False;Property;_SpecTintBlend;Spec Tint Blend;22;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-1261.138,2707.537;Inherit;False;249;finalalbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;52.2652,639.2413;Inherit;False;basePassColour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;114;-3092.57,5643.146;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;5;-2606.743,-462.5688;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-2826.9,2725.04;Inherit;False;157;SpecularMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;159;-2357.374,2602.018;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;98;-3034.331,4979.359;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-9.864037,319.6858;Inherit;False;colour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;258;-2023.806,3011.231;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;264;-2627.834,6507.44;Inherit;False;133;extrasPassColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;155;-2896.9,2356.68;Inherit;False;Property;_UseSpecularRamp;Use Specular Ramp?;24;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-192.1741,310.1342;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-3381.19,4081.693;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-2263.894,-2405.939;Inherit;False;gradientAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-3107.739,1050.515;Inherit;False;Property;_LightIntensity;Light Intensity;44;0;Create;True;0;0;0;False;0;False;3;4;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-2439.614,252.2273;Inherit;False;normalViewDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;192;-3193.3,-5455.124;Inherit;True;Property;_CoverageAlbedo;Coverage Albedo;38;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;175;-3230.385,-4173.288;Inherit;False;34;albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;84;-2437.039,4421.744;Inherit;False;Property;_RimTint;RimTint;29;0;Create;True;0;0;0;False;0;False;0.6226415,0.6226415,0.6226415,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-4127.954,2816.346;Inherit;False;Property;_ScaleandOffset;Scale and Offset;28;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-2357.421,3753.658;Inherit;False;worldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GradientSampleNode;149;-3274.183,2216.344;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;109;-3189.138,5347.381;Inherit;True;Property;_Specular;Specular;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;31;-2893.791,-1260.052;Inherit;False;Property;_Tint;Tint;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1821.425,4142.607;Inherit;False;rimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-1999.911,4165.454;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-3450.39,3849.239;Inherit;False;Property;_NormalScale;Normal Scale;4;0;Create;True;0;0;0;False;0;False;0.4098032;0.4098032;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-2522.591,1045.886;Inherit;False;17;shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;51;-3347.562,1112.406;Inherit;False;SRP Additional Light;-1;;185;6c86746ad131a0a408ca599df5f40861;3,6,1,9,1,23,0;5;2;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;15;FLOAT3;0,0,0;False;14;FLOAT3;1,1,1;False;18;FLOAT;0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;206;-2915.636,-2334.846;Inherit;False;WorldGradient;12;;186;e75923dfd63ec8845af54cf5ce215d1e;0;3;20;FLOAT4;0,0,0,0;False;17;FLOAT4;0,0,0,0;False;8;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;81.70349,934.4577;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;106;-2004.664,5144.055;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-2782.236,2623.86;Inherit;False;Constant;_Float1;Float 1;24;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-2530.13,-1142.497;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-3522.495,1106.491;Inherit;False;250;finalnormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-2842.57,5448.146;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-2041.774,1144.798;Inherit;False;ligthing;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-1803.054,3173.193;Inherit;False;Property;_RampScale;Ramp Scale;41;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;-2328.606,2997.676;Inherit;False;Property;_RampBias;Ramp Bias;39;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-406.4774,922.5412;Inherit;False;124;colour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;217;-3256.478,-3017.089;Inherit;True;Property;_BNormal;B Normal;46;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;353.7652,1012.002;Inherit;False;extrasPassColour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-4119.624,-3715.659;Inherit;False;231;normalscale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-2341.632,3624.4;Inherit;False;normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;253;-2903.815,-4513.25;Inherit;False;RockLayering;14;;187;04e7766a86dcb174389bbc903249ebfa;0;2;38;COLOR;0,0,0,0;False;48;FLOAT3;0,0,0;False;2;COLOR;0;FLOAT3;49
Node;AmplifyShaderEditor.GetLocalVarNode;234;-3195.269,-4479.211;Inherit;False;190;VertColoursNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;241;-2359.099,-5129.998;Inherit;False;Property;_UseTopCoverage;Use Top Coverage;51;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;240;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;157;-2860.19,5348.763;Inherit;False;SpecularMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-3296.125,-485.28;Inherit;False;250;finalnormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;200;-3255.595,-3212.71;Inherit;True;Property;_BAlbedo;B Albedo;37;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;228;-3202.251,-5167.174;Inherit;True;Property;_CoverageNormal;Coverage Normal;47;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;195;-3190.053,-4556.55;Inherit;False;201;VertColoursColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-2311.13,-1141.497;Inherit;False;albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;147;-2897.585,2871.976;Inherit;False;Property;_UseToonRamp;Use Toon Ramp?;23;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;100;-2849.331,4994.359;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1.1;False;2;FLOAT;1.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;-3207.619,-5252.899;Inherit;False;235;rocklayernormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;112;-3396.903,5543.86;Inherit;False;Property;_SpecularTint;Specular Tint;7;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;232;-3316.989,3686.172;Inherit;False;231;normalscale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-399.0409,1000.834;Inherit;False;58;rimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;186;-3225.126,-4100.52;Inherit;False;25;normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;23;-3038.732,3611.784;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;235;-2118.269,-4505.211;Inherit;False;rocklayernormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-4113.513,-5260.77;Inherit;False;Property;_CoverageTiling;Coverage Tiling;57;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;225;-2125.404,-4578.993;Inherit;False;rocklayeralbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;-1977.939,-5138.533;Inherit;False;TopCoverNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;223;-3261.4,-3994.797;Inherit;True;Property;_RAlbedo;R Albedo;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;42;-392.1834,403.9014;Inherit;False;41;ligthing;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;244;-2431.099,-5253.998;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;221;-3167.024,-2417.063;Inherit;False;215;TopCoverAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;15;-3250.684,2754.077;Inherit;True;Property;_ToonRamp;Toon Ramp;27;0;Create;True;0;0;0;False;0;False;-1;bdf685e2a68dd4d4d83df0269e6da878;bdf685e2a68dd4d4d83df0269e6da878;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;185;-3885.192,-5284.166;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;16;-4135.7,2744.173;Inherit;False;11;normalLightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;916.8428,157.7881;Inherit;False;262;basefinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;197;-3268.281,-3816.12;Inherit;True;Property;_RNormal;R Normal;43;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;177;-3211.933,-2149.273;Inherit;False;Property;_GradientScale;Gradient Scale;56;0;Create;True;0;0;0;False;0;False;20;0.5;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;247;-2203.56,-2158.727;Inherit;False;207;gradientAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;229;-3262.737,-3618.764;Inherit;True;Property;_GAlbedo;G Albedo;35;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;275;-2137.958,6505.918;Inherit;False;Property;_UseEmission;Use Emission?;30;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;274;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-2778.236,2541.86;Inherit;False;Constant;_Float0;Float 0;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;239;-2640.358,-4416.247;Inherit;False;Property;_UseRockLayering;Use Rock Layering?;50;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;238;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-3353.826,137.4201;Inherit;False;250;finalnormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;209;-2829.348,-3856.62;Inherit;False;Property;_NoiseSpread;Noise Spread;53;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;237;-2229.837,-4020.175;Inherit;False;Property;_UseVertexColours;Use Vertex Colours;48;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;236;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;243;-2843.099,-5476.998;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;236;-2222.258,-4138.854;Inherit;False;Property;_UseVertexColours;Use Vertex Colours?;48;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-3184.68,-5537.907;Inherit;False;225;rocklayeralbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;173;-3170.389,-2328.727;Inherit;False;Property;_GradientTone;Gradient Tone;58;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-1877.261,-4002.476;Inherit;False;VertColoursNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;246;-2208.56,-2073.727;Inherit;False;199;TopCoverNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCGrayscale;160;-2172.396,2672.644;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;6;-2934.743,-535.8904;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2534.421,4130.055;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;215;-1974.677,-5208.784;Inherit;False;TopCoverAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;183;-2693.222,-3484.15;Inherit;False;VertexColour;-1;;190;f9e293a8bd0ea15498bf4c92f8b32f08;0;10;44;FLOAT;2;False;53;FLOAT;100;False;41;COLOR;0,0,0,0;False;45;FLOAT3;0,0,0;False;42;COLOR;0,0,0,0;False;65;FLOAT3;0,0,0;False;48;COLOR;0,0,0,0;False;54;FLOAT3;0,0,0;False;47;COLOR;0,0,0,0;False;63;FLOAT3;0,0,0;False;2;COLOR;67;FLOAT3;68
Node;AmplifyShaderEditor.StaticSwitch;245;-2586.648,-2416.598;Inherit;False;Property;_UseWorldGradient;Use World Gradient?;52;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;970.6016,926.0018;Inherit;False;267;extrafinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-2573.912,1162.486;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;242;-2814.099,-5079.998;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;201;-1879.261,-4121.476;Inherit;False;VertColoursColour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;224;-2790.1,-5270.86;Inherit;False;SimpleTopCoverage;9;;194;bd8d39af5f14ca24dadd07cf86e30a0f;0;5;2;FLOAT3;0,0,0;False;25;FLOAT3;0,0,0;False;26;FLOAT3;0,0,0;False;27;FLOAT3;0,0,0;False;42;FLOAT;0;False;2;FLOAT3;0;FLOAT3;1
Node;AmplifyShaderEditor.RangedFloatNode;214;-2826.348,-3774.62;Inherit;False;Property;_NoiseScale;Noise Scale;54;0;Create;True;0;0;0;False;0;False;100;0;0;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-3164.243,-4962.272;Inherit;False;Property;_CoverageAmount;Coverage Amount;55;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;1242.483,167.4846;Float;False;True;-1;2;OutlierShadesGUIMaster;0;3;OutlierShades/ToonieV2 Master Opaque;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;1;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;0;False;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;1;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;True;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1232.636,923.7521;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;False;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;9;0;28;0
WireConnection;97;0;93;0
WireConnection;97;1;95;0
WireConnection;103;0;110;0
WireConnection;103;1;104;0
WireConnection;47;0;165;0
WireConnection;47;1;45;0
WireConnection;85;0;83;0
WireConnection;85;1;84;0
WireConnection;36;0;37;0
WireConnection;36;1;257;0
WireConnection;76;0;79;0
WireConnection;76;1;80;0
WireConnection;59;0;48;0
WireConnection;11;0;5;0
WireConnection;156;1;162;0
WireConnection;156;0;163;0
WireConnection;156;2;158;0
WireConnection;18;0;16;0
WireConnection;18;1;19;0
WireConnection;18;2;19;0
WireConnection;10;0;9;0
WireConnection;10;1;8;0
WireConnection;255;0;161;0
WireConnection;255;1;258;0
WireConnection;72;0;71;0
WireConnection;73;0;72;0
WireConnection;82;0;77;0
WireConnection;107;0;105;0
WireConnection;161;1;159;0
WireConnection;161;0;160;0
WireConnection;95;0;96;0
WireConnection;238;1;195;0
WireConnection;238;0;253;0
WireConnection;93;0;92;0
WireConnection;93;1;94;1
WireConnection;63;0;23;0
WireConnection;167;0;39;0
WireConnection;167;1;166;0
WireConnection;263;1;266;0
WireConnection;263;3;271;0
WireConnection;165;0;51;0
WireConnection;165;1;164;0
WireConnection;203;5;198;0
WireConnection;240;1;244;0
WireConnection;240;0;224;0
WireConnection;250;0;246;0
WireConnection;251;1;252;0
WireConnection;251;0;57;0
WireConnection;257;0;255;0
WireConnection;257;1;256;0
WireConnection;266;0;271;0
WireConnection;261;0;269;0
WireConnection;261;1;263;0
WireConnection;265;0;264;0
WireConnection;265;1;261;0
WireConnection;265;2;272;0
WireConnection;267;0;275;0
WireConnection;249;0;247;0
WireConnection;273;0;268;0
WireConnection;273;1;261;0
WireConnection;273;2;272;0
WireConnection;262;0;274;0
WireConnection;269;0;260;0
WireConnection;269;1;270;0
WireConnection;75;0;73;0
WireConnection;75;1;74;0
WireConnection;274;1;268;0
WireConnection;274;0;273;0
WireConnection;144;0;146;0
WireConnection;144;1;18;0
WireConnection;110;0;100;0
WireConnection;110;1;116;0
WireConnection;17;0;36;0
WireConnection;105;0;103;0
WireConnection;105;1;106;0
WireConnection;148;1;18;0
WireConnection;40;0;38;0
WireConnection;40;1;48;0
WireConnection;231;0;24;0
WireConnection;129;0;123;0
WireConnection;114;0;112;0
WireConnection;114;1;113;0
WireConnection;114;2;115;0
WireConnection;5;0;6;0
WireConnection;5;1;7;0
WireConnection;159;0;147;0
WireConnection;159;1;155;0
WireConnection;159;2;156;0
WireConnection;98;0;97;0
WireConnection;98;1;99;0
WireConnection;124;0;111;0
WireConnection;258;0;254;0
WireConnection;155;1;149;0
WireConnection;155;0;148;0
WireConnection;111;0;42;0
WireConnection;111;1;108;0
WireConnection;71;0;69;0
WireConnection;71;1;78;0
WireConnection;207;0;245;0
WireConnection;12;0;10;0
WireConnection;192;1;185;0
WireConnection;64;0;63;0
WireConnection;149;0;154;0
WireConnection;149;1;18;0
WireConnection;58;0;86;0
WireConnection;86;0;82;0
WireConnection;86;1;85;0
WireConnection;51;11;46;0
WireConnection;206;20;221;0
WireConnection;206;17;173;0
WireConnection;206;8;177;0
WireConnection;56;0;131;0
WireConnection;56;1;251;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;116;0;109;0
WireConnection;116;1;114;0
WireConnection;41;0;40;0
WireConnection;217;5;198;0
WireConnection;133;0;56;0
WireConnection;25;0;23;0
WireConnection;253;38;195;0
WireConnection;253;48;234;0
WireConnection;241;1;242;0
WireConnection;241;0;224;1
WireConnection;157;0;109;0
WireConnection;228;1;185;0
WireConnection;228;5;198;0
WireConnection;34;0;33;0
WireConnection;147;1;144;0
WireConnection;147;0;15;0
WireConnection;100;0;98;0
WireConnection;23;5;232;0
WireConnection;235;0;239;0
WireConnection;225;0;238;0
WireConnection;199;0;241;0
WireConnection;244;0;243;0
WireConnection;15;1;18;0
WireConnection;185;0;179;0
WireConnection;197;5;198;0
WireConnection;275;1;264;0
WireConnection;275;0;265;0
WireConnection;239;1;234;0
WireConnection;239;0;253;49
WireConnection;237;1;186;0
WireConnection;237;0;183;68
WireConnection;243;0;196;0
WireConnection;236;1;175;0
WireConnection;236;0;183;67
WireConnection;190;0;237;0
WireConnection;160;0;159;0
WireConnection;6;0;27;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;215;0;240;0
WireConnection;183;44;209;0
WireConnection;183;53;214;0
WireConnection;183;41;175;0
WireConnection;183;45;186;0
WireConnection;183;42;223;0
WireConnection;183;65;197;0
WireConnection;183;48;229;0
WireConnection;183;54;203;0
WireConnection;183;47;200;0
WireConnection;183;63;217;0
WireConnection;245;1;221;0
WireConnection;245;0;206;0
WireConnection;48;0;167;0
WireConnection;48;1;47;0
WireConnection;242;0;194;0
WireConnection;201;0;236;0
WireConnection;224;2;196;0
WireConnection;224;25;192;0
WireConnection;224;26;194;0
WireConnection;224;27;228;0
WireConnection;224;42;212;0
WireConnection;1;2;130;0
WireConnection;0;0;134;0
ASEEND*/
//CHKSM=7FE238E6397DA0319E374F7C55D84ED09C97E010