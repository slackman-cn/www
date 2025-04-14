const path = require('path');
const UglifyJSPlugin = require('uglifyjs-webpack-plugin');
 
module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, './')
  },
  plugins: [
    new UglifyJSPlugin()
  ],
  module: {
    rules: [
        {
            test: /\.css$/, // 正则表达式，表示.css后缀的文件
            use: ['style-loader','css-loader'] // 针对css文件使用的loader，注意有先后顺序，数组项越靠后越先执行
        }
    ]
},
};