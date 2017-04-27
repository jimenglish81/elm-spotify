const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');

module.exports = {
  entry: {
    app: [
      './src/index.js',
    ],
  },
  output: {
    path: path.resolve(`${__dirname}dist`),
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [
          /elm-stuff/,
          /node_modules/,
        ],
        loader: 'elm-webpack-loader?verbose=true&warn=true',
      },
      {
        use: ['style-loader', 'css-loader'],
        test: /\.css$/
      },
    ],
    noParse: /\.elm$/,
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/index.html',
    }),
    new webpack.DefinePlugin({
      SPOTIFY_CLIENT_ID: process.env.SPOTIFY_CLIENT_ID,
      SPOTIFY_REDIRECT_URL: process.env.SPOTIFY_REDIRECT_URL,
    }),
  ],
  devServer: {
    inline: true,
    stats: {
      colors: true,
    },
  },
};
