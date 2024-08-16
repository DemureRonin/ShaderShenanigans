// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ShaderLearn"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint ("Tint", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vp
            #pragma fragment fp
            #include "UnityCG.cginc"
            float4 _Tint;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct Interpolators
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexData
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            Interpolators vp(VertexData v)
            {
                Interpolators i;
                i.uv  = TRANSFORM_TEX(v.uv, _MainTex);
                i.position = UnityObjectToClipPos(v.position);
                return i;
            }

            float4 fp(Interpolators i) : SV_TARGET
            {
                return tex2D(_MainTex, i.uv) * _Tint;
            }
            ENDCG
        }
    }
}