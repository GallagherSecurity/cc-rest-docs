import { defineConfig, markdown, openapi } from "sourcey";

export default defineConfig({
  name: "CC",
  theme: {
    preset: "default",
    zpreset: "api-first",
    zzzpreset: "minimal",
    css: ["./sourcey-overrides.css"],
  },
  logo:  "https://gallaghersecurity.github.io/cc-rest-docs/ref/images/gallagher.png"
  ,
  navbar: {
    links: [
      { type: "linkedin", href: "https://nz.linkedin.com/company/gallagher-security" }
      ]
  },
  navigation: {
    tabs: [
      {
        tab: "API Reference",
        slug: "api",
        source: openapi("../out/cc_rest.yaml"),
      },
    ],
  },
  codeSamples: ["go", "csharp", "curl", "javascript", "typescript", "python"],
});
