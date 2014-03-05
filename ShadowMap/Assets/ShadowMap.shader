Shader "Custom/ShadowMap" {
 	Properties {
        _AOTex ("AO Texture", 2D) = "white" {}
        _MtlColor ("Material Color", Color) = (1.0,1.0,1.0,1.0)
    }
    
	CGINCLUDE
	 
	#include "UnityCG.cginc"
	#include "AutoLight.cginc"
	#include "Lighting.cginc"
	
	// uniform = const 
	uniform sampler2D _AOTex;
	uniform float4 _MtlColor;
	 
	ENDCG
	 
	SubShader
	{
	    Tags { "RenderType"="Opaque" }
	    LOD 200
	 
	    Pass
	    {
	       Lighting On
	 
	       Tags {"LightMode" = "ForwardBase"}
	 
	       CGPROGRAM
	 
	       #pragma vertex vert
	       #pragma fragment frag
	       #pragma multi_compile_fwdbase
	 
	       struct VSOut
	       {
	         float4 pos      : SV_POSITION;
	         float3 normal   : TEXCOORD0;
	         float2 uv       : TEXCOORD1;
	         LIGHTING_COORDS(3,4)
	         float4 _SquaredShadowCoord : TEXCOORD5;
	       };
	 
	       VSOut vert(appdata_tan v)
	       {
	         VSOut o;
	         o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
	         o.uv = v.texcoord.xy;
	         o.normal = v.normal;
	 
	         TRANSFER_VERTEX_TO_FRAGMENT(o);
	 
	         return o;
	       }
	 
	       float4 frag(VSOut i) : COLOR 
	       {
	         float3 lightColor = _LightColor0.rgb;
	         float3 lightDir = _WorldSpaceLightPos0;
	         
	         float4 ao = tex2D(_AOTex, i.uv.xy);
	         float  atten = LIGHT_ATTENUATION(i);
	         float  NL = saturate(dot(i.normal, lightDir));
	 
	         float3 color = lightColor * atten * (NL * _MtlColor.rgb * ao.r);
	         return float4(color.rgb, ao.w);
	       }
	 
	       ENDCG
	    }
	} 
	FallBack "Diffuse"
}
