shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.a *= texture(mask_texture, UV).a;
	
	COLOR = color;	
}