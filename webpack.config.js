const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

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
  ],
  devServer: {
    inline: true,
    stats: {
      colors: true,
    },
  },
};
