/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run "npm run dev" in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run "npm run deploy" to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

function MethodNotAllowed(request) {
  return new Response(`Method ${request.method} not allowed.`, {
    status: 405,
    headers: {
      Allow: "GET",
    },
  });
}

const redirects = [
  [
    "https://dantecalderon.com/lab/clicker-with-hammer",
    "https://click-with-hammer.netlify.app",
  ],
];

export default {
  async fetch(request, env, ctx) {
    if (request.method !== "GET") return MethodNotAllowed(request);

    /**
     * To allow relative assets load is necessary to have a correct relative path
     */
    if (!request.url.endsWith("/")) {
      const urls = request.url.split("/");

      // Contains a dot means have an extension, example: main.js  image.png
      // it's doesn't 100% accurate but it's enough for this case
      // If we redirect it still will work.
      if (urls[urls.length - 1].split(".").length === 1) {
        return Response.redirect(request.url + "/", 301);
      }
    }

    for (let redirect of redirects) {
      if (request.url.startsWith(redirect[0])) {
        const originUrl = request.url.replace(redirect[0], redirect[1]);

        const originPage = await fetch(originUrl);

        return new Response(originPage.body, originPage);
      }
    }

    // do nothing
    return fetch(request);
  },
};
