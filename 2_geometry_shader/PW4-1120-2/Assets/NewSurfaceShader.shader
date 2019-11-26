﻿Shader "Custom/NewSurfaceShader"
{
    Properties
    {
	   _GlassTex("Glass Texture",2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

		Pass
	{
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma vertex vert
#pragma geometry geom
#pragma fragment frag

#include "UnityCG.cginc"

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct appdata
		{
			float4 pos : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2g
		{
			float2 uv: TEXCOORD0;
			float4 pos: SV_POSITION;

		};

		struct g2f
		{
			float2 uv: TEXCOORD0;
			float4 pos:SV_POSITION;

		};

		sampler2D _GlassTex;
		float4 _MainTex_ST;

		v2g vert(appdata v)
		{
			v2g o;
			o.pos = v.pos;
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			return o;
		}

		[maxvertexcount(12)]
		void geom(triangle v2g IN[3],inout TriangleStream<g2f> stream)
		{
			g2f o;

			float h = 1.0;
			int n = 2;
			for (int i = 0; i < 3; i++)
			{
				o.pos = UnityObjectToClipPos(IN[i].pos);
				o.uv = float2(0.0, 0.0);
				stream.Append(o);

				o.pos = UnityObjectToClipPos(IN[i].pos + float4(0, h, 0, 0));
				o.uv = float2(0.0, 1.0);
				stream.Append(o);
			
				o.pos = UnityObjectToClipPos(IN[i].pos);
				o.uv = float2(1.0, 0.0);
				stream.Append(o);

				o.pos = UnityObjectToClipPos(IN[i].pos + float4(0, h, 0, 0));
				o.uv = float2(1.0, 1.0);
				stream.Append(o);

				stream.RestartStrip();

				n = i;
			}
		}

		fixed4 frag(g2f i):SV_Target
		{
		fixed4 col = tex2D(_GlassTex, i.uv);
		if (col.a <= 0.5)discard;
		return col;
		}
		ENDCG
			}
    }
    FallBack "Diffuse"
}
