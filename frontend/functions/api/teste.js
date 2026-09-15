export function onRequestGet(context) {
  return Response.json({
    ok: true,
    service: "cloudflare-pages-function",
    hasApiOrigin: Boolean(context.env.API_ORIGIN),
  });
}
