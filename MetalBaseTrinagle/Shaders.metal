//
//  Shaders.metal
//  MetalBaseTrinagle
//
//  Created by Артем Соловьев on 12.05.2025.
//

#include <metal_stdlib>
using namespace metal;

//MARK: - Cтруктура, которая принимает в себя массив позиций типа float
struct VertexOut {
    float4 position [[position]];
};

//MARK: - Функция, которая создает структуру исходя из ее парамметров и рисует вершины
vertex VertexOut vertex_main(uint vertexID [[vertex_id]], const device float2* vertices [[buffer(0)]]) {
    VertexOut out;
    out.position = float4(vertices[vertexID], 0, 1);
    return out;
};

//MARK: - Фрагмент функция, которая заполняет пиксели цветом
fragment float4 fragment_main() {
    return float4(1.0, 0.0, 0.0, 1.0); //Красный цвет
}
