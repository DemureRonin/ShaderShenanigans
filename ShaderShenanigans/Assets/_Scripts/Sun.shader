Shader"Custom/Sun"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Color1 ("Color1", Color) = (1,1,1,1)
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
            float4 _Color;
            float4 _Color1;

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
                float2 uv = i.uv;
                uv = (uv - 0.5) * 2;
                float d = length(uv);
                if (d > 0.5) discard;
                float4 color;
                float v = max(uv.x, uv.y);
                if (uv.y > 0.05)
                {
                    
                    color = lerp( _Color, _Color1, uv.y + 0.3 );
                }
                else if ((uv.y > -0.1 && uv.y < 0.1) || ((uv.y > -0.4 && uv.y < -0.3)))
                {
                    discard;
                }
                return color;
            }
            ENDCG
        }
    }
}