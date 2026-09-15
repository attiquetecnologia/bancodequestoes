function apiOrigin(context) {
  const origin = context.env.API_ORIGIN;
  if (!origin) {
    return new Response("API_ORIGIN não configurada no Cloudflare Pages", { status: 500 });
  }
  return origin.replace(/\/$/, "");
}

export async function onRequest(context) {
  const origin = apiOrigin(context);
  if (origin instanceof Response) return origin;

  const targetUrl = new URL(context.request.url);
  const target = `${origin}${targetUrl.pathname}${targetUrl.search}`;
  const request = new Request(target, context.request);
  request.headers.set("X-Forwarded-By", "Cloudflare-Pages-Function");

  return fetch(request);
}
