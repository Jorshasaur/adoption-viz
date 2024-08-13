// The source code including full typescript support is available at: 
// https://github.com/shakacode/react_on_rails_demo_ssr_hmr/blob/master/config/webpack/serverWebpackConfig.js

const { merge, config } = require('shakapacker');
const commonWebpackConfig = require('./commonWebpackConfig');

const webpack = require('webpack');

const configureServer = () => {
  // We need to use "merge" because the clientConfigObject, EVEN after running
  // toWebpackConfig() is a mutable GLOBAL. Thus any changes, like modifying the
  // entry value will result in changing the client config!
  // Using webpack-merge into an empty object avoids this issue.
  const serverWebpackConfig = commonWebpackConfig();
  

  return serverWebpackConfig;
};

module.exports = configureServer;
