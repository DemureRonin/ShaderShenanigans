// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TextureSplatting"
{
    Properties
    {
        _MainTex ("SplatMap", 2D) = "white" {}
        [NoScaleOffset] _Texture1 ("Texture 1", 2D) = "white" {}
        [NoScaleOffset] _Texture2 ("Texture 2", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vp
            #pragma fragment fp
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Texture1, _Texture2;

            struct Interpolators
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uvSplat : TEXCOORD1;
            };

            struct VertexData
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            Interpolators vp(VertexData v)
            {
                Interpolators i;
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                i.position = UnityObjectToClipPos(v.position);
                i.uvSplat = v.uv;
                return i;
            }

            float4 fp(Interpolators i) : SV_TARGET
            {
                float4 splat = tex2D(_MainTex, i.uvSplat);
                return tex2D(_Texture1, i.uv) * splat.r +
                    tex2D(_Texture2, i.uv) * (1 - splat.r);
            }
            ENDCG
        }
    }
}