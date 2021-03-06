﻿// VacuumShaders 2014
// https://www.facebook.com/VacuumShaders

Shader "VacuumShaders/Colored Shadows/Reflective/Diffuse" 
{
	Properties 
	{
		//Default Options
		[DefaultOptions]
		V_CSH_D_OPTIONS("", float) = 0

		_Color("Main Color", color) = (1, 1, 1, 1)
		_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
		_ReflectColor ("Reflection Color", Color) = (1, 1, 1, 0.5)
		_Cube ("Reflection Cubemap", Cube) = "_Skybox" { TexGen CubeReflect }

		
		//Shadow Options
		[ShadowOptions]
		V_CSH_SH_OPTIONS("", float) = 0

		_V_CSH_ShadowIntencity("Shadow Intencity", Range(0, 1)) = 1
		[HideInInspector]
		_V_CSH_ShadowColor("Shadow Color", color) = (0, 1, 0.5, 1)		
		[HideInInspector]
		_V_CSH_ShadowTex("Shadow Texture", 2D) = "black"{}
		[HideInInspector]
		_V_CSH_GradientTex("Gradient Texture", 2D) = "black"{}
		[HideInInspector]
		_V_CSH_ShadowEmissive("Shadow Emissive", Range(0, 1)) = 1	

	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		 Pass 
		 {
            Name "ForwardBase"
            Tags {"LightMode"="ForwardBase"}
            
            
            CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#define UNITY_PASS_FORWARDBASE
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				#pragma multi_compile_fwdbase

				#pragma shader_feature V_CSH_COLOR_LIGHTCOLOR V_CSH_COLOR_INVERTLIGHTCOLOR V_CSH_COLOR_CUSTOMCOLOR V_CSH_COLOR_GRADIENT
				#pragma shader_feature V_CSH_DISABLE_LIGHT_COLORES_OFF V_CSH_DISABLE_LIGHT_COLORES_ON
				#pragma shader_feature V_CSH_TEXTURE_NONE V_CSH_TEXTURE_RGB V_CSH_TEXTURE_RGBA
				#pragma shader_feature V_CSH_EMISSION_TYPE_NONE V_CSH_EMISSION_TYPE_MULTIPLY V_CSH_EMISSION_TYPE_EXPONENTAL


				#define NEED_CALC_NORMAL_WS
				#define NEED_CALC_LIGHTDIR_WS
				#define NEED_CALC_REFL_WS

				#define NEED_P_NORMAL_WS
				#define NEED_P_LIGHTDIR_WS
				#define NEED_P_REFL_WS

				#define REFLECTION_ON

				struct v2f 
				{
					float4 pos : SV_POSITION;
					half4 uv : TEXCOORD0;

					half3 normal : TEXCOORD1;
					half3 ligthDir : TEXCOORD2;
					half3 refl : TEXCOORD3;
					 
					LIGHTING_COORDS(4,5)
				};

				#include "ColoredShadowsCG.cginc"
			
			ENDCG
		 }

	     Pass 
		 {
            Name "ForwardAdd"
            Tags {"LightMode"="ForwardAdd"}
            Blend One One
            
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
				#pragma vertex vert 
				#pragma fragment frag
				#define UNITY_PASS_FORWARDADD
				#include "UnityCG.cginc" 


				#include "ColoredShadowsAutoLight.cginc"
				#pragma multi_compile_fwdadd_fullshadows
            
				#pragma shader_feature V_CSH_COLOR_LIGHTCOLOR V_CSH_COLOR_INVERTLIGHTCOLOR V_CSH_COLOR_CUSTOMCOLOR V_CSH_COLOR_GRADIENT
				#pragma shader_feature V_CSH_DISABLE_LIGHT_COLORES_OFF V_CSH_DISABLE_LIGHT_COLORES_ON
				#pragma shader_feature V_CSH_TEXTURE_NONE V_CSH_TEXTURE_RGB V_CSH_TEXTURE_RGBA
				#pragma shader_feature V_CSH_EMISSION_TYPE_NONE V_CSH_EMISSION_TYPE_MULTIPLY V_CSH_EMISSION_TYPE_EXPONENTAL

			
			            
				#define NEED_CALC_NORMAL_WS
				#define NEED_CALC_LIGHTDIR_WS

				#define NEED_P_NORMAL_WS
				#define NEED_P_LIGHTDIR_WS

				struct v2f 
				{ 
					float4 pos : SV_POSITION;
					half4 uv : TEXCOORD0;

					half3 normal : TEXCOORD1;
					half3 ligthDir : TEXCOORD2;

					LIGHTING_COORDS(3,4)
				};

				#include "ColoredShadowsCG.cginc"									
			
			ENDCG
		}
	} 

	FallBack "Reflective/VertexLit"

	CustomEditor "ColoredShadowsMaterialEditor"
}
