import { build } from "esbuild";
import { mkdir, copyFile } from "fs/promises";
import { join } from "path";

build({
  bundle: true,
  outdir: "./dist",
  minify: false,
  platform: 'node',
  target: "es6",
  color: true,
  jsx: "transform",
  sourcemap: true,
  tsconfig: "./tsconfig.json",
  entryPoints: ["src/index.tsx"],
  target: ['node12'],
  loader: {
    ".png": "file",
    ".jpg": "file",
    ".gif": "file",
    ".svg": "file",
    ".node": "file"
  },
  plugins: [
    {
      name: "Native Addon",
      setup(build) {
        build.onResolve({ filter: /\.node$/ }, async (arg) => {
          const pluginName = arg.path.split("/").reverse()[0]
          mkdir(join(process.cwd(), "dist"), {recursive: true})
          await copyFile(join(arg.resolveDir, arg.path), join(process.cwd(), "dist", pluginName))
          return {
            external: true,
            path: "./"+pluginName,
            namespace: "js",
            pluginName
          }
        })
      }
    },
  ]
}).catch(() => process.exit(1));