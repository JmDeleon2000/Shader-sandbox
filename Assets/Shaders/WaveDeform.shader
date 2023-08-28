Shader"Sandbox/WaveDeform"
{
    Properties
    {
        _MainTex ("Color Texture", 2D) = "white" {}
        _WHeightMap ("Wave Heightmap", 2D) = "white" {}
        _IHeightMap ("Island Heightmap", 2D) = "white" {}
        _DeformMap ("Deform map", 2D) = "white" {}
        _XWaves ("Horizontal Wave amount", Range(1, 100)) = 10
        _YWaves ("Vertical Wave amount", Range(1, 100)) = 10
        _Amp ("Amplitude", Range(0, 1)) = 0.5
        _LandIntensity ("Island Height",  Range(0, 1)) = 0.5
        _Brightness ("Wave specular intensity", Range(0, 100)) = 10
        _WaveSpecular ("Wave specular bias", Range(1, 128)) = 8
        
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"
                "Queue"="Transparent"}
        LOD 100


//Cosas que podemos pedirle abort Unity hacer o no hacer






        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off


        Pass
        {
            HLSLPROGRAM

            #define tau 6.283185307179586476925286766559

            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct FragInput
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 deform : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _WHeightMap;
            float4 _WHeightMap_ST;
            sampler2D _IHeightMap;
            float4 _IHeightMap_ST;
            sampler2D _DeformMap;
            float4 _DeformMap_ST;
            sampler2D _ThirdTex;
            float4 _ThirdTex_ST;
            float _XWaves;
            float _YWaves;
            float _LandIntensity;
            float _Amp;
            float _Brightness;
            float _WaveSpecular;

            #pragma vertex vert
            FragInput vert(VertexInput v)
            {
                FragInput o;
                float4 WHMap = tex2Dlod(_WHeightMap, float4(v.uv.xy, 0, 0));
                float4 DMap = tex2Dlod(_DeformMap, float4(v.uv.xy, 0, 0));
                float4 IHMap = tex2Dlod(_IHeightMap, float4(v.uv.xy, 0, 0));
    
    

                //float radialDistance = length(v.uv * 2 - 1);
                float foo = cos((v.uv.x) * tau) * 0.2 + _Time.x*2;
                float4 deform = cos((v.uv.x - _Time.x) * _XWaves * tau)
                               * cos((v.uv.y + foo) * _YWaves * tau) 
                               * WHMap;
    
                //Make waves
                v.vertex += deform
                                * _Amp
                                * pow(DMap, 3);
    
                //Raise land
                v.vertex.y += IHMap * _LandIntensity;
    
    
                //Pass to frag shader
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.deform = deform*0.5+0.5;
                return o;
            }

            #pragma fragment frag
            fixed4 frag (FragInput i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
    
    

                  
                float2 radial = i.uv * (1-i.uv) * 2;
                //return float4(frac(radial.x * radial.y * tau * 25).xxx, 1);
                float radial_offset = frac(radial.x * radial.y * tau * 5).xxx * tau;
    
                float radialDistance = length(i.uv * 2 - 1);
                //return float4(radialDistance.xxx, 1);
                i.uv.x = radialDistance;
                //i.uv.y = radialDistance;
                
                
                //return float4(cos(radial_offset - _Time.y).xxx, 1);
                float foo = cos((i.uv.x ) * tau) * 0.2 + _Time.x*2;
                float4 deform = cos((i.uv.x  + _Time.x) * _XWaves * tau)
                               * cos((i.uv.y + foo) * _YWaves * tau) 
                               * float4(cos(radial_offset - _Time.y).xxx, 1);
                //return float4(deform.rgb, 1);
               
                //clip(i.deform.yyy);
                //return float4(pow(i.deform.yyy, 16)*2, 1);
                return saturate(float4(pow(i.deform.yyy, _WaveSpecular), 0))*_Brightness + col;
    
                //float foo = cos((i.uv.x) * 2 * tau) * 0.2 + _Time.x*2;
                //return (cos((i.uv.y + foo) * _YWaves * tau) * 0.5 + 0.5);
        
                return col;
            }
            ENDHLSL
        }
    }
}







/*
 i.uv *= 1-i.uv;
                i.uv *=2;
                return float4(i.uv.xxx * i.uv.yyy, 1);
*/



/***Error:
                //float2 radial = v.uv * (1-v.uv) * 2;
                //float radial_offset = frac(radial.x * radial.y * tau * 5).xxx * tau;
***/