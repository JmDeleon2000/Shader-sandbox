Shader"Sandbox/RandomShader"
{
    Properties
    {
        _MainTex ("Foo Texture", 2D) = "white" {}
        _SecondTex ("Another Texture", 2D) = "white" {}
        _ThirdTex ("Yet Another Texture", 2D) = "white" {}
        _Foo ("Bar parameter", Range(-1, 100)) = 0 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100


//Cosas que podemos pedirle abort Unity hacer o no hacer






        Cull Off
    



// ZWrite Off
          ZTest Always
    ColorMask RA
    


        Pass
        {
            HLSLPROGRAM

            #define pi 3.14159265358979323846

            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct FragInput
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SecondTex;
            float4 _SecondTex_ST;
            sampler2D _ThirdTex;
            float4 _ThirdTex_ST;
            float _Foo;

            #pragma vertex vert
            FragInput vert(VertexInput v)
            {
                FragInput o;
                //v.vertex.xyz *= pow(sin(v.uv.x * _Time.z), 6);
                //v.vertex.y += cos(v.uv.x + _Time.a);
                o.normal = UnityObjectToWorldNormal(v.normal);
    //v.vertex.xyz += o.normal * sin(_Time.a)*2;
                //v.vertex.y *= cos(v.uv.x*_Foo + _Time.a);
                //v.vertex.y += cos(v.uv.x * _Foo + _Time.a) * 1;
                float4 tex = tex2Dlod(_MainTex, float4(v.uv.xy, 0, 0));
                v.vertex.y += cos(v.uv.x * _Foo + _Time.a) 
                                * tex 
                                * cos(v.uv.y * _Foo + _Time.a);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
               // o.normal = v.normal;
                return o;
            }

            #pragma fragment frag
            fixed4 frag (FragInput i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col1 = tex2D(_SecondTex, i.uv);
                fixed4 col2 = tex2D(_ThirdTex, i.uv);
                //col = smoothstep(0.5, 0.8, i.uv.x);
                //return float4(i.uv.rrr, 1);
                //return float4(i.uv.yyy, 1);
               // return (float4(frac(i.uv * 100), 0, 1));
    //return float4(cos(i.uv.rrr*10*pi), 1)*0.5+0.5;
    return float4(i.normal, 1);
    
    
    
    
    
                //return float4(i.normal, 1);
    
    
    
                //return float4(10, 1, 1, 1);
            
    
                /*float4 offset = (sin((i.uv.r + _Time.a) * 3 * pi * 2) 
                                * 0.5 + 0.5) * 0.05;
                return sin((offset + i.uv.y + _Time.y ) * 3 * pi * 2) 
                                * 0.5 + 0.5;*/
                
                //return col.rgba;
                return (1, 1,1, 1);
                //return col.rgba * col1.rgba;
                return lerp(col.rgba, col1.rgba, frac(_Time.y));
            }
            ENDHLSL
        }
    }
}
