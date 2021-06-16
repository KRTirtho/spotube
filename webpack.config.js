const path = require("path");
const webpack = require("webpack");
const ForkTsCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const { ESBuildMinifyPlugin } = require("esbuild-loader")


module.exports = (env, argv) => {
  /**
   * @type {import("webpack").Configuration}
   */
  const config = {
    mode: "production",
    entry: ["./src/index.tsx"],
    target: "node",
    output: {
      path: path.resolve(__dirname, "dist"),
      filename: "index.js",
    },
    module: {
      rules: [
        {
          test: /\.js?$/,
          exclude: /node_modules/,
          loader: 'esbuild-loader',
          options: {
            loader: 'jsx',
            target: 'es2015'
          },
        },
        {
          test: /\.tsx?$/,
          exclude: /node_modules/,
          loader: 'esbuild-loader',
          options: {
            loader: 'tsx',
            target: 'es2015'
          },
        },
        {
          test: /\.ts?$/,
          exclude: /node_modules/,
          loader: 'esbuild-loader',
          options: {
            loader: 'ts',
            target: 'es2015'
          },
        },
        {
          test: /\.(png|jpe?g|gif|svg|bmp|otf)$/i,
          use: [
            {
              loader: "file-loader",
              options: { publicPath: "dist" },
            },
          ],
        },
        {
          test: /\.node/i,
          use: [
            {
              loader: "native-addon-loader",
              options: { name: "[name]-[hash].[ext]" },
            },
          ],
        },
      ],
    },
    plugins: [
      new webpack.DefinePlugin({"global.GENTLY": false}),
      new CleanWebpackPlugin(),
    ],
    optimization: {
      minimizer: [
        new ESBuildMinifyPlugin({target: 'es2015'})
      ]
    },
    resolve: {
      extensions: [".tsx", ".ts", ".js", ".jsx", ".json"],
    },
  };

  if (argv.mode === "development") {
    config.mode = "development";
    config.plugins.push(new webpack.HotModuleReplacementPlugin());
    config.plugins.push(
      new ForkTsCheckerWebpackPlugin()
    );
    config.devtool = "source-map";
    config.watch = true;
    config.entry.unshift("webpack/hot/poll?100");
  }

  return config;
};
