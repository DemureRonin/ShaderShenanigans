Shader "Custom/Shader"
{
    Properties {}
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

            float3 palette(float t)
            {
                float3 a = float3(0.500, 0.500, 0.500);
                float3 b = float3(0.666, 0.666, 0.666);
                float3 c = float3(1.000, 1.000, 1.000);
                float3 d = float3(0.000, 0.333, 0.667);
                return a + b * cos(6.28318 * (c * t + d));
            }

            float4 fp(v2f i) : SV_TARGET
            {
                float2 uv = i.uv;
                
                uv = (uv - 0.5) * 2;
                float2 uv0 = uv;
                uv *= 2;
                uv = frac(uv);
                uv = (uv - 0.5);

                float d = length(uv);
                float3 tint = palette(length(uv0) + _Time * 10);
                d = sin(d * 5 + _Time * 20) / 5;
                d = abs(d);
                d = 0.01 / d;
                tint *= d;
                return float4(pow(tint, 2), 1);
            }
            ENDCG
        }
    }
}