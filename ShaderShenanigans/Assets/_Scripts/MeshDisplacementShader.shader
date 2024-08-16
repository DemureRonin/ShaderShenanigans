Shader "Custom/MeshDisplacement"
{
    Properties
    {
        /*_GridColor ("Grid Color", Color) = (1,1,1,1)
        
        _LineWidth ("Line Width", Range(0.0, 1.0)) = 0.02
        _BlurAmount ("Blur Amount", Range(0.0, 10.0)) = 1.02*/
        [NoScaleOffset] _NoiseTex1 ("NoiseTex", 2D) = "white" {}
        [NoScaleOffset] _NoiseTex2 ("NoiseTex", 2D) = "white" {}
        [NoScaleOffset] _NoiseTex3 ("NoiseTex", 2D) = "white" {}
        _DispStr1 ("_DispStr", Range(0.0, 100.0)) = 0.02
        _DispStr2 ("_DispStr", Range(0.0, 100.0)) = 0.02
        _DispStr3 ("_DispStr", Range(0.0, 100.0)) = 0.02

        _Water ("_Water", Range(0.0, 100.0)) = 0.02
        _WaterTint ("_WaterTint", Color) = (1,1,1,1)
        _Land ("_Land", Range(0.0, 100.0)) = 0.02

        _LandTint ("_LandTint", Color) = (1,1,1,1)
        _Mountain ("_Mountain", Range(0.0, 100.0)) = 0.02
        _MountainTint ("_MountainTint", Color) = (1,1,1,1)

        _WaterLevel ("_WaterLevel", Range(0.0, 100.0)) = 0.02
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vp
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _NoiseTex1;
            sampler2D _NoiseTex2;
            sampler2D _NoiseTex3;

            float _Water;
            float4 _WaterTint;
            float _Land;
            float4 _LandTint;
            float _Mountain;
            float _WaterLevel;
            float4 _MountainTint;

            float _DispStr1;
            float _DispStr2;
            float _DispStr3;

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


                // Sample the noise texture
                float noise1 = tex2Dlod(_NoiseTex1, float4(v.uv, 0, 0)).r;
                float noise2 = tex2Dlod(_NoiseTex2, float4(v.uv, 0, 0)).r;
                float noise3 = tex2Dlod(_NoiseTex3, float4(v.uv, 0, 0)).r;

                // Displace along the normal
                float3 displacement = v.normal * ((noise1 * _DispStr1) + (noise2 * _DispStr2) + (noise3 * _DispStr3));
                if (displacement.y < _WaterLevel)
                    displacement.y = _WaterLevel;
                v.position.xyz += displacement;

                i.position = UnityObjectToClipPos(v.position);
                i.worldPos = mul(unity_ObjectToWorld, v.position);
                i.normal = normalize(UnityObjectToWorldNormal(v.normal));
                i.uv = v.uv;
                return i;
            }


            half4 frag(v2f i) : SV_Target
            {
                if (i.worldPos.y < _Land)
                {
                    return i.worldPos.y * _WaterTint  * tex2D(_NoiseTex1, i.uv) ;
                }
                if (i.worldPos.y < _Mountain && i.worldPos.y > _Water)
                {
                    return i.worldPos.y * _LandTint*tex2D(_NoiseTex1, i.uv);
                }
                else
                {
                    return i.worldPos.y * _MountainTint*tex2D(_NoiseTex1, i.uv);
                }
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}