Shader "Custom/InstancedSurfacedScript"
{
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
			_DisplacementMap("Displacement (RG)",2D) = "white"{}
	}

		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200
			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows vertex:vert
			// Use Shader model 3.0 target
			#pragma target 3.0
			sampler2D _MainTex;
	sampler2D _DisplacementMap;
			struct Input {
				float2 uv_MainTex;
			};
			half _Glossiness;
			half _Metallic;
			UNITY_INSTANCING_BUFFER_START(Props)
			   UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
			UNITY_INSTANCING_BUFFER_END(Props)

				void vert(inout appdata_full v)
			{
				float2 d = tex2Dlod(_DisplacementMap, float4(v.vertex.xy, 0, 0)).xy;
				v.vertex.xz += (v.vertex.y + 1.0)*d.xy * 10;
			}

			void surf(Input IN, inout SurfaceOutputStandard o) {
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
				o.Albedo = c.rgb;
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;
			}
			ENDCG
		}
    FallBack "Diffuse"
}
