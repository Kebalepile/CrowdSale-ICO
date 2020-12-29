const path = require('path'),
	HTMLWebpackPlugin = require('html-webpack-plugin');

module.exports = {
	mode: 'development',
	module: {
		rules: [
			{
				test: /\.(png|jpg)$/,
				use: ['file-loader'],
			},
			{
				test: /\.css$/,
				use: ['style-loader', 'css-loader'],
			},
			// {
			// 	test: /\.js$/,
			// 	exclude: /node_modules/,
			// },
		],
	},
	plugins: [new HTMLWebpackPlugin({ template: './src/index.html' })],
	devServer: {
		contentBase: path.resolve(__dirname, 'dist'),
		index: 'index.html',
		port: 9000,
	},
};
