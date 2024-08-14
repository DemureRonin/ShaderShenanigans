Shader "Custom/Shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200
        Pass
        {
            CGPROGRAM
            #pragma vertex vp
            #pragma fragment fp
            #pragma target 3.0
            #include "UnityPBSLighting.cginc"
            #include "AutoLight.cginc"

            struct VertexData
            {
                float4 position : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            v2f vp(VertexData v)
            {
                v2f i;
                i.normal = normalize(UnityObjectToWorldNormal(v.normal));
                i.position = UnityObjectToClipPos(v.position);
                i.worldPos = mul(unity_ObjectToWorld, v.position);
                i.uv = v.uv;
                return i;
            }

            float4 fp(v2f i) : SV_TARGET
            {
                
                return float4(i.uv, 1, 1);
            }
            ENDCG
        }
    }
}