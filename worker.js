export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    
    // =========================================================================
    // 配置区域
    // =========================================================================
    
    // 你的 Hugging Face Space 的 Direct URL
    // 获取方式：在 Space 页面右上角点击 "Embed this space"，复制 "Direct URL"
    // 格式通常是: https://用户名-space名字.hf.space
    const TARGET_HOST = "你的用户名-space名字.hf.space";
    
    // =========================================================================
    
    // 修改目标主机名
    url.hostname = TARGET_HOST;
    url.protocol = "https:";
    
    // 创建新请求
    const newRequest = new Request(url, {
      method: request.method,
      headers: request.headers,
      body: request.body,
      redirect: "follow"
    });

    // 可以在这里添加额外的 Header，例如：
    // newRequest.headers.set("X-Forwarded-By", "Cloudflare-Worker");

    try {
      const response = await fetch(newRequest);
      return response;
    } catch (e) {
      return new Response("Error connecting to backend: " + e.message, { status: 502 });
    }
  }
};
