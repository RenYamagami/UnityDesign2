Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float Circle(float2 p){
				p*= 10.0;
				return ((p.x*p.x+p.y*p.y)-10);
			}
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float rings(float2 p){
				return sin(length(p)*100);
			}
            
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                float2 p = (i.uv)+float2(0.5,0.5);
				float index = floor(p.x * 10.0*sin(_Time));
				p.y += index *sin(_Time);

	                fixed4 col2 = tex2D(_MainTex, p);

                float s = _Time*30;
                if(Circle(i.uv-float2(0.5,0.5))>0.1){
                return col;
                }else{
                return col2;

                }

                 
            }
            ENDCG
        }
    }
}