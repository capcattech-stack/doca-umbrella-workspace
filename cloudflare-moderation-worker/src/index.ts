export interface Env {
  AI: any; // Cloudflare Workers AI binding
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    // 1. Handle CORS Preflight
    const corsHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
    };

    if (request.method === "OPTIONS") {
      return new Response(null, { headers: corsHeaders });
    }

    if (request.method !== "POST") {
      return new Response(JSON.stringify({ error: "Method not allowed" }), {
        status: 405,
        headers: { "Content-Type": "application/json", ...corsHeaders }
      });
    }

    try {
      const body = await request.json() as { image: string };
      if (!body || !body.image) {
        return new Response(JSON.stringify({ valid: false, reason: "Thiếu dữ liệu hình ảnh." }), {
          status: 400,
          headers: { "Content-Type": "application/json", ...corsHeaders }
        });
      }

      // 2. Chuyển đổi dữ liệu hình ảnh Base64 sang Binary (Uint8Array)
      const base64Data = body.image.split(',')[1] || body.image;
      const binaryString = atob(base64Data);
      const len = binaryString.length;
      const bytes = new Uint8Array(len);
      for (let i = 0; i < len; i++) {
        bytes[i] = binaryString.charCodeAt(i);
      }

      // 3. Gọi mô hình ResNet-50 trên Cloudflare Workers AI để phân loại hình ảnh
      const predictions = await env.AI.run("@cf/microsoft/resnet-50", {
        image: [...bytes]
      }) as Array<{ label: string; score: number }>;

      console.log("Cloudflare Workers AI predictions:", predictions);

      // 4. Kiểm tra xem có chú mèo nào trong kết quả nhận diện không
      const catKeywords = ['cat', 'kitten', 'tabby', 'persian cat', 'siamese cat', 'egyptian mau', 'feline', 'maltese cat', 'tiger cat', 'angora', 'lynx'];
      const isCat = predictions.some((pred) => {
        const labelLower = pred.label.toLowerCase();
        // Ngưỡng điểm tin cậy > 8% (0.08) tương tự như MobileNet offline trước đó
        return catKeywords.some(kw => labelLower.includes(kw)) && pred.score > 0.08;
      });

      if (isCat) {
        return new Response(JSON.stringify({ valid: true, reason: "Ảnh chứa chú mèo hợp lệ." }), {
          headers: { "Content-Type": "application/json", ...corsHeaders }
        });
      } else {
        // Lấy nhãn dự đoán cao nhất làm gợi ý lý do từ chối (nếu có)
        const topPrediction = predictions[0] ? predictions[0].label : "đồ vật/phong cảnh";
        return new Response(JSON.stringify({ 
          valid: false, 
          reason: `Hình như ảnh này không chứa chú mèo nào cả (Nhận diện được: ${topPrediction}). Cô/chú gửi lại ảnh bé mèo nhé! 🐾` 
        }), {
          headers: { "Content-Type": "application/json", ...corsHeaders }
        });
      }

    } catch (error: any) {
      console.error("Worker error:", error);
      return new Response(JSON.stringify({ valid: false, reason: `Lỗi xử lý kiểm duyệt: ${error.message}` }), {
        status: 500,
        headers: { "Content-Type": "application/json", ...corsHeaders }
      });
    }
  }
};
