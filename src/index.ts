const httpProxy = require("http-proxy");

const TARGET_URL = process.env.TARGET_URL || "https://stg-inventory-api.thh.io";
const PORT = process.env.PORT || 8000;
const proxy = httpProxy
  .createProxyServer({
    target: TARGET_URL,
    secure: false,
  })
  .listen(PORT);

proxy.on("proxyRes", function (proxyRes: any, req: any, res: any) {
  proxyRes.headers["access-control-allow-origin"] = "*";
  proxyRes.headers["Access-Control-Allow-Methods"] = "POST, GET, OPTIONS";
});

console.log(
  `Http proxy server started at ${PORT}. Forwarding to ${TARGET_URL}`
);
