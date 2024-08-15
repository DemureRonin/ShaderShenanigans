Shader "Custom/VaporwaveGrid"
{
    Properties
    {
        _GridColor ("Grid Color", Color) = (1,1,1,1)
        _LineColor ("Line Color", Color) = (1,1,1,1)
        _LineWidth ("Line Width", Range(0.0, 1.0)) = 0.02
        _BlurAmount ("Blur Amount", Range(0.0, 10.0)) = 1.0
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Overlay"
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            float _LineWidth;
            float _BlurAmount;
            float4 _GridColor;
            float4 _LineColor;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.vertex.xy * 0.5 + 0.5;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float2 uv0 = uv;
                uv0 = (uv0 - 0.5) * 2;
                float d = length(uv0);
                if (d > 0.4) discard;
                uv.x += _Time * 0.5;
                float2 grid = abs(frac(uv * 100) - 0.5);
               
                float lane = min(grid.x, grid.y);
                lane = smoothstep(_LineWidth, _LineWidth * 0.5, lane);
                lane = pow(lane, 2);
                return _LineColor * lane;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}